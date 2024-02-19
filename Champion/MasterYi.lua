---@type utils
local utils = module.load(header.id, "Help/utils")

local MasterYi = {}
local my_name = player.charName

local dmg_lib = module.load(header.id, "Help/dmg_lib")
local damagelib = module.internal('damagelib')
local orb = module.internal('orb')
local pred = module.internal('pred')
local evade = module.seek('evade')
local antigapcloser = module.load(header.id, "Help/anti_gapcloser")
local dash = module.load(header.id, "Help/dash")

local path_datas = {}

local mymenu = nil
if hanbot.language == 2 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name)
    mymenu:header(my_name, "Klee: " .. my_name)
    mymenu:set("icon", player.iconSquare)

    utils:menu_utils(mymenu)
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n

    mymenu:menu("combo", "Combo")
    --#region combo
    mymenu.combo:header("q_header", "Q")
    mymenu.combo:boolean("q", "Use Q", true)
    mymenu.combo:menu("Qdash", " ^- Q dash")
    --#region Q dash
    dash:create_menu(mymenu.combo.Qdash)
    -- for i = 0, Obj_size - 1 do
    --     local enemy = Obj[i]
    --     mymenu.combo.Qdash:boolean(enemy.charName, enemy.charName, true)
    --     mymenu.combo.Qdash[enemy.charName]:set("icon", enemy.iconSquare)
    -- end
    mymenu.combo.Qdash:header("end_header", "")
    --#endregion
    mymenu.combo:menu("q_can_kill", " ^- Q can kill")
    --#region Q can kill
    --#endregion

    mymenu.combo:header("w_header", "W")
    mymenu.combo:boolean("w", "Use W", true)

    mymenu.combo:header("e_header", "E")
    mymenu.combo:boolean("e", "Use E", true)

    mymenu.combo:header("r_header", "R")
    mymenu.combo:slider("r", "1v1 use R if enemy hp <= x%", 30, 0, 50, 1)
    mymenu.combo:slider("r_dis", " ^- Min distance", 0, 0, 600, 1)
    mymenu.combo:header("end_header", "")
    --#endregion

    mymenu:menu("harass", "Harass")
    --#region harass
    mymenu.harass:header("q_header", "Q")
    mymenu.harass:slider("q", "Use Q if Mana >= x % ( 100 = Disable )", 50, 0, 100, 1)
    mymenu.harass:boolean("q_mini", "Switch mini gun if no enemy", true)

    mymenu.harass:header("w_header", "W")
    mymenu.harass:slider("w", "Use W if Mana >= x % ( 100 = Disable )", 60, 0, 100, 1)
    mymenu.harass:boolean("w_steal_jg", "Steal monster", true)

    mymenu.harass:header("end_header", "")
    --#endregion

    mymenu:menu("auto", "Automatic")
    --#region auto_menu
    mymenu.auto:header("header_1", "W")
    mymenu.auto:boolean("w_ks", "Killsteal", true)

    mymenu.auto:header("header_2", "E")
    mymenu.auto:menu("e_anti_to", "Anti gapcloser")
    mymenu.auto.e_anti_to:header("header_1", "Anti gapcloser")
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local hero_name = enemy.charName
        local hero_data = antigapcloser.gapcloser_spell[hero_name]
        if hero_data then
            for _, skill in ipairs(hero_data) do
                mymenu.auto.e_anti_to:boolean(hero_name .. skill.spell_name, hero_name .. " " .. skill.slot, true)

                if mymenu.auto.e_anti_to[hero_name .. skill.spell_name] and enemy.iconSquare then
                    mymenu.auto.e_anti_to[hero_name .. skill.spell_name]:set('icon', enemy.iconSquare)
                end
            end
        end
    end

    mymenu.auto:header("header_1", "R")
    mymenu.auto:boolean("r_ks", "Killsteal", true)

    mymenu.auto:header("end_header", "")
    --#endregion

    mymenu:menu("lc", "Laneclear")
    --#region Laneclear
    mymenu.lc:header("q_header", "W")
    mymenu.lc:boolean("jungle_w", "Jungle W", true)
    mymenu.lc:header("end_header", "")
    --#endregion

    mymenu:menu("hc", "Hitchance")
    --#region Hitchance
    mymenu.hc:header("header_w", "W")
    mymenu.hc:slider("w_range", "Range %", 95, 70, 100, 1)
    mymenu.hc:header("header_2", "R")
    mymenu.hc:slider("r_range", "Range %", 2000, 2000, 5000, 1)
    mymenu.hc:header("header_5", "")
    --#endregion

    mymenu:menu("dr", "Drawings")
    --#region dr
    mymenu.dr:header("draw_ranges_header", "Ranges")
    mymenu.dr:boolean("q_range_1", "Q range (POW-POW)", true)
    mymenu.dr:boolean("q_range_2", "Q range (FISHBONES)", true)
    mymenu.dr:boolean("w_range", "W range", true)
    mymenu.dr:boolean("e_range", "E range", false)
    mymenu.dr:boolean("r_range", "R range", true)

    mymenu.dr:header("draw_damage_header", "Damage")
    mymenu.dr:boolean("w_damage", "Draw W", true)
    mymenu.dr:boolean("r_damage", "Draw R", true)
    mymenu.dr:slider("aa_damage", "Draw AA", 1, 0, 5, 1)

    mymenu.dr:header("state", "State")
    mymenu.dr:boolean("sf", "SpellFarm", true)
    mymenu.dr:boolean("semi_w", "Semi W", true)
    mymenu.dr:boolean("semi_r", "Semi R", true)

    mymenu.dr:header("end_header", "")
    --#endregion

    mymenu:header("kys_header", "Key")
    mymenu:keybind("sf", "SpellFarm", nil, 'MMB')
    mymenu:keybind("semi_w", "Semi W", 'A', nil)
    mymenu:keybind("semi_r", "Semi R", 'T', nil)
    mymenu:header("end_header", "")

    utils:menu_common(nil, { 255, 255, 255, 60 })
