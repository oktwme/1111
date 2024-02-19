local Tristana = {}


---@type utils
local utils = module.load(header.id, "Help/utils")
local my_name = player.charName
local interrupter = module.load(header.id, "Help/interrupter")
local antigapcloser = module.load(header.id, "Help/anti_gapcloser")

local orb = module.internal('orb')
local pred = module.internal('pred')
local damagelib = module.internal('damagelib')
local dmg_lib = module.load(header.id, "Help/dmg_lib")
local ts = module.internal('TS')
local evade = module.seek('evade')

local mymenu
if hanbot.language == 2 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name)
    mymenu:header(my_name, "Klee: " .. my_name)

    mymenu:set("icon", player.iconSquare)
    -- local icon_klee = graphics.sprite('Resource/klee.png')
    -- if icon_klee
    -- then
    --     mymenu:set('icon', icon_klee)
    -- end

    utils:menu_utils(mymenu)

    mymenu:menu("combo", "Combo")
    -- #region combo
    mymenu.combo:header("header_1", "Q")
    mymenu.combo:boolean("q", "Use Q", true)
    mymenu.combo:boolean("q_if_e", " ^- If target have E", true)
    mymenu.combo:boolean("q_cd", " ^- Use Navori logic", true)

    mymenu.combo:header("header_2", "W")
    mymenu.combo:boolean("w", "Use W", true)
    mymenu.combo:boolean("w_can_kill", " ^- If can kill", true)
    mymenu.combo:boolean("w_lv2", " ^- Lv2 logic", true)
    mymenu.combo:boolean("w_sc", " ^- Save check", true)
    mymenu.combo.w_sc:set('tooltip', "W will never jump into turret")

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "Use E", true)

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        if not mymenu.combo[enemy.charName] then
            mymenu.combo:boolean(enemy.charName, enemy.charName, true)
            mymenu.combo[enemy.charName]:set('icon', enemy.iconSquare)
        end
    end

    local elements_q = { mymenu.combo.q_if_e, mymenu.combo.q_cd }
    local elements_w = { mymenu.combo.w_can_kill, mymenu.combo.w_lv2, mymenu.combo.w_sc }
    utils:set_visible(elements_q, mymenu.combo.q:get())
    utils:set_visible(elements_w, mymenu.combo.w:get())
    mymenu.combo.q:set('callback', function(old, new) utils:hide_menu(elements_q, true, old, new) end)
    mymenu.combo.w:set('callback', function(old, new) utils:hide_menu(elements_w, true, old, new) end)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "Automatic")
    -- #region automatic
    mymenu.auto:header("header_2", "W")
    mymenu.auto:boolean("w_spell", "Auto W evade special spell", true)
    mymenu.auto:header("header_4", "R")

    mymenu.auto:boolean("r_ks", "Killsteal", true)
    mymenu.auto:menu("r_ks_to", " ^- Killsteal")
    mymenu.auto.r_ks_to:header("header_1", "Killsteal")
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        if not mymenu.auto.r_ks_to[enemy.charName] then
            mymenu.auto.r_ks_to:boolean(enemy.charName, enemy.charName, true)
            mymenu.auto.r_ks_to[enemy.charName]:set('icon', enemy.iconSquare)
        end
    end

    mymenu.auto:boolean("r_int", "Interrupt spell", true)
    mymenu.auto:menu("r_int_to", " ^- Interrupt spell")
    mymenu.auto.r_int_to:header("header_1", "Interrupt spell")
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local hero_name = enemy.charName
        local hero_data = interrupter[hero_name]
        if hero_data then
            for _, skill in ipairs(hero_data) do
                mymenu.auto.r_int_to:boolean(hero_name .. skill.slot, hero_name .. " " .. skill.Spell, skill.menu)
                mymenu.auto.r_int_to[hero_name .. skill.slot]:set('icon', enemy.iconSquare)
            end
        end
    end

    mymenu.auto:boolean("r_anti", "Anti gapcloser", true)
    mymenu.auto:menu("r_anti_to", " ^- Anti gapcloser")
    mymenu.auto.r_anti_to:header("header_1", "Anti gapcloser")
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local hero_name = enemy.charName
        local hero_data = antigapcloser.gapcloser_spell[hero_name]
        if hero_data then
            for _, skill in ipairs(hero_data) do
                mymenu.auto.r_anti_to:boolean(hero_name .. skill.spell_name, hero_name .. " " .. skill.slot, true)
                mymenu.auto.r_anti_to[hero_name .. skill.spell_name]:set('icon', enemy.iconSquare)
            end
        end
    end

    mymenu.auto:boolean("r_insec", "Insec to turret", true)
    mymenu.auto:menu("r_insec_to", " ^- Insec to turret")
    mymenu.auto.r_insec_to:header("header_1", "Insec to turret")
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        if not mymenu.auto.r_insec_to[enemy.charName] then
            mymenu.auto.r_insec_to:boolean(enemy.charName, enemy.charName, true)
            mymenu.auto.r_insec_to[enemy.charName]:set('icon', enemy.iconSquare)
        end
    end

    mymenu.auto:header("header_5", "")
    -- #endregion

    mymenu:menu("lc", "Laneclear")
    -- #region laneclear
    mymenu.lc:header("header_1", "Laneclear")
    mymenu.lc:boolean("q_lc", "Laneclear Q", false)
    mymenu.lc:boolean("e_lc", "Laneclear E", false)
    mymenu.lc:header("header_2", "Jungle clear")
    mymenu.lc:boolean("q_jg", "Jungle Q", true)
    mymenu.lc:boolean("e_jg", "Jungle E", true)
    mymenu.lc:header("header_turret", "Turret")
    mymenu.lc:boolean("q_turret", "Turret Q", true)
    mymenu.lc:boolean("e_turret", "Turret E", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("dr", "Drawings")
    -- #region Drawings
    mymenu.dr:header("range", "Range")
    mymenu.dr:boolean("W", "Draw W", true)

    mymenu.dr:header("damage", "Damage")
    mymenu.dr:boolean("w_damage", "Draw W", true)
    mymenu.dr:boolean("e_damage", "Draw E", true)
    mymenu.dr:boolean("r_damage", "Draw R", true)
    mymenu.dr:slider("aa_damage", "Draw AA", 0, 0, 5, 1)

    mymenu.dr:header("state", "State")
    mymenu.dr:boolean("sf", "SpellFarm", true)
    mymenu.dr:boolean("semi_e", "Semi E", true)
    mymenu.dr:boolean("semi_r", "Semi R", true)
    mymenu.dr:boolean("dis_r", "Disable R", true)
    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "Key")
    mymenu:keybind("sf", "SpellFarm", nil, 'MMB')
    mymenu:keybind("semi_e", "Semi E", 'E', nil)
    mymenu:dropdown("e_type", " ^- type", 1, { "Close to the mouse", "Close to me", "Target selector" })
    mymenu:keybind("semi_r", "Semi R", 'R', nil)
    mymenu:dropdown("r_type", " ^- type", 1, { "Close to the mouse", "Close to me", "Target selector" })
    mymenu:keybind("dis_r", "Disable R", nil, 'T')
    mymenu:header("header_end", "")
