local ts_draw = {}
local mymenu = {}
local utils = {}
local base_name = "Klee_ts"
local my_name = player.charName

local TS = module.internal('TS')
local orb = module.internal('orb')
local ts_preset = module.load(header.id, "target_selector/ts_mode_preset")
local damagelib = module.internal('damagelib')
local pred = module.internal('pred')

local target_selector =
{
    filters = {},
    active_filter = nil,
    priorities =
    {
        time = {},
        _pairs = {}
    },

    q_ready = false,
    w_ready = false,
    e_ready = false
}
target_selector._DEBUG = false

--#region menu
local ts_modes = {
    "Script",
    "AP damage",
    "AD damage",

    "Least health",

    "Less AA",
    "Less casts",

    "Priority list"
}

local ts_draw_modes = {
    "Disabled",
    "Two arcs",
    "One arc",
    "Circle",
    "Triangles",
    "Sonar",
}

local ts_priorities_perchampion = {}

local force_target = {
    target = nil,
    last_selector_t = 0
}

local pred_input = {
    _type = nil,
    _input = nil,
}

function mymenu:_load_ts_menu_fn()
    if hanbot.language == 2 then
        mymenu = menu(base_name, "Klee: Target selector - " .. my_name)
        mymenu:header(base_name, "Klee Target selector: " .. my_name)

        local icon_klee = graphics.sprite('Resource/klee.png')
        if icon_klee then
            mymenu:set('icon', icon_klee)
        end

        mymenu:menu("mode_settings", "Mode settings")
        --#region mode_settings
        mymenu.mode_settings:header("mode_settings_header", "Mode")
        --local default_mode = ts_preset and (ts_preset:get_default_ts_priority(player.charName) + 1) or 1

        mymenu.mode_settings:dropdown("ts_mode_" .. player.charName:lower(),
            string.format("Mode (%s)", player.charName), 1, ts_modes)
        --mymenu.mode_settings["ts_mode_"..player.charName:lower( )]:set( 'icon', player.iconSquare )
        mymenu.mode_settings:boolean("ts_prio_debuff", "Prioritize targets with debuffs", true)

        mymenu.mode_settings:header("priority_header", "Priority")
        mymenu.mode_settings:header("priority_header_1", "[low] 1, 2, 3, 4, 5 [hight]")
        for _, v in pairs(utils:get_enemies())
        do
            if v and not mymenu.mode_settings["priority_" .. v.charName:lower()]
            then
                local prio = ts_preset and (ts_preset:get_default_priority(v.charName) + 0) or 3
                mymenu.mode_settings:slider("priority_" .. v.charName:lower(), v.charName, prio, 0, 5, 1)
                --mymenu.mode_settings[ "priority_"..v.charName:lower( ) ]:set( 'icon', v.iconSquare )

                table.insert(ts_priorities_perchampion, mymenu.mode_settings["priority_" .. v.charName:lower()])
            end
        end
        --#region cb
        local ts_mode_change = function()
            local mode = mymenu.mode_settings["ts_mode_" .. player.charName:lower()]:get()

            local is_custom = mode == 7

            mymenu.mode_settings.priority_header:set("visible", is_custom)
            mymenu.mode_settings.priority_header_1:set("visible", is_custom)

            for _, v in pairs(ts_priorities_perchampion)
            do
                v:set("visible", is_custom)
            end
            --chat.print("target_selector: ts_mode_change")
        end
        mymenu.mode_settings["ts_mode_" .. player.charName:lower()]:set('callback',
            function(w) ts_mode_change() end)
        ts_mode_change()

        mymenu.mode_settings:header("header_end", "")
        --#endregion
        --#endregion

        mymenu:menu("draw_settings", "Draw settings")
        --#region draw_settings
        -- local icon_colors = graphics.sprite('Resource/circle_icon.png')
        -- if icon_colors then
        --     mymenu.draw_settings:set('icon', icon_colors)
        -- end

        mymenu.draw_settings:header("draw_settings_header", "Draw settings")

        mymenu.draw_settings:menu("selected_target", "Selected target")
        mymenu.draw_settings:menu("notification", "Notification")

        --#region notification
        mymenu.draw_settings.notification:slider("x", "Position X", graphics.width / 2, 0, graphics.width, 1)
        mymenu.draw_settings.notification:slider("y", "Position Y", 80, 0, graphics.height, 1)

        mymenu.draw_settings.notification.x:set("visible", false); mymenu.draw_settings.notification.y:set("visible",
            false)

        mymenu.draw_settings.notification:color("e_text_color", "Text color", 245, 246, 250, 255)
        mymenu.draw_settings.notification:color("e_active_text_color", "Active text color", 29, 209, 161, 255)
        mymenu.draw_settings.notification:color("background_color", "Background color", 44, 62, 80, 120)
        mymenu.draw_settings.notification:dropdown("e_icon_animation", "Icon animation", 2,
            { "Disabled", "Two arcs", "One arc" })
        mymenu.draw_settings.notification:slider("e_icon_arc_angle", "Arc angle", 180, 30, 300, 1)

        mymenu.draw_settings.notification:color("color11", "Color 1", 255, 234, 167, 255)
        mymenu.draw_settings.notification:color("color22", "Color 2", 30, 39, 46, 255)
        --#endregion

        --#region selected_target
        mymenu.draw_settings.selected_target:header("selected_target_header", "Selected target")
        mymenu.draw_settings.selected_target:dropdown("mode", "Draw selected target", 2, ts_draw_modes)
        mymenu.draw_settings.selected_target:slider("arc_angle", "Arc angle", 180, 30, 300, 1)
        mymenu.draw_settings.selected_target:color("color1", "Color 1", 255, 234, 167, 255)
        mymenu.draw_settings.selected_target:color("color2", "Color 2", 30, 39, 46, 255)
        mymenu.draw_settings.selected_target:slider("line_width", "Line width", 2, 1, 8, 1)
        --#endregion

        mymenu:header("force_target_heard", "Force target")
        mymenu:keybind("force_target", "Force target", 'LMB')
        mymenu:button("select_target_lbm", " ^ - Change to", "Left mouse click", function()
            mymenu.force_target.key = 'LMB'
        end)
        mymenu:slider("force_target_sec", "Time out (sec)", 5, 0, 10, 1)
        mymenu:slider("range", "Mouse range", 400, 0, 1000, 1)
        mymenu:keybind("force_select", "Attack only selected", nil, nil)
    elseif hanbot.language == 1 then
        mymenu = menu(base_name, "Klee: 目标选择器 - " .. my_name)
        mymenu:header(base_name, "Klee 目标选择器: " .. my_name)

        local icon_klee = graphics.sprite('Resource/klee.png')
        if icon_klee then
            mymenu:set('icon', icon_klee)
        end

        mymenu:menu("mode_settings", "模式设置")
        --#region mode_settings
        mymenu.mode_settings:header("mode_settings_header", "模式")
        --local default_mode = ts_preset and (ts_preset:get_default_ts_priority(player.charName) + 1) or 1

        mymenu.mode_settings:dropdown("ts_mode_" .. player.charName:lower(),
            string.format("模式 (%s)", player.charName), 1, ts_modes)
        --mymenu.mode_settings["ts_mode_"..player.charName:lower( )]:set( 'icon', player.iconSquare )
        mymenu.mode_settings:boolean("ts_prio_debuff", "优先减益目标", true)

        mymenu.mode_settings:header("priority_header", "优先")
        mymenu.mode_settings:header("priority_header_1", "[低] 1, 2, 3, 4, 5 [高]")
        for _, v in pairs(utils:get_enemies())
        do
            if v and not mymenu.mode_settings["priority_" .. v.charName:lower()]
            then
                local prio = ts_preset and (ts_preset:get_default_priority(v.charName) + 0) or 3
                mymenu.mode_settings:slider("priority_" .. v.charName:lower(), v.charName, prio, 0, 5, 1)
                --mymenu.mode_settings[ "priority_"..v.charName:lower( ) ]:set( 'icon', v.iconSquare )

                table.insert(ts_priorities_perchampion, mymenu.mode_settings["priority_" .. v.charName:lower()])
            end
        end
        --#region cb
        local ts_mode_change = function()
            local mode = mymenu.mode_settings["ts_mode_" .. player.charName:lower()]:get()

            local is_custom = mode == 7

            mymenu.mode_settings.priority_header:set("visible", is_custom)
            mymenu.mode_settings.priority_header_1:set("visible", is_custom)

            for _, v in pairs(ts_priorities_perchampion)
            do
                v:set("visible", is_custom)
            end
            --chat.print("target_selector: ts_mode_change")
        end
        mymenu.mode_settings["ts_mode_" .. player.charName:lower()]:set('callback',
            function(w) ts_mode_change() end)
        ts_mode_change()

        mymenu.mode_settings:header("header_end", "")
        --#endregion
        --#endregion

        mymenu:menu("draw_settings", "绘制设置")

        mymenu.draw_settings:header("draw_settings_header", "绘制设置")

        mymenu.draw_settings:menu("selected_target", "选择目标")
        mymenu.draw_settings:menu("notification", "通知")

        --#region notification
        mymenu.draw_settings.notification:slider("x", "Position X", graphics.width / 2, 0, graphics.width, 1)
        mymenu.draw_settings.notification:slider("y", "Position Y", 80, 0, graphics.height, 1)

        mymenu.draw_settings.notification.x:set("visible", false); mymenu.draw_settings.notification.y:set("visible",
            false)

        mymenu.draw_settings.notification:color("e_text_color", "文字颜色", 245, 246, 250, 255)
        mymenu.draw_settings.notification:color("e_active_text_color", "启用文字颜色", 29, 209, 161, 255)
        mymenu.draw_settings.notification:color("background_color", "背景颜色", 44, 62, 80, 120)
        mymenu.draw_settings.notification:dropdown("e_icon_animation", "图标动画", 2,
            { "禁用", "Two arcs", "One arc" })
        mymenu.draw_settings.notification:slider("e_icon_arc_angle", "弧角度", 180, 30, 300, 1)

        mymenu.draw_settings.notification:color("color11", "颜色1", 255, 234, 167, 255)
        mymenu.draw_settings.notification:color("color22", "颜色2", 30, 39, 46, 255)
        --#endregion

        --#region selected_target
        mymenu.draw_settings.selected_target:header("selected_target_header", "选择目标")
        mymenu.draw_settings.selected_target:dropdown("mode", "绘制选择目标", 2, ts_draw_modes)
        mymenu.draw_settings.selected_target:slider("arc_angle", "弧角度", 180, 30, 300, 1)
        mymenu.draw_settings.selected_target:color("color1", "颜色1", 255, 234, 167, 255)
        mymenu.draw_settings.selected_target:color("color2", "颜色2", 30, 39, 46, 255)
        mymenu.draw_settings.selected_target:slider("line_width", "线宽", 2, 1, 8, 1)
        --#endregion

        mymenu:header("force_target_heard", "强制目标")
        mymenu:keybind("force_target", "强制目标", 'LMB')
        mymenu:button("select_target_lbm", " ^ - 换成", "左键", function()
            mymenu.force_target.key = 'LMB'
        end)
        mymenu:slider("force_target_sec", "过期时间 (秒)", 5, 0, 10, 1)
        mymenu:slider("range", "鼠标距离", 400, 0, 1000, 1)
        mymenu:keybind("force_select", "只攻击选择目标", nil, nil)
    end