elseif hanbot.language == 1 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name)
    mymenu:header(my_name, "Klee: " .. my_name)

    utils:menu_utils(mymenu)

    mymenu:set("icon", player.iconSquare)

    mymenu:menu("combo", "连招")
    --#region combo
    mymenu.combo:header("q_header", "Q")
    mymenu.combo:boolean("q", "使用Q", true)

    mymenu.combo:header("w_header", "W")
    mymenu.combo:boolean("w", "使用W", true)

    mymenu.combo:header("e_header", "E")
    mymenu.combo:boolean("e", "使用E", true)

    mymenu.combo:header("r_header", "R")
    mymenu.combo:slider("r", "单挑使用R当敌人生命 <= x%", 30, 0, 50, 1)
    mymenu.combo:slider("r_dis", " ^- 最小范围", 0, 0, 600, 1)
    mymenu.combo:header("end_header", "")
    --#endregion

    mymenu:menu("harass", "骚扰")
    --#region harass
    mymenu.harass:header("q_header", "Q")
    mymenu.harass:slider("q", "使用Q魔力 >= x % ( 100 = 禁止 )", 50, 0, 100, 1)
    mymenu.harass:boolean("q_mini", "没敌人时切机关枪", true)

    mymenu.harass:header("w_header", "W")
    mymenu.harass:slider("w", "使用W魔力 >= x % ( 100 = 禁止 )", 60, 0, 100, 1)
    mymenu.harass:boolean("w_steal_jg", "抢野怪", true)

    mymenu.harass:header("end_header", "")
    --#endregion

    mymenu:menu("auto", "自动")
    --#region auto_menu
    mymenu.auto:header("header_1", "W")
    mymenu.auto:boolean("w_ks", "捡人头", true)

    mymenu.auto:header("header_2", "E")
    mymenu.auto:menu("e_anti_to", "反突进")
    mymenu.auto.e_anti_to:header("header_1", "反突进")
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local hero_name = enemy.charName
        local hero_data = antigapcloser.gapcloser_spell[hero_name]
        if hero_data then
            for _, skill in ipairs(hero_data) do
                mymenu.auto.e_anti_to:boolean(hero_name .. skill.spell_name, hero_name .. " " .. skill.slot, true)

                if mymenu.auto.e_anti_to[hero_name .. skill.spell_name] and enemy.iconSquare then
                    mymenu.auto.e_anti_to[hero_name .. skill.spell_name]:set('icon', enemy.iconSquare)
                end
            end
        end
    end

    mymenu.auto:header("header_1", "R")
    mymenu.auto:boolean("r_ks", "捡人头", true)

    mymenu.auto:header("end_header", "")
    --#endregion

    mymenu:menu("lc", "清线")
    --#region Laneclear
    mymenu.lc:header("q_header", "W")
    mymenu.lc:boolean("jungle_w", "清野W", true)
    mymenu.lc:header("end_header", "")
    --#endregion

    mymenu:menu("hc", "命中率")
    --#region Hitchance
    mymenu.hc:header("header_w", "W")
    mymenu.hc:slider("w_range", "范围%", 95, 70, 100, 1)
    mymenu.hc:header("header_2", "R")
    mymenu.hc:slider("r_range", "范围", 2000, 2000, 5000, 1)
    mymenu.hc:header("header_5", "")
    --#endregion

    mymenu:menu("dr", "绘制")
    --#region dr
    mymenu.dr:header("draw_ranges_header", "范围")
    mymenu.dr:boolean("q_range_1", "Q范围 (机关枪)", true)
    mymenu.dr:boolean("q_range_2", "Q范围 (炮)", true)
    mymenu.dr:boolean("w_range", "W范围", true)
    mymenu.dr:boolean("e_range", "E范围", false)
    mymenu.dr:boolean("r_range", "R范围", true)

    mymenu.dr:header("draw_damage_header", "伤害")
    mymenu.dr:boolean("w_damage", "绘制W", true)
    mymenu.dr:boolean("r_damage", "绘制R", true)
    mymenu.dr:slider("aa_damage", "绘制普攻", 1, 0, 5, 1)

    mymenu.dr:header("state", "状态")
    mymenu.dr:boolean("sf", "发育", true)
    mymenu.dr:boolean("semi_w", "半手动W", true)
    mymenu.dr:boolean("semi_r", "半手动R", true)

    mymenu.dr:header("end_header", "")
    --#endregion

    mymenu:header("2", "快捷键")
    mymenu:keybind("sf", "发育", nil, 'MMB')
    mymenu:keybind("semi_w", "半手动W", 'A', nil)
    mymenu:keybind("semi_r", "半手动R", 'T', nil)
    mymenu:header("end_header", "")

    utils:menu_common(nil, { 255, 255, 255, 60 })