elseif hanbot.language == 1 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name)
    mymenu:header(my_name, "Klee: " .. my_name)

    mymenu:set("icon", player.iconSquare)
    -- local icon_klee = graphics.sprite('Resource/klee.png')
    -- if icon_klee
    -- then
    --     mymenu:set('icon', icon_klee)
    -- end

    utils:menu_utils(mymenu)

    mymenu:menu("combo", "连招")
    -- #region combo
    mymenu.combo:header("header_1", "Q")
    mymenu.combo:boolean("q", "使用Q", true)
    mymenu.combo:boolean("q_if_e", " ^- 如果目标有E", true)
    mymenu.combo:boolean("q_cd", " ^- 讯刃逻辑", true)

    mymenu.combo:header("header_2", "W")
    mymenu.combo:boolean("w", "使用W", true)
    mymenu.combo:boolean("w_can_kill", " ^- 如果可击杀", true)
    mymenu.combo:boolean("w_lv2", " ^- 2等逻辑", true)
    mymenu.combo:boolean("w_sc", " ^- 安全检查", true)
    mymenu.combo.w:set('tooltip', "W不会跳进塔下")

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "使用E", true)

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        if not mymenu.combo[enemy.charName] then
            mymenu.combo:boolean(enemy.charName, enemy.charName, true)
            mymenu.combo[enemy.charName]:set('icon', enemy.iconSquare)
        end
    end

    local elements_q = { mymenu.combo.q_if_e, mymenu.combo.q_cd }
    local elements_w = { mymenu.combo.w_can_kill, mymenu.combo.w_lv2, mymenu.combo.w_sc }
    utils:set_visible(elements_q, mymenu.combo.q:get())
    utils:set_visible(elements_w, mymenu.combo.w:get())
    mymenu.combo.q:set('callback', function(old, new) utils:hide_menu(elements_q, true, old, new) end)
    mymenu.combo.w:set('callback', function(old, new) utils:hide_menu(elements_w, true, old, new) end)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "Automatic")
    -- #region automatic
    mymenu.auto:header("header_2", "W")
    mymenu.auto:boolean("w_spell", "自动W特殊技能", true)
    mymenu.auto:header("header_4", "R")

    mymenu.auto:boolean("r_ks", "捡人头", true)
    mymenu.auto:menu("r_ks_to", " ^- 捡人头")
    mymenu.auto.r_ks_to:header("header_1", "捡人头")
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        if not mymenu.auto.r_ks_to[enemy.charName] then
            mymenu.auto.r_ks_to:boolean(enemy.charName, enemy.charName, true)
            mymenu.auto.r_ks_to[enemy.charName]:set('icon', enemy.iconSquare)
        end
    end

    mymenu.auto:boolean("r_int", "吟唱技能", true)
    mymenu.auto:menu("r_int_to", " ^- 吟唱技能")
    mymenu.auto.r_int_to:header("header_1", "吟唱技能")
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local hero_name = enemy.charName
        local hero_data = interrupter[hero_name]
        if hero_data then
            for _, skill in ipairs(hero_data) do
                mymenu.auto.r_int_to:boolean(hero_name .. skill.slot, hero_name .. " " .. skill.Spell, skill.menu)
                mymenu.auto.r_int_to[hero_name .. skill.slot]:set('icon', enemy.iconSquare)
            end
        end
    end

    mymenu.auto:boolean("r_anti", "反突进", true)
    mymenu.auto:menu("r_anti_to", " ^- 反突进")
    mymenu.auto.r_anti_to:header("header_1", "反突进")
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local hero_name = enemy.charName
        local hero_data = antigapcloser.gapcloser_spell[hero_name]
        if hero_data then
            for _, skill in ipairs(hero_data) do
                mymenu.auto.r_anti_to:boolean(hero_name .. skill.spell_name, hero_name .. " " .. skill.slot, true)
                mymenu.auto.r_anti_to[hero_name .. skill.spell_name]:set('icon', enemy.iconSquare)
            end
        end
    end

    mymenu.auto:boolean("r_insec", "推到塔下", true)
    mymenu.auto:menu("r_insec_to", " ^- 推到塔下")
    mymenu.auto.r_insec_to:header("header_1", "推到塔下")
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        if not mymenu.auto.r_insec_to[enemy.charName] then
            mymenu.auto.r_insec_to:boolean(enemy.charName, enemy.charName, true)
            mymenu.auto.r_insec_to[enemy.charName]:set('icon', enemy.iconSquare)
        end
    end

    mymenu.auto:header("header_5", "")
    -- #endregion

    mymenu:menu("lc", "清线")
    -- #region laneclear
    mymenu.lc:header("header_1", "清兵")
    mymenu.lc:boolean("q_lc", "清兵Q", true)
    mymenu.lc:boolean("e_lc", "清兵E", true)
    mymenu.lc:header("header_2", "清野")
    mymenu.lc:boolean("q_jg", "清野Q", true)
    mymenu.lc:boolean("e_jg", "清野E", true)
    mymenu.lc:header("header_turret", "炮塔")
    mymenu.lc:boolean("q_turret", "炮塔Q", true)
    mymenu.lc:boolean("e_turret", "炮塔E", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("dr", "绘制")
    -- #region Drawings
    mymenu.dr:header("range", "范围")
    mymenu.dr:boolean("W", "绘制W", true)

    mymenu.dr:header("damage", "伤害")
    mymenu.dr:boolean("w_damage", "绘制W", true)
    mymenu.dr:boolean("e_damage", "绘制E", true)
    mymenu.dr:boolean("r_damage", "绘制R", true)
    mymenu.dr:slider("aa_damage", "绘制普攻", 0, 0, 5, 1)

    mymenu.dr:header("state", "状态")
    mymenu.dr:boolean("sf", "发育", true)
    mymenu.dr:boolean("semi_e", "半手动E", true)
    mymenu.dr:boolean("semi_r", "半手动R", true)
    mymenu.dr:boolean("dis_r", "禁用R", true)
    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "快捷键")
    mymenu:keybind("sf", "发育", nil, 'MMB')
    mymenu:keybind("semi_e", "半手动E", 'E', nil)
    mymenu:dropdown("e_type", " ^- 种类", 1, { "靠近鼠标", "靠近我", "目标选择器" })
    mymenu:keybind("semi_r", "半手动R", 'R', nil)
    mymenu:dropdown("r_type", " ^- 种类", 1, { "靠近鼠标", "靠近我", "目标选择器" })
    mymenu:keybind("dis_r", "禁用R", nil, 'T')
    mymenu:header("header_end", "")
