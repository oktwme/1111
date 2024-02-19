local Briar = {}

---@type utils
local utils = module.load(header.id, "Help/utils")
local my_name = player.charName

local mymenu
if hanbot.language == 2 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name .. " - Premium")
    mymenu:header(my_name, "Klee: " .. my_name .. " - Premium")

    mymenu:set("icon", player.iconSquare)
    -- local icon_klee = graphics.sprite('Resource/klee.png')
    -- if icon_klee
    -- then
    --     mymenu:set('icon', icon_klee)
    -- end

    utils:menu_utils(mymenu)

    mymenu:header("header_1", "Q")
    mymenu:boolean("q_ks", "Killsteal", true)
    mymenu:boolean("q_jg", "Jungle Q", true)
    mymenu:header("header_2.0", "W")
    mymenu:boolean("w_jg", "Jungle W", true)
    mymenu:header("header_2", "W2")
    mymenu:boolean("w_ks", "Logic", true)
    mymenu:header("header_3", "E")
    mymenu:boolean("e_jg", "Jungle E", true)

    mymenu:header("header_4", "Draw")
    mymenu:boolean("Q", "Draw Q range", true)
    mymenu.Q:set('icon', player:spellSlot(_Q).icon)
    mymenu:boolean("R", "Draw R range", true)
    mymenu.R:set('icon', player:spellSlot(_R).icon)
    mymenu:boolean("q_damage", "Draw Q damage", true)
    mymenu.q_damage:set('icon', player:spellSlot(_Q).icon)
    mymenu:boolean("w_damage", "Draw W2 damage", true)
    mymenu.w_damage:set('icon', player:spellSlot(_W).icon)
    mymenu:boolean("e_damage", "Draw E damage", false)
    mymenu.e_damage:set('icon', player:spellSlot(_E).icon)
    mymenu:slider("aa_damage", "Draw AA damage", 1, 0, 5, 1)
    mymenu:boolean("state", "Draw state", true)
    mymenu:slider("size", "Text size", 30, 20, 40, 1)

    mymenu:header("2", "Key")
    mymenu:keybind("semi_q", "Semi Q", 'Q', nil)
    mymenu:keybind("semi_r", "Semi R", 'T', nil)
    mymenu:keybind("sf", "SpellFarm", nil, 'MMB')

    mymenu:header("header_end", "")
elseif hanbot.language == 1 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name .. " - Premium")
    mymenu:header(my_name, "Klee: " .. my_name .. " - Premium")

    mymenu:set("icon", player.iconSquare)
    -- local icon_klee = graphics.sprite('Resource/klee.png')
    -- if icon_klee
    -- then
    --     mymenu:set('icon', icon_klee)
    -- end

    utils:menu_utils(mymenu)

    mymenu:header("header_1", "Q")
    mymenu:boolean("q_ks", "捡人头", true)
    mymenu:boolean("q_jg", "清野Q", true)
    mymenu:header("header_2.0", "W")
    mymenu:boolean("w_jg", "清野W", true)
    mymenu:header("header_2", "W2")
    mymenu:boolean("w_ks", "逻辑", true)
    mymenu:header("header_3", "E")
    mymenu:boolean("e_jg", "清野E", true)

    mymenu:header("header_4", "绘制")
    mymenu:boolean("Q", "绘制Q范围", true)
    mymenu.Q:set('icon', player:spellSlot(_Q).icon)
    mymenu:boolean("R", "绘制R范围", true)
    mymenu.R:set('icon', player:spellSlot(_R).icon)
    mymenu:boolean("q_damage", "绘制Q伤害", true)
    mymenu.q_damage:set('icon', player:spellSlot(_Q).icon)
    mymenu:boolean("w_damage", "绘制W伤害", true)
    mymenu.w_damage:set('icon', player:spellSlot(_W).icon)
    mymenu:boolean("e_damage", "绘制E伤害", false)
    mymenu.e_damage:set('icon', player:spellSlot(_E).icon)
    mymenu:slider("aa_damage", "绘制普攻伤害", 1, 0, 5, 1)
    mymenu:boolean("state", "绘制状态", true)
    mymenu:slider("size", "文字大小", 30, 20, 40, 1)

    mymenu:header("2", "快捷键")
    mymenu:keybind("semi_q", "半手动Q", 'Q', nil)
    mymenu:keybind("semi_r", "半手动R", 'T', nil)
    mymenu:keybind("sf", "发育", nil, 'MMB')

    mymenu:header("header_end", "")