end

function MasterYi:load()
    self.is_combo = false
    self.is_mixed = false
    self.is_laneclear = false

    self.last_q_t = 0
    self.q_range = 0
    self.q_ready = false
    self.q_level = 0

    self.last_w_t = 0
    self.w_range = 0
    self.w_ready = false
    self.w_level = 0
    self.w_pred = {
        delay = 0.6,
        speed = 3300,
        width = 60,
        boundingRadiusMod = 1,
        range = 1500 * mymenu.hc.w_range:get() / 100,
        collision = {
            minion = true,
            wall = true,
            hero = true,
        },
    }
    self.w_pred_col = {
        delay = 0.6,
        speed = 3300,
        width = 80,
        boundingRadiusMod = 1,
        range = 1500 * mymenu.hc.w_range:get() / 100,
        collision = {
            minion = true,
            wall = true,
            hero = true,
        },
    }

    self.last_e_t = 0
    self.e_range = 0
    self.e_ready = false
    self.e_level = 0

    self.last_r_t = 0
    self.r_range = 0
    self.r_ready = false
    self.r_level = 0
    self.r_pred = {
        delay = 0.6,
        speed = 1700,
        width = 140,
        boundingRadiusMod = 1,
        range = 1100,
        collision = {
            minion = true,
            wall = true,
            hero = false,
        },
    }

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if obj then
            local found = false
            for _, path_data in ipairs(path_datas) do
                if path_data.hero == obj.networkID then
                    found = true
                end
            end
            if not found then
                path_datas[#path_datas + 1] = {
                    hero = obj.networkID,
                    path_end_pos = vec3(0, 0, 0),
                    change_time = game.time
                }
            end
        end
    end
end