end
local common = utils:menu_common()

function Tristana:load()
    self.is_combo = false
    self.is_mixed = false
    self.is_laneclear = false
    self.is_fastclear = false
    self.is_lasthit = false

    self.last_q_t = 0
    self.q_range = 0
    self.q_ready = false
    self.q_level = 0

    self.last_w_t = 0
    self.w_range = 0
    self.w_ready = false
    self.w_level = 0
    self.w_pred = {
        delay = 0.25,
        speed = 1100,
        radius = 350,
        boundingRadiusMod = 0,
        range = 900,
        collision = {
            minion = false,
            wall = false,
            hero = false,
        },
    }

    self.last_e_t = 0
    self.cast_e_target = nil
    self.e_range = 0
    self.e_ready = false
    self.e_level = 0
    self.e_pred = {
        delay = player:attackCastDelay(64),
        speed = 2400,
        width = 100,
        boundingRadiusMod = 1,
        range = player.attackRange + player.boundingRadius + 300,
        collision = {
            minion = false,
            wall = true,
            hero = false,
        },
    }

    self.last_r_t = 0
    self.r_range = 0
    self.r_ready = false
    self.r_level = 0
    self.r_pred = {
        delay = player:attackCastDelay(64),
        speed = 2000,
        width = 100,
        boundingRadiusMod = 1,
        range = player.attackRange + player.boundingRadius + 300,
        collision = {
            minion = false,
            wall = true,
            hero = false,
        },
    }

    self.have_cd_item = false