end

--#endregion

--#region draw
function ts_draw:draw_debug()
    if not self._DEBUG or not TS then return end

    local active_filter = TS.get_active_filter()

    local filter_name = active_filter and active_filter.name or "none"
    local filter_set = TS.filter_set or {}

    local pos = vec2(200, 200)

    local text = string.format("active_filter: [%s]\nfilters: [%d]", filter_name, #filter_set)
    local text_size = { graphics.text_area(text, 26) }

    graphics.draw_text_2D(text, 26, pos.x, pos.y, 0xFFFFFFFF)

    pos.y = pos.y + text_size[2] + 2

    for k, v in pairs(filter_set)
    do
        text_size = { graphics.text_area(v.name, 26) }
        graphics.draw_text_2D(v.name, 26, pos.x, pos.y, 0xFFFFFFFF)
        pos.y = pos.y + text_size[2] + 2
    end

    pos.y = pos.y + text_size[2] + 2

    filter_set = (orb ~= nil and orb.ts) and orb.ts.filter_set or {}
    active_filter = (orb ~= nil and orb.ts) and orb.ts.get_active_filter() or nil
    filter_name = active_filter and active_filter.name or "none"
    text = string.format("orb_active_filter: [%s]\norb_filters: [%d]", filter_name, #filter_set)
    local text_size = { graphics.text_area(text, 26) }
    graphics.draw_text_2D(text, 26, pos.x, pos.y, 0xFFFFFFFF)

    pos.y = pos.y + text_size[2] + 2

    if TS.priorities and TS.priorities._pairs
    then
        for k, v in pairs(TS.priorities._pairs)
        do
            text_size = { graphics.text_area(string.format("%d: %.1f", v.i, v.f), 26) }
            graphics.draw_text_2D(string.format("%d: %.1f", v.i, v.f), 26, pos.x, pos.y, 0xFFFFFFFF)
            pos.y = pos.y + text_size[2] + 2
        end
    end
end

function ts_draw:draw_target(i, target, mode, color_1, color_2, line_w, _arc_angle1)
    if mode == 1 then
        return
    end

    if mode == 2 --2 arcs
    then
        local period = 3.0

        local animation_phase = math.fmod(game.time, period) / period

        local angle_1 = 0 + 360 * animation_phase
        local angle_2 = angle_1 + (_arc_angle1 / 2)

        if angle_2 > 360.0
        then
            angle_1 = angle_1 - 360.0
            angle_2 = angle_2 - 360.0
        end

        utils:draw_gradient_arc(target.pos, target.boundingRadius * 1.75, angle_1, angle_2,
            color_2,
            color_1,
            line_w, 22,
            vec3(0, 0, 0));

        utils:draw_gradient_arc(target.pos, target.boundingRadius * 1.75, angle_1 + 180.0, angle_2 + 180.0,
            color_2,
            color_1,
            line_w, 22,
            vec3(0, 0, 0));
    elseif mode == 3 --1 arc
    then
        local period = 3.0

        local phase = math.fmod(game.time, period) / period;
        local animation_phase = math.fmod(phase, 1.0);

        local angle_1 = 0 + 360 * animation_phase;
        local angle_2 = angle_1 + _arc_angle1;

        utils:draw_gradient_arc(target.pos, target.boundingRadius * 1.75, angle_1, angle_2,
            color_2,
            color_1,
            line_w, 22,
            vec3(0, 0, 0));
    elseif mode == 4 --circle
    then
        utils:draw_circle(string.format("Klee_ts_shader_%d", i), target, target.boundingRadius * 1.75, color_1, color_2,
            line_w)
    elseif mode == 5 --triangles
    then
        local radius = target.boundingRadius * (1 + 0.75);

        local vertex1 = target.pos + vec3(0, radius, 0);                               --top
        local vertex2 = target.pos + vec3(-radius * math.sqrt(3) / 2, -radius / 2, 0); --bottom l
        local vertex3 = target.pos + vec3(radius * math.sqrt(3) / 2, -radius / 2, 0);  --bottom r

        local rot = 360 * math.fmod(1.75 * game.time, 4) / 4;

        vertex1 = target.pos + (vertex1 - target.pos):rotate(math.rad(rot));
        vertex2 = target.pos + (vertex2 - target.pos):rotate(math.rad(rot));
        vertex3 = target.pos + (vertex3 - target.pos):rotate(math.rad(rot));

        graphics.draw_line(vertex1, vertex2, line_w, color_1, color_2);
        graphics.draw_line(vertex1, vertex3, line_w, color_1, color_2);
        graphics.draw_line(vertex2, vertex3, line_w, color_1, color_2);
    elseif mode == 6
    then
        local max_radius = target.boundingRadius * 1.5;

        graphics.draw_circle(target.pos, math.fmod(max_radius * game.time, max_radius), line_w,
            utils:set_alpha(color_1, 255 * (1 - math.fmod(max_radius * game.time, max_radius) / max_radius)), 32)
    end
end

function ts_draw:draw_targets()
    if utils:is_valid(force_target.target) then
        self:draw_target(1, force_target.target, mymenu.draw_settings.selected_target.mode:get(),
            mymenu.draw_settings.selected_target.color1:get(),
            mymenu.draw_settings.selected_target.color2:get(),
            mymenu.draw_settings.selected_target.line_width:get(),
            mymenu.draw_settings.selected_target.arc_angle:get())
    end
end

local function on_draw_sprite(target)
    --icon = 40*40
    local use_chinese = hanbot.language == 1;
    --local DPI_FACTOR = (graphics.height > 1080) and (graphics.height / 1080 * 0.905) or (1.0)

    local font_size = 20
    local icon_x, icon_y = 40, 40
    local text = use_chinese and "目標選擇: " .. target.charName or "Selected target: " .. target.charName
    local text_x, _ = graphics.text_area(text, font_size)
    local text_forced = use_chinese and "您不会攻击其他目标！" or "You will not attack other targets!";
    local offset_x, offset_y = 3 * 20, 2 * 10

    local info_x, info_y = icon_x + text_x + offset_x, icon_y + offset_y
    local start = vec2(graphics.width / 2, 60) - vec2(info_x / 2, 0)
    local text_start = mymenu.force_select:get() and start + vec2(icon_x + offset_x / 2, offset_y / 2 + font_size / 2)
        or
        start + vec2(icon_x + offset_x / 2, offset_y / 2 + font_size)
    local icon_start = start + vec2(offset_x / 3, offset_y / 2 + 2)

    utils:draw_rounded_rect("notification_background", start, vec2(info_x, info_y), 30,
        mymenu.draw_settings.notification.background_color:get())

    local icon_target = target.iconCircle --Circle
    if icon_target then
        graphics.draw_sprite(icon_target, icon_start, 0.3, 0xFFFFFFFF)
    end

    graphics.draw_text_2D(text, font_size, text_start.x, text_start.y,
        mymenu.draw_settings.notification.e_text_color:get())

    if mymenu.force_select:get() then --text_start.x, text_start.y
        local color4 = utils:animate_color(mymenu.draw_settings.notification.e_active_text_color:get(), 120, 255, 3)
        graphics.draw_text_2D(text_forced, font_size / 3 * 2, text_start.x, text_start.y + 22, color4)
    end

    --#region icon_animation
    local icon_anim = mymenu.draw_settings.notification.e_icon_animation:get()
    if icon_anim == 2
    then
        local period = 3.0

        local phase = math.fmod(game.time, period) / period
        local animation_phase = math.fmod(phase, 1.0)

        local angle_1 = 0 + 360 * animation_phase
        local angle_2 = angle_1 + mymenu.draw_settings.notification.e_icon_arc_angle:get()

        if angle_2 > 360
        then
            angle_2 = angle_2 - 360
            angle_1 = angle_1 - 360
        end

        local color_1 = mymenu.draw_settings.notification.color11:get()
        local color_2 = mymenu.draw_settings.notification.color22:get()

        utils:draw_gradient_arc_screen(
            icon_start + vec2(17, 17),
            20,
            angle_1, angle_2,
            color_2, color_1,
            2, 16,
            vec2(0.0001, 0.0001));

        utils:draw_gradient_arc_screen(
            icon_start + vec2(17, 17),
            20,
            angle_1 + 180, angle_2 + 180,
            color_2, color_1,
            2, 16,
            vec2(0.0001, 0.0001));
    elseif icon_anim == 3
    then
        local period = 3;

        local phase = math.fmod(game.time, period) / period;
        local animation_phase = -math.fmod(phase, 1.0);

        --//static auto arc_angle = 180.f;
        local angle_1 = 0 + 360 * animation_phase;
        local angle_2 = angle_1 + mymenu.draw_settings.notification.e_icon_arc_angle:get()

        local color_1 = mymenu.draw_settings.notification.color11:get()
        local color_2 = mymenu.draw_settings.notification.color22:get()

        utils:draw_gradient_arc_screen(
            icon_start + vec2(17, 17),
            20, angle_1, angle_2,
            color_1, color_2, 3, 16, vec2(0.0001, 0.0001));
    end
    --#endregion
end

function ts_draw:on_draw()
    if not player or player.isDead then return end

    if keyboard.isKeyDown(0x09) then return end

    --self:draw_debug()
    self:draw_targets()

    if force_target.target ~= nil
    then
        cb.add(cb.sprite, on_draw_sprite(force_target.target))
    end
end

function ts_draw:bind_callbacks()
    cb.add(cb.draw, function()
        ts_draw:on_draw()
    end)
end

--#endregion

--#region target_selector
local function get_force_target()
    local min_dis = 999999
    local target = nil
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local dist = enemy.pos:dist(mousePos)
        if utils:is_valid(enemy) and dist < mymenu.range:get() and dist < min_dis then
            target = enemy
            min_dis = dist
        end
    end
    return target
end

function target_selector:on_tick()
    if not player or player.isDead then return end

    self.q = player:spellSlot(0)
    self.q_ready = self.q and self.q.level > 0 and self.q.state == 0

    self.w = player:spellSlot(1)
    self.w_ready = self.w and self.w.level > 0 and self.w.state == 0

    self.e = player:spellSlot(2)
    self.e_ready = self.e and self.e.level > 0 and self.e.state == 0

    self.r = player:spellSlot(3)
    self.r_ready = self.r and self.r.level > 0 and self.r.state == 0

    if mymenu.force_target:get() then
        force_target.target = get_force_target()
    end
    if force_target.target and force_target.target.isVisible then --and force_target.last_selector_t < game.time
        force_target.last_selector_t = game.time + mymenu.force_target_sec:get()
    end
    if force_target.target and not force_target.target.isVisible and game.time > force_target.last_selector_t then
        force_target.target = nil
    end
    if force_target.target and force_target.target.isDead then
        force_target.target = nil
    end
end

local ts_dist = 0
local is_pred = false
local include_radius = false
local white_list = nil
local ignore_function = nil

local user_filter = TS.filter.new()
user_filter.name = 'User'
user_filter.rank = { 0.33, 0.66, 1.0, 1.33, 1.66 }
user_filter.index = function(obj, rank_val)
    return -mymenu.mode_settings["priority_" .. obj.charName:lower()]:get()
end

local ad_filter = TS.filter.new()
ad_filter.name = 'AD'
ad_filter.rank = { 0.33, 0.66, 1.0, 1.33, 1.66 }
ad_filter.index = function(obj, rank_val)
    local function get_hp(target)
        local ad_hp = utils:get_real_hp(target, true, true)
        local ar = (target.armor / (target.armor + 100))
        local hp = ad_hp / (1 - ar)
        return hp
    end
    return get_hp(obj)
end

local ap_filter = TS.filter.new()
ap_filter.name = 'AP'
ap_filter.rank = { 0.33, 0.66, 1.0, 1.33, 1.66 }
ap_filter.index = function(obj, rank_val)
    local function get_hp(target)
        local ap_hp = utils:get_real_hp(target, true, false, true)
        local mr = (target.spellBlock / (target.spellBlock + 100))
        local hp = ap_hp / (1 - mr)
        return hp
    end
    return get_hp(obj)
end

local true_filter = TS.filter.new()
true_filter.name = 'True'
true_filter.rank = { 0.33, 0.66, 1.0, 1.33, 1.66 }
true_filter.index = function(obj, rank_val)
    local function get_hp(target)
        local hp = utils:get_real_hp(target, true)
        return hp
    end
    return get_hp(obj)
end

local AA_filter = TS.filter.new()
AA_filter.name = 'True'
AA_filter.rank = { 0.33, 0.66, 1.0, 1.33, 1.66 }
AA_filter.index = function(obj, rank_val)
    local function get_hp(target)
        local hit = utils:get_real_hp(target, true) / damagelib.calc_aa_damage(player, obj, true)
        return hit
    end
    return get_hp(obj)
end

local function ts_filter(res, obj, dist)
    local range = include_radius and player.boundingRadius + obj.boundingRadius or 0
    if dist > ts_dist + range or not utils:is_valid(obj) then return false end

    if white_list
        and
        (not white_list[obj.charName:lower()] or not white_list[obj.charName:lower()]:get())
    then
        return false
    end
    if ignore_function and ignore_function(obj)
    then
        return false
    end
    if is_pred then
        local seg =
            (pred_input._type == "line" and pred.linear.get_prediction(pred_input._input, obj))
            or
            (pred_input._type == "circle" and pred.circular.get_prediction(pred_input._input, obj))
        if not seg then return false end
        if pred_input._type == "line" and pred.collision.get_prediction(pred_input._input, seg, obj) then return false end

        res.obj = obj
        return true
    end
    res.obj = obj
    return true
end

-- #endregion

local function on_tick()
    if mymenu.force_target:get() then
        force_target.target = get_force_target()
    end
    if force_target.target and force_target.target.isVisible then --and force_target.last_selector_t < game.time
        force_target.last_selector_t = game.time + mymenu.force_target_sec:get()
    end
    if force_target.target and not force_target.target.isVisible and game.time > force_target.last_selector_t then
        force_target.target = nil
    end
    if force_target.target and force_target.target.isDead then
        force_target.target = nil
    end
end

function target_selector:get_target(range, _type, include_hitbox, _menu_whitelist, _ignore_function, _pred_type)
    local radius = include_hitbox and force_target.target and player.boundingRadius + force_target.target.boundingRadius
        or
        0
    if (_type == "Force" or mymenu.force_select:get()) and utils:is_valid(force_target.target) then
        if force_target.target.pos:dist(player.pos) < range + radius then
            return force_target.target
        else
            return nil
        end
    end
    if utils:is_valid(force_target.target) and force_target.target.pos:dist(player.pos) < range + radius then
        return force_target.target
    end
    --local res = TS.get_result(ts_filter, user_filter)

    ts_dist = range
    is_pred = _type and _type.range and _pred_type and true or false
    include_radius = include_hitbox
    white_list = _menu_whitelist
    ignore_function = _ignore_function


    -- 1 = script
    -- 2 = AP
    -- 3 = AD
    -- 4 = low hp
    -- 5 = less aa
    -- 6 = less casts
    -- 7 = list

    local user = mymenu.mode_settings["ts_mode_" .. player.charName:lower()]:get()

    if user == 7 then --list
        local res = TS.get_result(ts_filter, user_filter)
        return res.obj
    elseif user == 3 or (user == 1 and _type == "AD") then
        local res = TS.get_result(ts_filter, ad_filter)
        return res.obj
    elseif user == 2 or (user == 1 and _type == "AP") then
        local res = TS.get_result(ts_filter, ap_filter)
        return res.obj
    elseif user == 4 or (user == 1 and _type == "True") or _type == nil then --or type(_type) == "table" or _type == nil then
        local res = TS.get_result(ts_filter, true_filter)
        return res.obj
    elseif type(_type) == "table" then
        if _type.range and _pred_type then
            pred_input._input = _type
            pred_input._type = _pred_type
            local res = TS.get_result(ts_filter)
            return res.obj
        end
        return nil
    elseif user == 5 then
        local res = TS.get_result(ts_filter, AA_filter)
        return res.obj
    elseif user == 6 then
        local res = TS.get_result(ts_filter, spell_filter)
        return res.obj
    end
    return nil

    --[[
        local target_list = {}
        local Obj = objManager.enemies
        local Obj_size = objManager.enemies_n
        for i = 0, Obj_size - 1 do
            local target = Obj[i]

            local function filter()
                if not utils:is_valid(target) then
                    return false
                end
                if target.pos:dist(player.pos) > range + radius then
                    return false
                end
                if _menu_whitelist then
                    if not _menu_whitelist[target.charName:lower()] or not _menu_whitelist[target.charName:lower()]:get() then
                        return false
                    end
                end
                --extra check
                if _ignore_function and _ignore_function(target) then
                    return false
                end

                if _type and _type.range and _pred_type then
                    local seg =
                        _pred_type == "line" and pred.linear.get_prediction(pred_input._input, target)
                        or
                        _pred_type == "circle" and pred.circular.get_prediction(pred_input._input, target)
                    if not seg then return false end

                    if _pred_type == "line" and pred.collision.get_prediction(pred_input._input, seg, target) then return false end
                end
                return true
            end
            if filter() then
                target_list[#target_list + 1] = target
            end
        end

        if #target_list < 1 then return nil end


        -- 1 = script
        -- 2 = AP
        -- 3 = AD
        -- 4 = low hp
        -- 5 = less aa
        -- 6 = less casts
        -- 7 = list

        local user = mymenu.mode_settings["ts_mode_" .. player.charName:lower()]:get()

        if user == 7 then --list
            table.sort(target_list, function(a, b)
                local a_number = mymenu.mode_settings["priority_" .. a.charName:lower()]:get()
                local b_number = mymenu.mode_settings["priority_" .. b.charName:lower()]:get()

                if a_number == b_number then
                    return a.health < b.health
                else
                    return a_number > b_number
                end
            end)
        elseif user == 3 or (user == 1 and _type == "AD") then
            local function get_hp(target)
                local ad_hp = utils:get_real_hp(target, true, true)
                local ar = (target.armor / (target.armor + 100))
                local hp = ad_hp / (1 - ar)
                return hp
            end
            table.sort(target_list, function(a, b)
                return get_hp(a) < get_hp(b)
            end)
        elseif user == 2 or (user == 1 and _type == "AP") then
            local function get_hp(target)
                local ap_hp = utils:get_real_hp(target, true, false, true)
                local mr = (target.spellBlock / (target.spellBlock + 100))
                local hp = ap_hp / (1 - mr)
                return hp
            end
            table.sort(target_list, function(a, b)
                return get_hp(a) < get_hp(b)
            end)
        elseif user == 4 or (user == 1 and _type == "True") or type(_type) == "table" or _type == nil then
            local function get_hp(target)
                local hp = utils:get_real_hp(target, true)
                return hp
            end
            table.sort(target_list, function(a, b)
                return get_hp(a) < get_hp(b)
            end)
        elseif user == 5 then
            local function get_hit(target)
                local hit = utils:get_real_hp(target, true) / damagelib.calc_aa_damage(player, target, true)
                return hit
            end
            table.sort(target_list, function(a, b)
                return get_hit(a) < get_hit(b)
            end)
        elseif user == 6 then
            local function get_hit(target)
                local d = 0
                if self.q_ready and self.q_name
                then
                    d = d + damagelib.get_spell_damage(self.q_name, 0, player, target, false, 0)
                end

                if self.w_ready and self.w_name
                then
                    d = d + damagelib.get_spell_damage(self.w_name, 1, player, target, false, 0)
                end

                if self.e_ready and self.e_name
                then
                    d = d + damagelib.get_spell_damage(self.e_name, 2, player, target, false, 0)
                end

                if self.r_ready and self.r_name
                then
                    d = d + damagelib.get_spell_damage(self.r_name, 2, player, target, false, 0)
                end

                if d <= 0
                then
                    return utils:get_real_hp(target, true)
                end

                return utils:get_real_hp(target, true) - d
            end
            table.sort(target_list, function(a, b)
                return get_hit(a) < get_hit(b)
            end)
        end

        return target_list[1]

    ]]
end

function target_selector:load(_utils)
    utils = _utils

    mymenu:_load_ts_menu_fn()

    if TS then
        if TS.menu.lc_key then
            TS.menu.lc_key:set('key', "nil")
            TS.menu.lc_key:set('toggle', "nil")
        end
        if TS.menu.lc_circle then
            TS.menu.lc_circle:set('value', false)
        end
    end

    self.q_name = player:spellSlot(0) and player:spellSlot(0).name or ""
    self.w_name = player:spellSlot(1) and player:spellSlot(1).name or ""
    self.e_name = player:spellSlot(2) and player:spellSlot(2).name or ""
    self.r_name = player:spellSlot(3) and player:spellSlot(3).name or ""

    ts_draw:bind_callbacks()

    cb.add(cb.tick, function()
        on_tick()
    end)
end

--#endregion

return target_selector