function MasterYi:spell_check()
    self.is_combo = orb.menu.combat.key:get()
    self.is_mixed = orb.menu.hybrid.key:get()
    self.is_laneclear = orb.menu.lane_clear.key:get() and mymenu.sf:get()

    self.is_under_turret = utils:in_enemy_turret(player.pos)
    self.q_as_buff = utils:get_buff_count(player, "MasterYiqramp")
    self.q_mini_gun = utils:has_buff(player, "MasterYiqicon")
    self.q_big_gun = utils:has_buff(player, "MasterYiq")

    --q
    self.q_range = self.q_mini_gun and
        player.boundingRadius + player.attackRange + 80 + 30 * (self.q_level - 1)
        or
        player.boundingRadius + player.attackRange - 80 - 30 * (self.q_level - 1)
    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0

    --w
    self.w_range = 1500 * mymenu.hc.w_range:get() / 100
    self.w_pred.range = 1500 * mymenu.hc.w_range:get() / 100
    self.w_pred_col.range = 1500 * mymenu.hc.w_range:get() / 100
    self.w_level = player:spellSlot(1).level
    self.w_ready = self.w_level > 0 and player:spellSlot(1).state == 0
    self.w_pred.delay = math.max(0.6 - (player.attackSpeedMod - 1) / 0.25 * 0.02, 0.4)
    self.w_pred_col.delay = math.max(0.6 - (player.attackSpeedMod - 1) / 0.25 * 0.02, 0.4)

    --e
    self.e_range = 925
    self.e_level = player:spellSlot(2).level
    self.e_ready = self.e_level > 0 and player:spellSlot(2).state == 0

    --r
    self.r_range = mymenu.hc.r_range:get()
    self.r_level = player:spellSlot(3).level
    self.r_ready = self.r_level > 0 and player:spellSlot(3).state == 0
    self.r_pred.range = mymenu.hc.r_range:get()
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function MasterYi:pred_check(target)
    local target_last_move_t = 0
    for _, path_data in ipairs(path_datas) do
        if path_data.hero == target.networkID then
            target_last_move_t = game.time - path_data.change_time
            break
        end
    end

    if pred.trace.newpath(target, 0.015, 0.095) and target.moveSpeed < 750 and target_last_move_t < 0.050 then
        return true
    elseif pred.trace.newpath(target, 0.033, 0.245) and target.moveSpeed < 500 and target_last_move_t < 1.350 then
        return true
    elseif pred.trace.newpath(target, 0.033, 0.370) and target.moveSpeed < 500 and target_last_move_t < 0.550 then
        return true
    elseif pred.trace.newpath(target, 0.010, 0.105) and target.moveSpeed < 500 and target_last_move_t < 0.050 then
        return true
    elseif pred.trace.newpath(target, 0.033, 0.305) and target.moveSpeed < 325 and target_last_move_t < 1.350 then
        return true
    elseif pred.trace.newpath(target, 0.033, 0.550) and target.moveSpeed < 325 and target_last_move_t < 0.550 then
        return true
    elseif pred.trace.newpath(target, 0.010, 0.125) and target.moveSpeed < 325 and target_last_move_t < 0.050 then
        return true
    elseif pred.trace.newpath(target, 0.025, 0.200) and target.moveSpeed < 325 and target_last_move_t < 0.200 then
        return true
    elseif pred.trace.newpath(target, 0.166666, 0.5) then
        return true
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