end

function Tristana:spell_check()
    self.is_combo = orb.menu.combat.key:get()
    self.is_mixed = orb.menu.hybrid.key:get()
    self.is_laneclear = orb.menu.lane_clear.key:get() and mymenu.sf:get()
    self.is_fastclear = self.is_laneclear and keyboard.isKeyDown(1)
    self.is_lasthit = self.is_laneclear or orb.menu.last_hit.key:get()

    self.q_range = 0
    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0

    self.w_range = 900
    self.w_level = player:spellSlot(1).level
    self.w_ready = self.w_level > 0 and player:spellSlot(1).state == 0

    self.e_range = player.levelRef >= 18 and 661 or 517 + 8 * player.levelRef
    self.e_level = player:spellSlot(2).level
    self.e_ready = self.e_level > 0 and player:spellSlot(2).state == 0
    self.e_pred.range = player.attackRange + player.boundingRadius + 300

    self.r_range = player.levelRef >= 18 and 661 or 517 + 8 * player.levelRef
    self.r_level = player:spellSlot(3).level
    self.r_ready = self.r_level > 0 and player:spellSlot(3).state == 0
    self.r_pred.range = player.attackRange + player.boundingRadius + 300

    if self.cast_e_target and self.last_e_t + 0.5 < game.time and Tristana:E_stack(self.cast_e_target) == 87 then
        self.cast_e_target = nil
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Tristana:E_stack(target)
    if target and utils:has_buff(target, "tristanaechargesound") then
        local buff = utils:get_buff_count(target, "tristanaecharge")
        return buff or 0
    end
    return 87
end

function Tristana:e_r_kill(target)
    if not target or not utils:is_valid(target) then return false end

    local target_hp = utils:get_real_hp(target, true)
    local r_dmg = dmg_lib:Tristana_R(player, target)
    local stack = self:E_stack(target)
    if stack == 87 and r_dmg > target_hp then
        return true
    end

    for i = 0, 3 do
        local total_dmg = r_dmg + dmg_lib:Tristana_E(player, target, i + 1) -- include r stack
        if stack == i and total_dmg > target_hp then
            return true
        end
    end
    return false
end

function Tristana:get_target()
    local target = nil

    --local selector_t = SDK.Libs.TargetSelector:GetSelectedTarget()
    local ts_t = utils:get_target(1000, "AD")
    local orb_t = utils.orb_t

    if ts_t and utils:is_valid(ts_t) and player.pos:dist(ts_t.pos) <= player.boundingRadius + ts_t.boundingRadius + self.e_range then --
        target = ts_t
    elseif orb_t and player.pos:dist(orb_t.pos) <= player.boundingRadius + orb_t.boundingRadius + self.e_range then
        target = orb_t
    end

    return target
end

function Tristana:R_end_pos(target)
    if self.r_level == 0 or not self.r_ready or not target then
        return vec3(0, 0, 0)
    end

    local base_range = { 600, 800, 1000 }
    local r_range = (base_range[self.r_level])
    local target_pos = target.pos
    local my_pos = player.pos

    for i = r_range, 0, -10 do
        local r_pos = target_pos - (my_pos - target_pos):norm() * i
        if not navmesh.isWall(r_pos) then
            return r_pos
        end
    end
    return vec3(0, 0, 0)
end