end
local common = utils:menu_common()


local dmg_lib = module.load(header.id, "Help/dmg_lib")
local orb = module.internal('orb')
local pred = module.internal('pred')
local damagelib = module.internal('damagelib')
local ts = module.internal('TS')
local evade = module.seek('evade')

function Briar:load()
    self.is_laneclear = false

    self.last_q_t = 0
    self.q_range = 0
    self.q_ready = false
    self.q_level = 0

    self.last_w_t = 0
    self.w_range = 0
    self.w_ready = false
    self.w_level = 0
    self.w_target = nil

    self.last_e_t = 0
    self.e_range = 0
    self.e_ready = false
    self.e_level = 0

    self.last_r_t = 0
    self.r_range = 0
    self.r_ready = false
    self.r_level = 0
    self.r_pred = {
        delay = 1,
        speed = 2000,
        width = 320,
        boundingRadiusMod = 1,
        range = self.r_range,
        collision = {
            minion = false,
            wall = true,
            hero = true,
        },
    }
end

function Briar:spell_check()
    self.is_laneclear = orb.menu.lane_clear.key:get() and mymenu.sf:get()

    self.q_range = 450
    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0

    self.w_range = 0
    self.w_level = player:spellSlot(1).level
    self.w_ready = self.w_level > 0 and player:spellSlot(1).state == 0

    self.e_range = 400
    self.e_level = player:spellSlot(2).level
    self.e_ready = self.e_level > 0 and player:spellSlot(2).state == 0

    self.r_range = 10000
    self.r_level = player:spellSlot(3).level
    self.r_ready = self.r_level > 0 and player:spellSlot(3).state == 0
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