local ks_loop = 0
function MasterYi:ks()
    if ks_loop > game.time then return end
    ks_loop = game.time + 0.1
    local can_ks = utils:use_automatic(mymenu.logic_menu.automatic_menu.ks_turret:get(),
        mymenu.logic_menu.automatic_menu.ks_grass:get(),
        mymenu.logic_menu.automatic_menu.ks_recall:get())

    if not can_ks then return end
    if utils:is_evade() then return end

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if obj and not obj.isZombie then
            if self.e_ready then
                local function filter_e()
                    if player.pos:dist(obj.pos) > self.e_range then return false end
                    return true
                end
                if filter_e() then
                    local hit_t = network.latency + 1
                    if utils:special_cast(obj, hit_t) then
                        player:castSpell('pos', _E, obj.pos)
                        ks_loop = game.time + 0.1
                        break
                    end
                end
            elseif self.w_ready then
                local cast_pos = vec3(0, 0, 0)
                local function filter_w()
                    if player.pos:dist(obj.pos) > self.w_range then return false end
                    local seg = pred.linear.get_prediction(self.w_pred, obj)
                    if not seg then return false end
                    local col = pred.collision.get_prediction(self.w_pred_col, seg, obj)
                    if col then return false end
                    cast_pos = vec3(seg.endPos.x, obj.pos.y, seg.endPos.y)
                    return true
                end
                if filter_w() and cast_pos ~= vec3(0, 0, 0) then
                    if mymenu.auto.w_ks:get() and dmg_lib:MasterYi_W(player, obj) > utils:get_real_hp(obj, true, true)
                        and
                        utils:is_valid(obj)
                        and
                        not utils:ignore_spell(obj) and not utils:has_buff(obj, "SamiraW")
                        and
                        not utils:in_aa_range(player, obj)
                    then
                        if self.q_big_gun then
                            player:castSpell('self', _Q)
                        end
                        player:castSpell('pos', _W, cast_pos)
                        ks_loop = game.time + 0.3
                        break
                    end
                    local hit_t = network.latency + self.w_pred.delay + player.pos:dist(obj.pos) / self.w_pred.speed +
                        0.1
                    if utils:special_cast(obj, hit_t) then
                        if self.q_big_gun then
                            player:castSpell('self', _Q)
                        end
                        player:castSpell('pos', _W, cast_pos)
                        ks_loop = game.time + 0.1
                        break
                    end
                end
            elseif self.r_ready and mymenu.auto.r_ks:get() and not utils:in_aa_range(player, obj)
            then
                local cast_pos = vec3(0, 0, 0)
                local function filter_r()
                    if player.pos:dist(obj.pos) > self.r_range then return false end
                    if not utils:is_valid(obj) then return false end
                    if damagelib.get_spell_damage('MasterYiR', 0, player, obj, false, 0) < utils:get_real_hp(obj, true, true) then return false end
                    local seg = pred.linear.get_prediction(self.r_pred, obj)
                    if not seg then return false end
                    local col = pred.collision.get_prediction(self.r_pred, seg, obj)
                    if col then return false end
                    cast_pos = vec3(seg.endPos.x, obj.pos.y, seg.endPos.y)
                    return true
                end

                if filter_r() and cast_pos ~= vec3(0, 0, 0) and not navmesh.isWall(cast_pos) then
                    player:castSpell('pos', _R, cast_pos)
                    ks_loop = game.time + 0.3
                    break
                end
            end
        end
    end
end

local e_anti_loop = 0
function MasterYi:Anti_gapcloser()
    if e_anti_loop > game.time then return end
    for i = #antigapcloser.dash_data, 1, -1 do
        local dash_list = antigapcloser.dash_data[i]
        local menu = mymenu.auto.e_anti_to[dash_list.sender.charName .. dash_list.spell_name]
        local time_check = game.time > dash_list.start_t
        local dis_check = dash_list.sender and player.pos:dist(dash_list.sender.pos) < 475 or false
        local dis_check_2 = dash_list.end_pos:dist(player.pos) < 100
        if menu and menu:get() and dash_list.sender and time_check and dis_check and dis_check_2 then --  and game.time > dash_list.start_t + 0.1
            if not utils:ignore_spell(dash_list.sender) then
                local range = dash_list.sender.moveSpeed * 0.9 - 100
                local cast_pos = utils:extend_vec(player.pos, dash_list.sender.pos, -range)
                if not navmesh.isWall(cast_pos) then
                    player:castSpell('pos', _E, cast_pos)
                    e_anti_loop = game.time + 0.5
                end
            end
        end
    end
end

local q_loop = 0
function MasterYi:Q_logic()
    if not self.q_ready then return end
    if q_loop > game.time then return end

    local range = self.q_range - player.boundingRadius
    local target = utils:get_target(range, "AD", true)

    if self.is_mixed and mymenu.harass.q_mini:get() and self.q_big_gun and target then
        player:castSpell('self', _Q)
        q_loop = game.time + 0.5
    end

    if not target then return end

    local use_q = (self.is_combo and mymenu.combo.q:get())
        or
        (self.is_mixed and mymenu.harass.q:get() <= utils:get_mana_pre(player))
    if not use_q then return end

    local target_path = utils:check_2Dpath(target, 0.9)
    local path_dis = target_path:dist(player.pos2D)
    local dis = target.pos:dist(player.pos) + target.boundingRadius
    local as = dmg_lib:as(player)

    if utils.time_until_next_aa == 0 and self.q_mini_gun and not utils:in_aa_range(player, target) then
        player:castSpell('self', _Q)
        player:attack(target)
        q_loop = game.time + 0.5
    elseif utils.time_until_next_aa < 0.2 and self.q_big_gun and dis < self.q_range and (self.q_as_buff < 3 or as < 0.9 or path_dis < self.q_range) then
        player:castSpell('self', _Q)
        q_loop = game.time + 0.5
    end