function Tristana:semi_target(semi_type)
    local Obj_list = {}
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if utils:is_valid(obj) then
            Obj_list[#Obj_list + 1] = obj
        end
    end

    local target = Obj_list

    if target then
        local use_spell_t = nil
        local my_pos = player.pos
        local hud_pos = game.mousePos

        for i = #target, 1, -1 do
            if target[i].pos:dist(my_pos) > self.e_range + player.boundingRadius + target[i].boundingRadius then
                table.remove(target, i)
            end
        end

        local sort_func = function(a, b)
            local ref_pos = semi_type == 1 and hud_pos or my_pos
            return a.pos:dist(ref_pos) < b.pos:dist(ref_pos)
        end

        if semi_type <= 2 then
            table.sort(target, sort_func)
            use_spell_t = target[1]
        else
            use_spell_t = self:get_target()
        end

        if use_spell_t and my_pos:dist(use_spell_t.pos) <= self.e_range + player.boundingRadius + use_spell_t.boundingRadius then
            return use_spell_t
        end
        return nil
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

local vi_r = nil
local cow_w = nil
-- #region Automatic

local auto_r_loop = 0
function Tristana:Auto_R()
    if mymenu.dis_r:get() then return end
    if not self.r_ready then return end
    if auto_r_loop > game.time then return end

    local next_aa_time = utils.time_until_next_aa
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local range_check = utils:is_valid(enemy) and
            player.pos:dist(enemy.pos) <= self.e_range + player.boundingRadius + enemy.boundingRadius

        local r_kill = utils:is_valid(enemy) and utils:checkbox("auto", "r_ks_to", enemy) and --
            self:e_r_kill(enemy) == true and utils:ignore_spell(enemy) == false and
            mymenu.auto.r_ks:get() and next_aa_time < player:attackCastDelay(64)

        local r_end_pos = self:R_end_pos(enemy)
        local insec = r_end_pos ~= vec3(0, 0, 0) and utils:checkbox("auto", "r_insec_to", enemy) and --
            utils:in_ally_turret(r_end_pos, 600) and not utils:in_ally_turret(enemy.pos, 700) and
            utils:ignore_cc(enemy) == false and
            mymenu.auto.r_insec:get()

        local active_spell = utils:ignore_cc(enemy) == false and enemy.activeSpell
        local slot = active_spell and active_spell.slot or nil
        local active_menu = slot and mymenu.auto.r_int_to[enemy.charName .. slot] or nil

        if range_check and (r_kill or insec or (active_menu and active_menu:get())) then
            auto_r_loop = game.time + 1
            player:castSpell('obj', 3, enemy)
            return
        end
    end
    auto_r_loop = game.time + 0.03
end

local auto_w_loop = 0
function Tristana:Auto_W()
    if not self.w_ready then return end
    if auto_w_loop > game.time then return end

    if evade then
        for i = evade.core.skillshots.n, 1, -1 do
            local spell = evade.core.skillshots[i]

            if not spell or not spell.owner.team == TEAM_ENEMY then return end
            local skillshotNames = {
                ["NautilusAnchorDragMissile"] = true,
                ["ThreshQ"] = true,
                ["RocketGrab"] = true
            }
            if not skillshotNames[spell.name] then return end


            if spell:contains(player) then
                local start_pos = vec3(spell.start_pos.x, 0, spell.start_pos.y)
                local hit_t = 0
                if spell.data.speed == math.huge then
                    hit_t = 0.2
                else
                    hit_t = start_pos:dist(player.pos) / spell.data.speed
                end

                if hit_t < 0.2 + network.latency then
                    player:castSpell("pos", 1, game.mousePos)
                    auto_w_loop = game.time + 1
                    return
                end
            end
        end
    end

    local w_vi_r = vi_r and utils:has_buff(vi_r, "ViR") and vi_r.pos:dist(player.pos) < 400
    local w_cow_w = cow_w and cow_w.isDashing and cow_w.pos:dist(player.pos) < 200
    if w_vi_r or w_cow_w then
        player:castSpell("pos", 1, game.mousePos)
        auto_w_loop = game.time + 1
        return
    end
end

function Tristana:Anti_gapcloser()
    if not mymenu.auto.r_anti:get() then return end
    if not self.r_ready then return end

    for i = #antigapcloser.dash_data, 1, -1 do
        local dash_list = antigapcloser.dash_data[i]
        local menu = mymenu.auto.r_anti_to[dash_list.sender.charName .. dash_list.spell_name]
        if menu and menu:get() and utils:ignore_cc(dash_list.sender) == false and game.time > dash_list.start_t + 0.1 then
            player:castSpell('obj', 3, dash_list.sender)
            return
        end
    end
end

function Tristana:Automatic()
    self:Auto_R()
    self:Auto_W()
    self:Anti_gapcloser()
end

-- #endregion

function Tristana:Combo_Q()
    if not self.q_ready then return end
    if not mymenu.combo.q:get() then return end
    local last_e_target = self.last_e_t + 0.5 > game.time and self.cast_e_target and self.cast_e_target.type == TYPE_HERO
    if utils.before_aa_t >= game.time then
        local use_q = not mymenu.combo.q_if_e:get() or
            (utils.last_aa_target and Tristana:E_stack(utils.last_aa_target) ~= 87) or last_e_target
        if use_q then
            player:castSpell('self', 0)
        end
    end
end

function Tristana:Combo_W()
    if not mymenu.combo.w:get() then return end
    local target = utils:get_target(self.w_range, "AD")
    if not target then return end

    local lvl_check = player.levelRef > target.levelRef and player.levelRef == 2
    local w_lv2 = mymenu.combo.w_lv2:get() and lvl_check and self:E_stack(target) == 87 and
        self.e_ready and
        game.time > utils.next_aa_t - player:attackCastDelay(64)
    --and utils.after_aa_t >= game.time

    if lvl_check and self.w_level == 0 then
        player:levelSpell(1)
    end

    if dmg_lib:as() > 1.0 and player.pos:dist(target.pos) <= self.e_range + player.boundingRadius + target.boundingRadius then return end

    local target_hp = utils:get_real_hp(target, true)
    local stack = self:E_stack(target)
    local total_dmg = dmg_lib:Tristana_E(player, target, stack + 1) + dmg_lib:Tristana_W(player, target)
    local w_can_kill = mymenu.combo.w_can_kill:get() and total_dmg > target_hp and (stack == 87 or stack >= 1) and
        self.w_ready

    if w_can_kill or w_lv2 then
        local seg = pred.circular.get_prediction(self.w_pred, target)
        if seg then
            local pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)
            local save_check = utils:save_check(pos, mymenu) or not mymenu.combo.w_sc:get()
            if not utils:in_enemy_turret(pos) and save_check then
                player:castSpell('pos', 1, pos)
            end
        end
    end