local ks_loop = 0
function Briar:Automatic()
    if not mymenu.q_ks then return end
    if ks_loop > game.time then return end
    local can_ks = utils:use_automatic(mymenu.logic_menu.automatic_menu.ks_turret:get(),
        mymenu.logic_menu.automatic_menu.ks_grass:get(),
        mymenu.logic_menu.automatic_menu.ks_recall:get())

    if can_ks then
        local Obj_list = {}
        local Obj = objManager.enemies
        local Obj_size = objManager.enemies_n
        for i = 0, Obj_size - 1 do
            local obj = Obj[i]
            if obj and utils:is_valid(obj) and obj.pos:dist(player.pos) < self.q_range and utils:get_real_hp(obj, true) < dmg_lib:Briar_Q(player, obj) then
                Obj_list[#Obj_list + 1] = obj
            end
        end

        table.sort(Obj_list, function(a, b)
            return a.pos:dist(player.pos) < b.pos:dist(player.pos)
        end)

        if Obj_list[1] then
            player:castSpell('obj', 0, Obj_list[1])
            ks_loop = game.time + 0.1
            return
        end
    end
end

local semi_q_loop = 0
function Briar:Semi_Q()
    if not self.q_ready or not mymenu.semi_q:get() then return end
    if semi_q_loop > game.time then return end

    local Obj_list = {}
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if obj and utils:is_valid(obj) and obj.pos:dist(player.pos) < self.q_range then
            Obj_list[#Obj_list + 1] = obj
        end
    end

    table.sort(Obj_list, function(a, b)
        return a.pos:dist(game.mousePos) < b.pos:dist(game.mousePos)
    end)

    if Obj_list[1] then
        player:castSpell('obj', 0, Obj_list[1])
        semi_q_loop = game.time + 0.1
        return
    end
end

local semi_r_loop = 0
function Briar:Semi_R(draw)
    if not self.r_ready or not mymenu.semi_r:get() then return end
    if semi_r_loop > game.time then return end
    if game.time < self.last_r_t + 2 then return end

    local target = utils:get_target(self.r_range, "AD")
    if target then
        if draw then
            graphics.draw_circle(target.pos, target.boundingRadius, 2, 0xFFFF0000, 10)
            return
        end
        local seg = pred.linear.get_prediction(self.r_pred, target)
        if not seg then return end
        local col = pred.collision.get_prediction(self.r_pred, seg, target)
        if col then return end

        local cast_pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)
        player:castSpell('pos', 3, cast_pos)
        semi_r_loop = game.time + 0.1
    end
end

local w_loop = 0
function Briar:W_logic()
    if not mymenu.w_ks:get() then return end
    if not player.buff["briarwfrenzybuff"] then return end
    if not self.w_ready then return end
    if w_loop > game.time then return end

    local target = self.w_target
    if target and utils:get_real_hp(target) < dmg_lib:Briar_W(player, target) then
        player:castSpell('self', 1)
        w_loop = game.time + 1
    end

    local buff_time = player.buff["briarwfrenzybuff"].endTime - game.time
    local windup = player:attackCastDelay(69)
    if buff_time < windup then
        player:castSpell('self', 1)
        w_loop = game.time + 1
    end
end

local lc_loop = 0
local q_lc_loop = 0
function Briar:Laneclear()
    if not self.is_laneclear then return end
    if lc_loop > game.time then return end

    local Obj = objManager.minions[TEAM_NEUTRAL]
    local Obj_size = objManager.minions.size[TEAM_NEUTRAL]
    if Obj_size == 0 then return end

    local Obj_list = {}
    local Q_list = {}

    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if obj and utils:is_valid(obj) then
            Obj_list[#Obj_list + 1] = obj
            local dist = obj.pos:dist(player.pos)
            if dist < self.q_range then
                Q_list[#Q_list + 1] = obj
            end
        end
    end

    if #Obj_list == 0 then return end

    table.sort(Obj_list, function(a, b)
        return a.pos:dist(player.pos) < b.pos:dist(player.pos)
    end)
    table.sort(Q_list, function(a, b)
        return a.maxHealth > b.maxHealth
    end)

    local target = Obj_list[1]
    local q_target = Q_list[1]
    local last_aa_t = utils.last_aa_target
    local last_aa_target_good = last_aa_t and
        (utils:is_epic_monster(last_aa_t) or utils:is_buff_monster(last_aa_t) or utils:is_small_monster(last_aa_t))
    local can_e_kill = not mymenu.e_jg:get() or not self.e_ready or
        (mymenu.e_jg:get() and self.e_ready and last_aa_t and utils:get_real_hp(last_aa_t) > dmg_lib:Briar_E(player, last_aa_t) * 1.5)
    if q_lc_loop < game.time and mymenu.q_jg:get() and self.q_ready and target and target.pos:dist(player.pos) < self.q_range then
        local in_aa = target.pos:dist(player.pos) < player.attackRange + player.boundingRadius + target.boundingRadius
        local q_target_is_good = utils:is_epic_monster(q_target) or utils:is_buff_monster(q_target) or
            utils:is_small_monster(q_target)
        if in_aa and q_target and q_target_is_good then
            player:castSpell('obj', 0, q_target)
            lc_loop = game.time + 0.1
        else
            player:castSpell('obj', 0, target)
            lc_loop = game.time + 0.1
        end
    elseif mymenu.w_jg:get() and self.w_ready and last_aa_target_good and can_e_kill and not player.buff["briarwfrenzybuff"] and utils.after_aa_t > game.time then
        player:castSpell("pos", 1, player.pos)
        lc_loop = game.time + 1
    elseif mymenu.e_jg:get() and self.e_ready and q_target and utils:get_real_hp(q_target) - 200 < dmg_lib:Briar_E(player, q_target) then
        player:castSpell("pos", 2, q_target.pos)
        q_lc_loop = game.time + 1
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Briar:tick()
    if player.isDead then return end

    self:spell_check()

    self:Semi_Q()
    self:Semi_R()
    self:W_logic()
    self:Automatic()
    self:Laneclear()

    -- print(orb.core.next_attack)
    -- print(orb.core.time_to_next_attack())
    -- print(orb.core.is_winding_up_attack())
end

function Briar:slow_tick()
    if player.isDead then return end
end

function Briar:process_spell(spell)
    if not spell or player.isDead then return end

    if spell.owner and spell.owner == player and spell.name == "BriarR" then
        self.last_r_t = game.time
    end
    if spell.owner and spell.owner == player and spell.target and player.buff["briarwfrenzybuff"] and spell.isBasicAttack then
        self.w_target = spell.target
    end
    --
end

function Briar:finish_spell(spell)
    if not spell or player.isDead then return end
end

function Briar:on_cast_spell(args)
    if not args or player.isDead then return end
    --print( args.spellSlot)
end

function Briar:create_particle(obj)
    if not obj then return end
end

function Briar:delete_particle(obj)
    if not obj then return end
    --print( args.spellSlot)
end

function Briar:path(target)
    if not target or player.isDead then return end
end

function Briar:dmg_output()
    if not mymenu.q_damage:get() and not mymenu.w_damage:get() and not mymenu.e_damage:get() and not mymenu.aa_damage:get() == 0 then return end
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]

        if utils:is_valid(enemy) and enemy.isVisible and enemy.isOnScreen then
            local dmg = { passive = 0, aa = 0, q = 0, w = 0, e = 0, r = 0 }

            if mymenu.q_damage:get() and self.q_ready then
                dmg.q = dmg_lib:Briar_Q(player, enemy)
            end
            if mymenu.w_damage:get() and self.w_ready then
                dmg.w = dmg_lib:Briar_W(player, enemy)
            end
            if mymenu.e_damage:get() and self.e_ready then
                dmg.e = dmg_lib:Briar_E(player, enemy)
            end

            if mymenu.aa_damage:get() > 0 then
                dmg.aa = damagelib.calc_aa_damage(player, enemy, true) +
                    damagelib.calc_aa_damage(player, enemy, false) * (mymenu.aa_damage:get() - 1)
            end

            utils:draw_hp_bar(enemy, dmg)
        end
    end
end

function Briar:new_draw()
    if player.isDead then return end

    if keyboard.isKeyDown(0x09) then return end

    if mymenu.Q:get() then
        local color = self.q_ready and common.drawdr_menu.clr_q:get() or
            utils:set_alpha(common.drawdr_menu.clr_q:get(), 100)
        --graphics.draw_circle(player.pos, self.q_range, 2, color, 36)
        utils:draw_circle("q_range", player.pos, self.q_range, color)
    end
    if mymenu.R:get() then
        Briar:Semi_R(true)
        local color = self.r_ready and common.drawdr_menu.clr_r:get() or
            utils:set_alpha(common.drawdr_menu.clr_r:get(), 100)
        --graphics.draw_circle(player.pos, self.r_range, 2, color, 36)
        utils:draw_circle("r_range", player.pos, self.r_range, color)
        minimap.draw_circle(player.pos, self.r_range, 1, color, 27)
    end
    Briar:dmg_output()

    local state_style = utils.menuc.draw_state_menu.state_style:get()
    local text_size = utils.menuc.draw_state_menu.text_size:get()
    local state_color = utils.menuc.draw_state_menu.text_color:get()
    local state_pos = player.pos + vec3(50, 0, -50)
    local p2d = graphics.world_to_screen(state_pos)
    local state_list = {
        { mymenu.sf,     mymenu.state:get() },
        { mymenu.semi_q, mymenu.state:get() },
        { mymenu.semi_r, mymenu.state:get() },
    }
    for _, list in ipairs(state_list) do
        if list[2] == true and list[1] and (list[1]:get() or state_style == 1) then
            local key = (list[1].key and "[" .. list[1].key .. "] ") or
                (list[1].toggle and "[" .. list[1].toggle .. "] ")
                or
                nil
            if key then
                local text = key .. list[1].text
                local size = text_size
                local color = list[1]:get() and state_color or utils:set_alpha(state_color, 100)
                graphics.draw_text_2D(text, size, p2d.x, p2d.y, color)
                p2d.y = p2d.y + text_size
            end
        end
    end
end

function Briar:init()
    self:load()
    local tick_function = utils.on_slow_tick(1, function() self:slow_tick() end)
    cb.add(cb.tick, tick_function)
    cb.add(cb.tick, function() self:tick() end)
    cb.add(cb.spell, function(...) self:process_spell(...) end)
    cb.add(cb.cast_finish, function(...) self:finish_spell(...) end)
    cb.add(cb.cast_spell, function(...) self:on_cast_spell(...) end)
    cb.add(cb.create_particle, function(...) self:create_particle(...) end)
    cb.add(cb.delete_particle, function(...) self:delete_particle(...) end)

    cb.add(cb.path, function(...) self:path(...) end)
    cb.add(cb.draw, function() self:new_draw() end)
end

return Briar:init()