end

local w_loop = 0
function MasterYi:W_logic()
    if not self.w_ready then return end
    if w_loop > game.time then return end
    if utils:is_evade() then return end

    local use_w = (self.is_combo and mymenu.combo.w:get())
        or
        (self.is_mixed and mymenu.harass.w:get() <= utils:get_mana_pre(player))
        or
        mymenu.semi_w:get()
    if not use_w then return end

    local target = utils:get_target(self.w_pred.range, "AD")
    if utils.orb_t and utils:is_valid(utils.orb_t) and utils.orb_t.type == TYPE_HERO then
        target = utils.orb_t
    end

    if not target then return end

    local aa_damage = damagelib.calc_aa_damage(player, target, false) * self.w_pred.delay * dmg_lib:as(player)
    local in_aa = utils:in_aa_range(player, target)
    if aa_damage > dmg_lib:MasterYi_W(player, target) and in_aa then return end

    if aa_damage * 3 > utils:get_real_hp(target, true, true) and in_aa then return end

    local smooth = (in_aa and (utils.after_aa_t >= game.time or (utils.time_until_next_aa > self.w_pred.delay and not player.activeSpell)))
        or
        (not in_aa and not player.activeSpell)

    if not smooth then return end


    local seg = pred.linear.get_prediction(self.w_pred, target)
    if not seg then return end
    local col = pred.collision.get_prediction(self.w_pred_col, seg, target)
    if col then return end

    local hit_t = player.pos:dist(target.pos) / self.w_pred.speed + self.w_pred.delay + network.latency
    local next_path = utils:check_2Dpath(target, hit_t)
    local pred_1 = player.pos2D:dist(next_path) < self.w_pred.range

    local pred_2 = utils:get_cc_time(target) > 0 and utils:get_cc_time(target) < hit_t

    local pred_3 = MasterYi:pred_check(target) and utils:get_cc_time(target) == 0
    local cast_pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)

    if pred_1 and (pred_2 or pred_3) then
        if self.q_big_gun then
            player:castSpell('self', _Q)
        end
        player:castSpell('pos', _W, cast_pos)
        w_loop = game.time + 0.1
    end
end

function MasterYi:Steal_monster()
    if not self.w_ready then return end

    if player.activeSpell then return end

    local use_w = (self.is_mixed and mymenu.harass.w_steal_jg:get())
    if not use_w then return end

    if w_loop > game.time then return end
    if utils:is_evade() then return end

    local Obj = objManager.minions[TEAM_NEUTRAL]
    local Obj_size = objManager.minions.size[TEAM_NEUTRAL]
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        local function filter()
            if not utils:is_valid(obj) then return false end

            local obj_pos = obj.pos
            local player_pos = player.pos
            local dist = player_pos:dist(obj_pos)
            if dist > self.w_pred.range then return false end

            local seg = pred.linear.get_prediction(self.w_pred, obj)
            if not seg then return false end
            local col = pred.collision.get_prediction(self.w_pred, seg, obj)
            if col then return false end

            if not obj.isSmiteMonster then return false end
            local hit_t = dist / self.w_pred.speed + self.w_pred.delay + network.latency
            local obj_hp = orb.farm.predict_hp(obj, hit_t)
            local can_kill = dmg_lib:MasterYi_W(player, obj) > obj_hp
            if can_kill then
                return true
            end
            return false
        end
        if filter() then
            player:castSpell('pos', _W, obj.pos)
            w_loop = game.time + 1
        end
    end
end