end

function Tristana:Combo_E()
    if not self.e_ready then return end
    if not mymenu.combo.e:get() then return end
    if game.time < utils.next_aa_t - player:attackCastDelay(64) then return end

    local target = self:get_target()
    if not target then return end

    local lvl_check = player.levelRef > target.levelRef and player.levelRef == 2

    if lvl_check and self.w_level == 0 and self.q_level == 0 then
        return
    end

    local my_pos = player.pos
    local target_pos = target.pos
    local e_range = self.e_range + player.boundingRadius + target.boundingRadius
    local menu_check = utils:checkbox(mymenu.combo, target)
    if my_pos:dist(target_pos) <= e_range and menu_check then
        local seg = pred.linear.get_prediction(self.e_pred, target)
        if seg and utils:ignore_spell(target) == false then
            if self.q_ready and mymenu.combo.q:get() then
                player:castSpell('self', 0)
            end
            player:castSpell('obj', 2, target)
        end
    end
end

function Tristana:Combo()
    if not self.is_combo then return end
    self:Combo_W()
    self:Combo_E()
    self:Combo_Q()
end

local lc_loop = 0
function Tristana:Laneclear()
    if not self.is_laneclear then return end

    if game.time < utils.next_aa_t - player:attackCastDelay(64) then return end

    if lc_loop > game.time then return end

    if utils:is_valid(utils.last_aa_target) and utils.last_aa_target.health > damagelib.calc_aa_damage(player, utils.last_aa_target, false) * 4 and
        self.q_ready then
        local q_turret = utils.last_aa_target.type == TYPE_TURRET and mymenu.lc.q_turret:get()
        local q_monster = utils.last_aa_target.isMonster and mymenu.lc.q_jg:get()
        if (q_turret or q_monster) then
            player:castSpell('self', 0)
            lc_loop = game.time + 0.1
        end
    end

    if (mymenu.lc.e_turret:get() and self.e_ready) then
        local turret_list = {}
        local turret = objManager.turrets[TEAM_ENEMY]
        local turret_size = objManager.turrets.size[TEAM_ENEMY]
        for i = 0, turret_size - 1 do
            local obj = turret[i]
            if utils:is_valid(obj) and obj.pos:dist(player.pos) < 1000 and obj.health > damagelib.calc_aa_damage(player, obj, false) * 4 then
                turret_list[#turret_list + 1] = obj
            end
        end

        if #turret_list > 0 then
            table.sort(turret_list, function(a, b)
                return a.pos:dist(player.pos) < b.pos:dist(player.pos)
            end)

            local target = turret_list[1]
            if utils:in_aa_range(player, target) then
                if mymenu.lc.e_turret:get() and self.e_ready then
                    if mymenu.lc.q_turret:get() and self.q_ready then
                        player:castSpell('self', 0)
                    end
                    player:castSpell("obj", 2, target)
                    lc_loop = game.time + 1
                    return
                end
            end
        end
    end

    if (mymenu.lc.e_lc:get() and self.e_ready) then
        local minion_list = {}
        local Obj = objManager.minions["farm"]
        local Obj_size = objManager.minions.size["farm"]
        for i = 0, Obj_size - 1 do
            local obj = Obj[i]
            if utils:is_valid(obj) and obj.pos:dist(player.pos) < 1000 and obj.health > damagelib.calc_aa_damage(player, obj, false) * 4 then
                minion_list[#minion_list + 1] = obj
            end
        end

        if #minion_list > 0 then
            table.sort(minion_list, function(a, b)
                return a.maxHealth > b.maxHealth
            end)

            local target = minion_list[1]
            if utils:in_aa_range(player, target) then
                if mymenu.lc.e_lc:get() and self.e_ready then
                    if mymenu.lc.q_lc:get() and self.q_ready then
                        player:castSpell('self', 0)
                    end
                    player:castSpell("obj", 2, target)
                    lc_loop = game.time + 1
                    return
                end
            end
        end
    end

    if (mymenu.lc.e_jg:get() and self.e_ready) then
        local minion_list = {}
        local Obj = objManager.minions[TEAM_NEUTRAL]
        local Obj_size = objManager.minions.size[TEAM_NEUTRAL]
        for i = 0, Obj_size - 1 do
            local obj = Obj[i]
            if utils:is_valid(obj) and obj.pos:dist(player.pos) < 1000 and obj.health > damagelib.calc_aa_damage(player, obj, false) * 4 then
                minion_list[#minion_list + 1] = obj
            end
        end

        if #minion_list > 0 then
            table.sort(minion_list, function(a, b)
                return a.maxHealth > b.maxHealth
            end)

            local target = minion_list[1]
            if utils:in_aa_range(player, target) then
                if mymenu.lc.e_jg:get() and self.e_ready then
                    if mymenu.lc.q_jg:get() and self.q_ready then
                        player:castSpell('self', 0)
                    end
                    player:castSpell("obj", 2, target)
                    lc_loop = game.time + 1
                    return
                end
            end
        end
    end
end

local semi_e_loop = 0
function Tristana:Semi_E()
    if not self.e_ready or semi_e_loop > game.time then return end
    local target = self:semi_target(mymenu.e_type:get())
    if target and mymenu.semi_e:get() then
        local seg = pred.linear.get_prediction(self.e_pred, target)
        if seg and utils:ignore_spell(target) == false then
            player:castSpell('obj', 2, target)
            semi_e_loop = game.time + 1
        end
    end
end

local semi_r_loop = 0
function Tristana:Semi_R()
    if not self.r_ready or semi_r_loop > game.time then return end
    local target = self:semi_target(mymenu.r_type:get())
    if target and mymenu.semi_r:get() then
        local seg = pred.linear.get_prediction(self.r_pred, target)
        if seg and utils:ignore_spell(target) == false then
            player:castSpell('obj', 3, target)
        end
    end
end

local draw_aa_e_target = nil
function Tristana:aa_e_target()
    local target = self.cast_e_target

    if not utils:is_valid(target) then
        draw_aa_e_target = nil
        return
    end

    if self.is_combo and utils:in_aa_range(player, target) and target.type == TYPE_HERO and target.team == TEAM_ENEMY then
        orb.combat.target = target
        draw_aa_e_target = target
    elseif self.is_laneclear and utils:in_aa_range(player, target) and (target.isLaneMinion or target.isMonster) then
        orb.farm.set_clear_target(target)
        chat.print("A")
        draw_aa_e_target = target
    else
        draw_aa_e_target = nil
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Tristana:tick()
    if player.isDead then return end

    --chat.print(utils:in_enemy_turret(player.pos))


    self:spell_check()

    self:Automatic()
    self:Semi_E()
    self:Semi_R()
    self:Combo()
    self:Laneclear()

    -- print(orb.core.next_attack)
    -- print(orb.core.time_to_next_attack())
    -- print(orb.core.is_winding_up_attack())
end

function Tristana:slow_tick()
    if player.isDead then return end

    self.have_cd_item = false
    for i = 0, 5, 1 do
        if player:itemID(i) == 6675 then
            self.have_cd_item = true
            break
        end
    end
end

function Tristana:process_spell(spell)
    if not spell or player.isDead then return end

    --print(spell.name)

    if spell.owner and spell.owner == player then
        if spell.name == "TristanaE" then
            self.cast_e_target = spell.target
            self.last_e_t = game.time
        end
        if spell.isBasicAttack then
            if self.q_ready and self.is_combo and spell.target.type == TYPE_HERO and self.have_cd_item and mymenu.combo.q_cd:get() then
                player:castSpell('self', 0)
            end
        end
    end

    if spell.owner and spell.target and spell.owner.team == TEAM_ENEMY and spell.target == player then
        if spell.name == "ViR" then
            vi_r = spell.owner
        elseif spell.name == "Headbutt" then
            cow_w = spell.owner
        end
    end

    -- last_q_t
    -- last_w_t
    -- last_e_t
    -- last_r_t
end

function Tristana:finish_spell(spell)
    if not spell or player.isDead then return end
end

function Tristana:on_cast_spell(args)
    if not args or player.isDead then return end
    --print( args.spellSlot)
end

function Tristana:path(target)
    if not target or player.isDead then return end
end

function Tristana:dmg_output()
    if not mymenu.dr.w_damage:get()
        and
        not mymenu.dr.e_damage:get()
        and
        not mymenu.dr.r_damage:get()
        and
        not mymenu.dr.aa_damage:get() == 0 then
        return
    end
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]

        if utils:is_valid(enemy) and enemy.isVisible and enemy.isOnScreen then
            local dmg = { passive = 0, aa = 0, q = 0, w = 0, e = 0, r = 0 }

            if mymenu.dr.w_damage:get() and self.w_ready then
                dmg.w = dmg_lib:Tristana_W(player, enemy)
            end
            if mymenu.dr.e_damage:get() and self.e_ready then
                local stack = Tristana:E_stack(enemy)
                if stack ~= 87 then
                    dmg.e = dmg_lib:Tristana_E(player, enemy, stack) +
                        damagelib.calc_aa_damage(player, enemy, false) * (4 - stack)
                else
                    dmg.e = dmg_lib:Tristana_E(player, enemy, 4) +
                        damagelib.calc_aa_damage(player, enemy, false) * 4
                end
            end
            if mymenu.dr.r_damage:get() and self.r_ready then
                dmg.r = dmg_lib:Tristana_R(player, enemy)
            end

            if mymenu.dr.aa_damage:get() > 0 then
                dmg.aa = damagelib.calc_aa_damage(player, enemy, true) +
                    damagelib.calc_aa_damage(player, enemy, false) * (mymenu.dr.aa_damage:get() - 1)
            end

            utils:draw_hp_bar(enemy, dmg)
        end
    end
end

function Tristana:new_draw()
    if player.isDead then return end

    if mymenu.dr.W:get() then
        if player.path and player.path.isDashing then
            graphics.draw_line(player.pos, player.path.endPos, 2, 0xffffffff)
        else
            local color = self.w_ready and common.drawdr_menu.clr_w:get() or
                utils:set_alpha(common.drawdr_menu.clr_w:get(), 100)
            utils:draw_circle("w_range", player.pos, self.w_range, color)
        end
    end

    if draw_aa_e_target then
        graphics.draw_circle(draw_aa_e_target.pos, draw_aa_e_target.boundingRadius, 2, 0xFFFFFFFF, 36)
    end

    local state_style = utils.menuc.draw_state_menu.state_style:get()
    local text_size = utils.menuc.draw_state_menu.text_size:get()
    local state_color = utils.menuc.draw_state_menu.text_color:get()
    local state_pos = player.pos + vec3(50, 0, -50)
    local p2d = graphics.world_to_screen(state_pos)
    local state_list = {
        { mymenu.sf,     mymenu.dr.sf:get() },
        { mymenu.semi_e, mymenu.dr.semi_e:get() },
        { mymenu.semi_r, mymenu.dr.semi_r:get() },
        { mymenu.dis_r,  mymenu.dr.dis_r:get() },


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

    Tristana:dmg_output()
end

function Tristana:init()
    local function on_tick_orb()
        self:aa_e_target()
    end
    orb.combat.register_f_pre_tick(on_tick_orb)

    self:load()
    local tick_function = utils.on_slow_tick(1, function() self:slow_tick() end)
    cb.add(cb.tick, tick_function)
    cb.add(cb.tick, function() self:tick() end)
    cb.add(cb.spell, function(...) self:process_spell(...) end)
    cb.add(cb.cast_finish, function(...) self:finish_spell(...) end)
    cb.add(cb.cast_spell, function(...) self:on_cast_spell(...) end)

    cb.add(cb.path, function(...) self:path(...) end)
    cb.add(cb.draw, function() self:new_draw() end)
end

return Tristana:init()