local e_loop = 0
function MasterYi:E_logic()
    if not self.e_ready then return end
    if e_loop > game.time then return end

    local use_e = (self.is_combo and mymenu.combo.e:get())
    if not use_e then return end

    local target = utils:get_target(self.e_range, "AD")
    if utils.last_aa_target and utils:is_valid(utils.last_aa_target) and utils.last_aa_target.type == TYPE_HERO then
        target = utils.last_aa_target
    end
    if not target then return end

    local dist = player.pos:dist(target.pos) > 600
    local chase = not utils:face(target, player.pos) and utils:face(player, target.pos)
    local path_angle = target.path and target.path.isMoving and
        utils:calc_angle(target.path.endPos2D, target.pos2D, player.pos2D) > 135
    local range = target.moveSpeed * 1.3 - 50
    local cast_pos_1 = utils:extend_vec(target.pos, player.pos, -range)
    local range_check = player.pos:dist(cast_pos_1) < self.e_range
    local use_e_1 = dist and path_angle and chase and range_check

    local use_e_2 = utils:get_cc_time(target) > 0 and utils:get_cc_time(target) < 1.3 + network.latency

    if use_e_1 and not navmesh.isWall(cast_pos_1) then
        player:castSpell('pos', _E, cast_pos_1)
        e_loop = game.time + 1
    elseif use_e_2 then
        player:castSpell('pos', _E, target.pos)
        e_loop = game.time + 3
    end
end

local r_loop = 0
function MasterYi:R_logic()
    if not self.r_ready then return end
    if r_loop > game.time then return end
    if utils:is_evade() then return end
    if player.activeSpell then return end

    local target = utils:get_target(self.r_pred.range, "AD")
    if not utils:is_valid(target) then return end

    local use_r = mymenu.semi_r:get()
        or
        (utils:get_real_hp_pre(target) <= mymenu.combo.r:get() and self.is_combo
            and
            utils:count_enemy_hero(player.pos, 1000) < 2
            and
            player.pos:dist(target.pos) > mymenu.combo.r_dis:get())
    if not use_r then return end

    local seg = pred.linear.get_prediction(self.r_pred, target)
    if not seg then return end
    local col = pred.collision.get_prediction(self.r_pred, seg, target)
    if col then return end

    local pred_1 = pred.trace.linear.hardlock(self.r_pred, seg, target)
    local pred_2 = pred.trace.linear.hardlockmove(self.r_pred, seg, target)
    local pred_3 = MasterYi:pred_check(target)
    local cast_pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)

    if navmesh.isWall(cast_pos) then return end

    if pred_1 or pred_2 or pred_3 then
        player:castSpell('pos', _R, cast_pos)
        r_loop = game.time + 0.1
    end
end

function MasterYi:on_tick()
    if not player or player.isDead then return end

    local target = utils:get_target(1000, "AD")
    if target then
        chat.print(target:spellSlot(1).cooldown) --target:spellSlot(1).state == 0  self.w_level
    end
    -- local buff = utils:has_buff(player, "zhonyasringshield")
    -- if buff then
    --     chat.print(buff.endTime - game.time)
    -- end

    self:spell_check()

    --
    --  Logic
    --
    self:Q_logic()
    self:W_logic()
    self:Steal_monster()
    self:R_logic()
    self:E_logic()
    self:ks()
    self:Anti_gapcloser()
end

function MasterYi:on_process_spell_cast(spell)
    if not spell or player.isDead then return end

    if spell.owner and spell.owner == player and spell.name == "MasterYiQ" then
        self.last_q_t = game.time
    end
end

--#region draw
function MasterYi:draw_damage()
    if not mymenu.dr.w_damage:get()
        and
        not mymenu.dr.r_damage:get()
        and
        mymenu.dr.aa_damage:get() == 0
    then
        return
    end

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n

    for i = 0, Obj_size - 1
    do
        local enemy = Obj[i]

        if utils:is_valid(enemy) and enemy.isVisible and enemy.isOnScreen
        then
            local dmg = { passive = 0, aa = 0, q = 0, w = 0, e = 0, r = 0 }
            if mymenu.dr.w_damage:get() and self.w_ready then
                dmg.w = dmg_lib:MasterYi_W(player, enemy)
            end
            if mymenu.dr.r_damage:get() and self.r_ready then
                dmg.r = damagelib.get_spell_damage('MasterYiR', 0, player, enemy, false, 0)
            end
            if mymenu.dr.aa_damage:get() > 0 then
                dmg.aa = damagelib.calc_aa_damage(player, enemy, true) +
                    damagelib.calc_aa_damage(player, enemy, false) * (mymenu.dr.aa_damage:get() - 1)
            end

            utils:draw_hp_bar(enemy, dmg)
        end
    end
end

function MasterYi:on_draw()
    if not player or player.isDead then return end

    if keyboard.isKeyDown(0x09) then return end

    if mymenu.dr.q_range_1:get() and not self.q_mini_gun and game.time > self.last_q_t + 0.3 and self.q_level > 0 then
        utils:draw_circle("q_range_1", player.pos, self.q_range, utils.menuc.drawdr_menu.clr_q:get(), nil)
    end
    if mymenu.dr.q_range_2:get() and not self.q_big_gun and game.time > self.last_q_t + 0.3 and self.q_level > 0 then
        utils:draw_circle("q_range_2", player.pos, self.q_range, utils.menuc.drawdr_menu.clr_q:get(), nil)
    end

    if mymenu.dr.w_range:get() and self.w_range and self.w_level > 0
    then
        utils:draw_circle("w_range", player.pos, self.w_range, utils.menuc.drawdr_menu.clr_w:get(), nil,
            self.w_ready and 255 or 50)
    end
    if mymenu.dr.e_range:get() and self.e_range and self.e_level > 0
    then
        utils:draw_circle("e_range", player.pos, self.e_range, utils.menuc.drawdr_menu.clr_e:get(), nil,
            self.e_ready and 255 or 50)
    end
    if mymenu.dr.r_range:get() and self.r_pred.range and self.r_level > 0
    then
        utils:draw_circle("r_range", player.pos, self.r_pred.range, utils.menuc.drawdr_menu.clr_r:get(), nil,
            self.r_ready and 255 or 50)

        minimap.draw_circle(player.pos, self.r_pred.range, 1, utils.menuc.drawdr_menu.clr_r:get(), 18)
    end

    local state_style = utils.menuc.draw_state_menu.state_style:get()
    local text_size = utils.menuc.draw_state_menu.text_size:get()
    local state_color = utils.menuc.draw_state_menu.text_color:get()
    local state_pos = player.pos + vec3(50, 0, -50)
    local p2d = graphics.world_to_screen(state_pos)
    local state_list = {
        { mymenu.sf,     mymenu.dr.sf:get() },
        { mymenu.semi_w, mymenu.dr.semi_w:get() },
        { mymenu.semi_r, mymenu.dr.semi_r:get() },
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

    self:draw_damage()
end

--#endregion

-- ///////////////////////////////////////////////////////////////////////////////////////////

local function MasterYi_on_tick()
    MasterYi:on_tick()
end

local function MasterYi_on_draw()
    MasterYi:on_draw()
end

local function MasterYi_on_process_spell(spell)
    MasterYi:on_process_spell_cast(spell)
end

local function MasterYi_path(target)
    if not target or player.isDead then return end

    if target.type == TYPE_HERO and target.team == TEAM_ENEMY then
        for _, path_data in ipairs(path_datas) do
            if path_data.hero == target.networkID then
                path_data.path_end_pos = target.path.endPos
                path_data.change_time = game.time
            end
        end
    end
end

function MasterYi:bind_callbacks(b_remove)
    if not b_remove
    then
        if self.b_callbacks_registered
        then
            return
        end

        cb.add(cb.tick, MasterYi_on_tick)
        cb.add(cb.draw, MasterYi_on_draw)
        cb.add(cb.spell, MasterYi_on_process_spell)
        cb.add(cb.path, MasterYi_path)

        self.b_callbacks_registered = true
    elseif b_remove and b_remove == true
    then
        cb.remove(cb.tick, MasterYi_on_tick)
        cb.remove(cb.draw, MasterYi_on_draw)
        cb.remove(cb.spell, MasterYi_on_process_spell)
        cb.remove(cb.path, MasterYi_path)

        self.b_callbacks_registered = false
    end
end

function MasterYi:init(b_callbacks)
    self:load()
    if b_callbacks
    then
        self:bind_callbacks()
    end
end

return MasterYi:init(true)
