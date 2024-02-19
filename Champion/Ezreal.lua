local Ezreal = {}
---@type utils
local utils = module.load(header.id, "Help/utils")
local my_name = player.charName
local antigapcloser = module.load(header.id, "Help/anti_gapcloser")
local dmg_lib = module.load(header.id, "Help/dmg_lib")

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

    mymenu.combo:header("header_2", "W")
    mymenu.combo:boolean("w", "Use W", true)
    mymenu.combo:boolean("spam_w", " ^- Spam", false)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "Harass")
    -- #region harass
    mymenu.harass:header("header_1", "Q")
    mymenu.harass:slider("q", "Use Q if Mana >= x % ( 100 = Disable )", 0, 0, 100, 1)

    mymenu.harass:header("header_2", "W")
    mymenu.harass:slider("w", "Use W if Mana >= x % ( 100 = Disable )", 100, 0, 100, 1)

    mymenu.harass:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "Automatic")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "Killsteal", true)
    mymenu.auto:header("header_3", "E")

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

    mymenu.auto:header("header_4", "R")
    mymenu.auto:boolean("r_ks", "Killsteal", true)
    mymenu.auto:header("header_5", "")
    -- #endregion

    mymenu:menu("lc", "Laneclear")
    -- #region laneclear
    mymenu.lc:header("header_1", "Laneclear")
    mymenu.lc:boolean("q_lc", "Laneclear Q", true)
    mymenu.lc:header("header_2", "Jungle clear")
    mymenu.lc:boolean("q_jg", "Jungle Q", true)
    mymenu.lc:boolean("w_jg", "Jungle W", true)
    mymenu.lc:header("header_turret", "Turret")
    mymenu.lc:boolean("w_turret", "Turret W", true)
    mymenu.lc:header("header_misc", "Misc")
    mymenu.lc:boolean("fl", "Use fast laneclear (LMB)", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("hc", "Hitchance")
    -- #region hitchance
    mymenu.hc:header("header_1", "Q")
    mymenu.hc:slider("q_range", "Range %", 90, 70, 100, 1)
    mymenu.hc:dropdown("q_hc", "Hitchance", 2, { "Fast", "High" })
    mymenu.hc:slider("q_hero", "Ignore hero collision >= x level", 18, 1, 30, 1)
    mymenu.hc:slider("q_minion", "Ignore minion collision >= x level", 30, 11, 30, 1)
    mymenu.hc:header("header_1_1", "Auto Q")
    mymenu.hc:slider("auto_q_range", "Range %", 85, 70, 100, 1)
    mymenu.hc:dropdown("auto_q_hc", "Hitchance", 2, { "Fast", "High" })
    mymenu.hc:slider("auto_q_hero", "Ignore hero collision >= x level", 18, 1, 30, 1)
    mymenu.hc:slider("auto_q_minion", "Ignore minion collision >= x level", 30, 11, 30, 1)
    mymenu.hc:header("header_2", "W")
    mymenu.hc:slider("w_range", "Range %", 90, 70, 100, 1)
    mymenu.hc:header("header_3", "R")
    mymenu.hc:slider("r_range", "Range", 2000, 1500, 7000, 1)
    mymenu.hc:header("header_5", "")
    --mymenu.hc:dropdown("w_hc", "Hitchance", 4, { "Low", "Mid", "High", "Very high" })
    -- #endregion

    mymenu:menu("dr", "Drawings")
    -- #region Drawings
    mymenu.dr:header("range", "Range")
    mymenu.dr:boolean("Q", "Draw Q", true)
    mymenu.dr:boolean("R", "Draw R", true)

    mymenu.dr:header("damage", "Damage")
    mymenu.dr:boolean("q_damage", "Draw Q", true)
    mymenu.dr:boolean("w_damage", "Draw W", true)
    mymenu.dr:boolean("e_damage", "Draw E", true)
    mymenu.dr:boolean("r_damage", "Draw R", true)
    mymenu.dr:slider("aa_damage", "Draw AA", 1, 0, 5, 1)

    mymenu.dr:header("state", "State")
    mymenu.dr:boolean("sf", "SpellFarm", true)
    mymenu.dr:boolean("auto_q", "Auto Q", true)
    mymenu.dr:boolean("semi_r", "Semi R", true)

    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "Key")
    mymenu:keybind("sf", "SpellFarm", nil, 'MMB')
    mymenu:keybind("auto_q", "Auto Q", nil, 'A')
    mymenu:keybind("semi_w", "Semi W", nil, nil)
    mymenu:keybind("semi_r", "Semi R", 'T', nil)
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

    mymenu.combo:header("header_2", "W")
    mymenu.combo:boolean("w", "使用W", true)
    mymenu.combo:boolean("spam_w", " ^- 有W就放", false)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "骚扰")
    -- #region harass
    mymenu.harass:header("header_1", "Q")
    mymenu.harass:slider("q", "使用Q魔力 >= x % ( 100 = 禁止 )", 0, 0, 100, 1)

    mymenu.harass:header("header_2", "W")
    mymenu.harass:slider("w", "使用W魔力 >= x % ( 100 = 禁止 )", 100, 0, 100, 1)

    mymenu.harass:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "自动")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "捡人头", true)
    mymenu.auto:header("header_3", "E")

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

    mymenu.auto:header("header_4", "R")
    mymenu.auto:boolean("r_ks", "捡人头", true)
    mymenu.auto:header("header_5", "")
    -- #endregion

    mymenu:menu("lc", "清线")
    -- #region laneclear
    mymenu.lc:header("header_1", "清兵")
    mymenu.lc:boolean("q_lc", "清兵Q", true)
    mymenu.lc:header("header_2", "清野")
    mymenu.lc:boolean("q_jg", "清野Q", true)
    mymenu.lc:boolean("w_jg", "清野W", true)
    mymenu.lc:header("header_87", "炮塔")
    mymenu.lc:boolean("w_turret", "炮塔W", true)
    mymenu.lc:header("header_misc", "杂项")
    mymenu.lc:boolean("fl", "使用快速清线 (左键)", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("hc", "命中率")
    -- #region hitchance
    mymenu.hc:header("header_1", "Q")
    mymenu.hc:slider("q_range", "范围%", 90, 70, 100, 1)
    mymenu.hc:dropdown("q_hc", "命中率", 2, { "快速", "高" })
    mymenu.hc:slider("q_hero", "无视英雄碰撞 >= x 等级", 18, 1, 30, 1)
    mymenu.hc:slider("q_minion", "无视小兵碰撞 >= x 等级", 30, 11, 30, 1)
    mymenu.hc:header("header_1_1", "自动Q")
    mymenu.hc:slider("auto_q_range", "范围%", 85, 70, 100, 1)
    mymenu.hc:dropdown("auto_q_hc", "命中率", 2, { "快速", "高" })
    mymenu.hc:slider("auto_q_hero", "无视英雄碰撞 >= x 等级", 18, 1, 30, 1)
    mymenu.hc:slider("auto_q_minion", "无视小兵碰撞 >= x 等级", 30, 11, 30, 1)
    mymenu.hc:header("header_2", "W")
    mymenu.hc:slider("w_range", "范围%", 90, 70, 100, 1)
    mymenu.hc:header("header_3", "R")
    mymenu.hc:slider("r_range", "范围", 2000, 1500, 7000, 1)
    mymenu.hc:header("header_5", "")
    --mymenu.hc:dropdown("w_hc", "Hitchance", 4, { "Low", "Mid", "High", "Very high" })
    -- #endregion

    mymenu:menu("dr", "绘制")
    -- #region Drawings
    mymenu.dr:header("range", "范围")
    mymenu.dr:boolean("Q", "绘制Q", true)
    mymenu.dr:boolean("R", "绘制R", true)

    mymenu.dr:header("damage", "伤害")
    mymenu.dr:boolean("q_damage", "绘制Q", true)
    mymenu.dr:boolean("w_damage", "绘制W", true)
    mymenu.dr:boolean("e_damage", "绘制E", true)
    mymenu.dr:boolean("r_damage", "绘制R", true)
    mymenu.dr:slider("aa_damage", "绘制普攻", 1, 0, 5, 1)

    mymenu.dr:header("state", "状态")
    mymenu.dr:boolean("sf", "发育", true)
    mymenu.dr:boolean("auto_q", "自动Q", true)
    mymenu.dr:boolean("semi_r", "半手动R", true)

    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "快捷键")
    mymenu:keybind("sf", "发育", nil, 'MMB')
    mymenu:keybind("auto_q", "自动Q", nil, 'A')
    mymenu:keybind("semi_w", "半手动W", nil, nil)
    mymenu:keybind("semi_r", "半手动R", 'T', nil)
    mymenu:header("header_end", "")
end
local common = utils:menu_common()

local orb = module.internal('orb')
local pred = module.internal('pred')
local damagelib = module.internal('damagelib')
local ts = module.internal('TS')
local evade = module.seek('evade')
local path_datas = {}

function Ezreal:load()
    self.is_combo = false
    self.is_mixed = false
    self.is_laneclear = false
    self.is_fastclear = false
    self.is_lasthit = false

    self.last_q_t = 0
    self.q_range = 0
    self.auto_q_range = 0
    self.q_ready = false
    self.q_level = 0
    self.q_pred = {
        delay = 0.25,
        speed = 2000,
        width = 60,
        boundingRadiusMod = 1,
        range = self.q_range,
        collision = {
            minion = true,
            wall = true,
            hero = true,
        },
    }
    self.auto_q_pred = {
        delay = 0.25,
        speed = 2000,
        width = 60,
        boundingRadiusMod = 1,
        range = self.auto_q_range,
        collision = {
            minion = true,
            wall = true,
            hero = true,
        },
    }
    self.wq_pred = {
        delay = 0.5,
        speed = 2000,
        width = 60,
        boundingRadiusMod = 1,
        range = self.q_range,
        collision = {
            minion = true,
            wall = true,
            hero = true,
        },
    }

    self.last_w_t = 0
    self.w_range = 0
    self.w_ready = false
    self.w_level = 0
    self.w_pred = {
        delay = 0.25,
        speed = 1700,
        width = 80,
        boundingRadiusMod = 1,
        range = self.w_range,
        collision = {
            minion = false,
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
        delay = 1.0,
        speed = 2000,
        width = 160,
        boundingRadiusMod = 1,
        range = self.r_range,
        collision = {
            minion = false,
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

function Ezreal:spell_check()
    self.is_combo = orb.menu.combat.key:get()
    self.is_mixed = orb.menu.hybrid.key:get()
    self.is_laneclear = orb.menu.lane_clear.key:get() and mymenu.sf:get()
    --self.is_fastclear = orb.core.is_mode_active( OrbwalkingMode.LaneClear) and orb.farm.is_spell_clear_active() and orb.farm.is_fast_clear_enabled()
    self.is_lasthit = self.is_laneclear or orb.menu.last_hit.key:get()

    self.q_range = 1200 * mymenu.hc.q_range:get() / 100
    self.auto_q_range = 1200 * mymenu.hc.auto_q_range:get() / 100
    self.q_pred.range = self.q_range
    self.auto_q_pred.range = self.auto_q_range
    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0

    self.w_range = 1200 * mymenu.hc.q_range:get() / 100
    self.wq_pred.range = self.w_range
    self.w_pred.range = self.w_range
    self.w_level = player:spellSlot(1).level
    self.w_ready = self.w_level > 0 and player:spellSlot(1).state == 0

    self.e_range = 475
    self.e_level = player:spellSlot(2).level
    self.e_ready = self.e_level > 0 and player:spellSlot(2).state == 0

    self.r_range = mymenu.hc.r_range:get()
    self.r_pred.range = self.r_range
    self.r_level = player:spellSlot(3).level
    self.r_ready = self.r_level > 0 and player:spellSlot(3).state == 0
end

-- ///////////////////////////////////////////////////////////////////////////////////////////
--wtf
function Ezreal:pred_check(target)
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

function Ezreal:pred_can_hit(input, target)
    local seg = pred.linear.get_prediction(input, target)
    if not seg then return nil end
    local col = pred.collision.get_prediction(input, seg, target)
    if col then return nil end
    return seg
end

function Ezreal:cast_q(target, auto)
    if utils:is_evade() then
        return
    end
    if target then
        if utils:ignore_aa(target) or utils:has_buff(target, "SamiraW") then return end
        local seg = auto and Ezreal:pred_can_hit(self.auto_q_pred, target)
            or
            not auto and Ezreal:pred_can_hit(self.q_pred, target)
        if not seg then return end

        local pred_0 = auto and mymenu.hc.auto_q_hc:get() == 1 or mymenu.hc.q_hc:get() == 1
        local pred_1 = pred.trace.linear.hardlock(self.q_pred, seg, target)
        local pred_2 = pred.trace.linear.hardlockmove(self.q_pred, seg, target)

        local hit_t = player.pos:dist(target.pos) / self.q_pred.speed + self.q_pred.delay
        local next_path = utils:check_2Dpath(target, hit_t)
        local pred_4 = auto and player.pos2D:dist(next_path) < self.auto_q_pred.range
            or
            not auto and player.pos2D:dist(next_path) < self.q_pred.range

        local cast_pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)

        if pred_4 and (pred_0 or pred_1 or pred_2 or Ezreal:pred_check(target)) then
            player:castSpell('pos', 0, cast_pos)
            return
        end
    end
end

function Ezreal:cast_w(target)
    if target then
        local seg = Ezreal:pred_can_hit(self.w_pred, target)
        if not seg then return end

        local pred_1 = pred.trace.linear.hardlock(self.w_pred, seg, target)
        local pred_2 = pred.trace.linear.hardlockmove(self.w_pred, seg, target)

        local hit_t = player.pos:dist(target.pos) / self.w_pred.speed + self.w_pred.delay
        local next_path = utils:check_2Dpath(target, hit_t)
        local pred_4 = player.pos2D:dist(next_path) < self.w_pred.range

        local cast_pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)

        if pred_4 and (pred_1 or pred_2 or Ezreal:pred_check(target)) then
            player:castSpell('pos', 1, cast_pos)
            return
        end
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

-- #region Automatic
local e_anti_loop = 0
function Ezreal:Anti_gapcloser()
    if e_anti_loop > game.time then return end
    for i = #antigapcloser.dash_data, 1, -1 do
        local dash_list = antigapcloser.dash_data[i]
        local menu = mymenu.auto.e_anti_to[dash_list.sender.charName .. dash_list.spell_name]
        local time_check = game.time > dash_list.start_t
        local dis_check = dash_list.sender and player.pos:dist(dash_list.sender.pos) < 475 or false
        if menu and menu:get() and dash_list.sender and time_check and dis_check then --  and game.time > dash_list.start_t + 0.1
            --local pos = player.pos - (dash_list.sender.pos - player.pos):norm() * 475
            --local pos = player.pos - (dash_list.end_pos - player.pos):norm() * 475

            local point = {}
            for i = 1, 4 do
                local circle = utils:circle_2d(player.pos2D, i * 120, 3 + i * 3)
                for i = 1, #circle do
                    local wall = navmesh.isWall(circle[i])
                    local evade_check = not evade or (evade and not utils:is_danger_2d_pos(circle[i]))
                    local count_enemy = circle[i]:countEnemies(200)
                    if not wall and evade_check and count_enemy == 0 then
                        point[#point + 1] = circle[i]
                    end
                end
            end

            table.sort(point, function(a, b)
                return a:dist(dash_list.start_pos:to2D()) > b:dist(dash_list.start_pos:to2D())
            end)
            if point[1] then
                player:castSpell('pos', 2, point[1]:to3D(player.y))
                e_anti_loop = game.time + 0.5
                return
            end
        end
    end
end

local ks_loop = 0
function Ezreal:Ks_logic()
    if game.time < ks_loop then return end
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        ks_loop = game.time + 0.1
        local obj = Obj[i]
        if utils:is_valid(obj) and not obj.isZombie then
            if self.q_ready and obj.pos:dist(player.pos) < self.q_range and utils:get_real_hp(obj, true, true) < dmg_lib:Ezreal_Q(player, obj) then
                local seg = Ezreal:pred_can_hit(self.q_pred, obj)
                if seg then
                    player:castSpell('pos', 0, vec3(seg.endPos.x, obj.pos.y, seg.endPos.y))
                    ks_loop = game.time + 1
                    break
                end
            elseif self.r_ready and obj.pos:dist(player.pos) < self.r_range and utils:count_enemy_hero(player.pos, 800) == 0 and utils:get_real_hp(obj, true, false, true) < dmg_lib:Ezreal_R(player, obj) then
                local seg = Ezreal:pred_can_hit(self.r_pred, obj)
                if seg then
                    player:castSpell('pos', 3, vec3(seg.endPos.x, obj.pos.y, seg.endPos.y))
                    ks_loop = game.time + 1
                    break
                end
            end
        end
    end
end

local auto_q_loop = 0
function Ezreal:Auto_Q()
    if not mymenu.auto_q:get() then return end
    if not self.q_ready then return end
    if auto_q_loop > game.time then return end

    local target = utils:get_target(self.q_pred.range, "AD")
    if utils:is_valid(utils.orb_t) and utils.orb_t.type == TYPE_HERO then
        target = utils.orb_t
    end

    if not target then return end

    local in_aa = player.pos:dist(target.pos) < player.attackRange + player.boundingRadius + target.boundingRadius
    local smooth = (in_aa and game.time < utils.after_aa_t) or
        not player.activeSpell
    --or orb.core.time_to_next_attack() == 0 orb.core.time_to_next_attack() > 0.15 or

    if not smooth then return end

    Ezreal:cast_q(target, true)
    auto_q_loop = game.time + 0.1
end

function Ezreal:Automatic()
    local can_ks = utils:use_automatic(mymenu.logic_menu.automatic_menu.ks_turret:get(),
        mymenu.logic_menu.automatic_menu.ks_grass:get(),
        mymenu.logic_menu.automatic_menu.ks_recall:get())
    local can_automatic = utils:use_automatic(mymenu.logic_menu.automatic_menu.turret:get(),
        mymenu.logic_menu.automatic_menu.grass:get(),
        mymenu.logic_menu.automatic_menu.recall:get())

    if can_automatic then
        Ezreal:Anti_gapcloser()
        Ezreal:Auto_Q()
    end
    if can_ks then
        Ezreal:Ks_logic()
    end
end

-- #endregion


local q_loop = 0
local use_wq = 0
function Ezreal:Q_logic()
    if not self.q_ready then return end
    if q_loop > game.time then return end

    local target = utils:get_target(self.q_pred.range, "AD")
    if utils.orb_t and utils:is_valid(utils.orb_t) and utils.orb_t.type == TYPE_HERO then
        target = utils.orb_t
    end

    if not target then return end

    local mana_pre = utils:get_mana_pre(player)
    local try_w = (mymenu.combo.w:get() and self.is_combo) or (mana_pre > mymenu.harass.w:get() and self.is_mixed)
    local await_w = self.w_ready and try_w and player.mana - player.manaCost0 - player.manaCost1 >= 0
        and utils:get_real_hp(target, true, true, true) - dmg_lib:Ezreal_Q(player, target) > 0
    local in_aa = player.pos:dist(target.pos) < player.attackRange + player.boundingRadius + target.boundingRadius
    local smooth = (in_aa and (utils.after_aa_t >= game.time or (utils.time_until_next_aa > 0.2 and not player.activeSpell))) or
        (not in_aa and not player.activeSpell)


    --or orb.core.time_to_next_attack() == 0 orb.core.time_to_next_attack() > 0.15 or

    if await_w or not smooth then return end --await_w or

    self:cast_q(target)
    q_loop = game.time + 0.1
end

local w_loop = 0
function Ezreal:W_logic()
    if not self.w_ready then return end
    if w_loop > game.time then return end

    local target = utils:get_target(self.w_pred.range, "AD")
    if not target then return end

    local aa_range = player.attackRange + player.boundingRadius + target.boundingRadius
    local target_path_w = utils:check_2Dpath(target, 0.25):to3D(target.y)
    local in_aa = player.pos:dist(target_path_w) <= aa_range
    local can_w_aa = in_aa and game.time > utils.next_aa_t - player:attackCastDelay(64)

    if not can_w_aa and not mymenu.combo.spam_w:get() then return end --

    self:cast_w(target)
    w_loop = game.time + 0.2
end

local wq_loop_q1 = 0
local wq_loop_q2 = 0
local wq_loop_w = 0
function Ezreal:WQ_logic()
    if not self.w_ready or player:spellSlot(0).cooldown > 0.1 then return end

    local target = utils:get_target(self.w_pred.range, "AD")
    if not target then return end

    local can_w = game.time > wq_loop_w and player:spellSlot(0).cooldown < 0.1 and
        player.mana - player.manaCost0 - player.manaCost1 > 0 and
        (game.time < utils.after_aa_t or not player.activeSpell) and self.q_level > 0

    local can_q = false

    --change new pred
    local seg_w = Ezreal:pred_can_hit(self.w_pred, target)
    local seg_wq = Ezreal:pred_can_hit(self.wq_pred, target)
    -- local seg_w = pred.linear.get_prediction(self.w_pred, target)
    -- local seg_wq = pred.linear.get_prediction(self.wq_pred, target)
    if not seg_w or not seg_wq then return end

    -- local col_w = pred.collision.get_prediction(self.w_pred, seg_w, target)
    -- local col_wq = pred.collision.get_prediction(self.wq_pred, seg_wq, target)
    -- if col_w or col_wq then return end

    local pred_1 = pred.trace.linear.hardlock(self.w_pred, seg_w, target)
    local pred_2 = pred.trace.linear.hardlockmove(self.w_pred, seg_w, target)
    local pred_3 = pred.trace.newpath(target, 0.166666, 0.5)
    local hit_t = player.pos:dist(target.pos) / self.wq_pred.speed + self.wq_pred.delay
    local next_path = utils:check_2Dpath(target, hit_t)
    local pred_4 = player.pos2D:dist(next_path) < self.wq_pred.range

    if not pred_1 and not pred_2 and not pred_3 and not pred_4 then return end

    local w_cast_pos = vec3(seg_w.endPos.x, target.pos.y, seg_w.endPos.y)
    local q_cast_pos = vec3(seg_wq.endPos.x, target.pos.y, seg_wq.endPos.y)

    use_wq = game.time + 0.5
    if can_w then
        can_q = true
        player:castSpell('pos', 1, w_cast_pos)
        wq_loop_w = game.time + 1
        orb.core.set_pause_move(0.5)
        orb.core.set_pause_attack(0.5)
    end

    if can_q then
        if game.time > wq_loop_q1 then
            player:castSpell('pos', 0, q_cast_pos, nil, true)
            wq_loop_q1 = game.time + 1
        end
        if game.time > wq_loop_q2 then
            player:castSpell('pos', 0, q_cast_pos, nil, true)
            wq_loop_q2 = game.time + 1
        end
    end
end

function Ezreal:Combo()
    if not self.is_combo then return end
    if use_wq > game.time then return end

    if mymenu.combo.q:get() and mymenu.combo.w:get() then
        self:WQ_logic()
    end
    if mymenu.combo.w:get() then
        self:W_logic()
    end
    if mymenu.combo.q:get() then
        self:Q_logic()
    end
end

function Ezreal:Mixed()
    if not self.is_mixed then return end
    if use_wq > game.time then return end

    local mana_pre = utils:get_mana_pre(player)
    if mana_pre > mymenu.harass.q:get() and mana_pre > mymenu.harass.w:get() then
        self:WQ_logic()
    end
    if mana_pre > mymenu.harass.w:get() then
        self:W_logic()
    end
    if mana_pre > mymenu.harass.q:get() then
        self:Q_logic()
    end
end

local lc_q_loop = 0
local lc_w_loop = 0
local aa_target = nil
function Ezreal:Laneclear()
    if not self.is_laneclear then return end
    if player.activeSpell and utils.after_aa_t < game.time then return end
    local next_aa_time = utils.next_aa_t - game.time
    if next_aa_time < 0.1 and next_aa_time > 0 then return end

    local have_blue = false
    for i = 0, 6 do
        local item_slot = player:inventorySlot(i)
        if item_slot and item_slot.hasItem and item_slot.id == 3508 then
            have_blue = true
            break
        end
    end

    local q_pred = self.q_pred
    local last_aa_target = utils.last_aa_target
    local player_pos = player.pos
    local buff = player.buff["ezrealpassivestacks"]
    local buff_stack = utils:get_buff_count(player, "ezrealpassivestacks")

    local q_monster = {
        low_hp = 999999,
        low_target = nil,
        pos = vec3(0, 0, 0)
    }

    if self.q_ready and game.time > lc_q_loop and mymenu.lc.q_lc:get() then
        local lh_list = {}
        local p_list = {}
        local Minion = objManager.minions["farm"]
        local Minion_size = objManager.minions.size["farm"]

        for i = 0, Minion_size - 1 do
            local obj = Minion[i]
            if utils:is_valid(obj) then
                local obj_dist = obj.pos:dist(player_pos)
                if obj_dist < 1100 then
                    local hit_time = player_pos:dist(obj.pos) / q_pred.speed + q_pred.delay + network.latency
                    local last_aa_t = not last_aa_target or obj ~= last_aa_target or
                        (obj == last_aa_target and orb.farm.predict_hp(obj, hit_time + 0.2) > damagelib.calc_aa_damage(player, obj, true) * 1.1)
                    if last_aa_t then --and not player.activeSpell
                        --buff
                        local buff_time = buff and buff.endTime - game.time or 0
                        local more_p = buff_stack < 5 and self.q_level == 5 and not utils:in_ally_turret(obj.pos)
                        local fast_clear = mymenu.lc.fl:get() and keyboard.isKeyDown(1)
                        local buff_check = buff_stack == 0
                            or
                            more_p
                            or
                            (buff and buff_time < hit_time + 0.5 and
                                buff_time >= hit_time + 0.2)
                            or
                            have_blue
                            or
                            fast_clear

                        local q_dmg = dmg_lib:Ezreal_Q(player, obj)
                        local predicted_hp = orb.farm.predict_hp(obj, hit_time - 0.1) --
                        if predicted_hp < q_dmg and predicted_hp > 5                  --and q_lc_minion.hp > predicted_hp
                        then
                            lh_list[#lh_list + 1] = obj
                        end
                        if buff_check --and q_passive_obj.hp < predicted_hp
                        then
                            p_list[#p_list + 1] = obj
                        end
                    end
                end
            end
        end

        if #lh_list > 1 then
            table.sort(lh_list, function(a, b)
                return a.health < b.health
            end)
        end
        if #p_list > 1 then
            table.sort(p_list, function(a, b)
                return a.health > b.health
            end)
        end

        for i = 1, #lh_list do
            local target = lh_list[i]
            if utils:is_valid(target) then
                local seg = Ezreal:pred_can_hit(q_pred, target)
                if seg then
                    local hit_time = player_pos:dist(target.pos) / q_pred.speed + q_pred.delay
                    --local q_dmg = dmg_lib:Ezreal_Q(player, target)
                    --chat.print(string.format("Q kill: target_hp: %.2f, pred_hp: %.2f, damage_hp: %.2f", target.health, orb.farm.predict_hp(target, hit_time - 0.1), q_dmg))
                    orb.farm.set_ignore(target, hit_time)
                    local q_pos = vec3(seg.endPos.x, target.y, seg.endPos.y)
                    player:castSpell('pos', 0, q_pos)
                    lc_q_loop = game.time + hit_time + 0.1
                    break
                end
            end
        end
        for i = 1, #p_list do
            local target = p_list[i]
            if utils:is_valid(target) then
                local seg = Ezreal:pred_can_hit(q_pred, target)
                if seg then
                    local hit_time = player_pos:dist(target.pos) / q_pred.speed + q_pred.delay
                    --local q_dmg = dmg_lib:Ezreal_Q(player, target)
                    --chat.print(string.format("Q kill: target_hp: %.2f, pred_hp: %.2f, damage_hp: %.2f", target.health, orb.farm.predict_hp(target, hit_time - 0.1), q_dmg))
                    if orb.farm.predict_hp(target, hit_time + 0.1) < dmg_lib:Ezreal_Q(player, target) then
                        orb.farm.set_ignore(target, hit_time + 1)
                    end
                    local q_pos = vec3(seg.endPos.x, target.y, seg.endPos.y)
                    player:castSpell('pos', 0, q_pos)
                    lc_q_loop = game.time + hit_time + 0.1
                    break
                end
            end
        end
    end

    if utils:is_valid(last_aa_target) and last_aa_target.isMonster and self.w_ready then
        local Monster = objManager.minions[TEAM_NEUTRAL]
        local Monster_size = objManager.minions.size[TEAM_NEUTRAL]
        for i = 0, Monster_size - 1 do
            local obj = Monster[i]
            local last_aa_t = obj ~= last_aa_target or
                (obj == last_aa_target and orb.farm.predict_hp(obj, 0.5) > damagelib.calc_aa_damage(player, obj, true) * 1.1)
            if utils:is_valid(obj) and obj.isTargetable and obj.pos:dist(player_pos) < 1100 and last_aa_t then
                if obj.health < q_monster.low_hp then
                    --change new pred
                    local seg = Ezreal:pred_can_hit(q_pred, obj)
                    --local seg = pred.linear.get_prediction(q_pred, obj)
                    --local col = pred.collision.get_prediction(q_pred, seg, obj)
                    if seg then --and not col
                        q_monster.low_hp = obj.health
                        q_monster.low_target = obj
                        q_monster.pos = vec3(seg.endPos.x, obj.y, seg.endPos.y)
                    end
                end
            end
        end
    end

    if mymenu.lc.q_jg:get() and game.time > lc_q_loop and utils:is_valid(last_aa_target) and last_aa_target.isMonster then
        local dis_check = last_aa_target.pos:dist(player_pos) < 1100
        --change new pred
        local seg = Ezreal:pred_can_hit(q_pred, last_aa_target)
        if dis_check and seg then
            local pos = vec3(seg.endPos.x, last_aa_target.pos.y, seg.endPos.y)
            player:castSpell('pos', 0, pos)
            lc_q_loop = game.time + 0.3
        elseif not seg then
            local target = q_monster.low_hp
            if target and q_monster.pos ~= vec3(0, 0, 0) then
                player:castSpell('pos', 0, q_monster.pos)
            end
        end
    end
    if self.w_ready and game.time > lc_w_loop and next_aa_time < 0.25 then
        if mymenu.lc.w_turret:get() then
            local close_turret = utils:close_enemy_turret()
            local count_enemy = utils:count_enemy_hero(player_pos, 1000)
            if close_turret and count_enemy == 0 then
                local my_path = utils:check_2Dpath(player, next_aa_time):to3D(player.y)
                local range = player.attackRange + player.boundingRadius + close_turret.boundingRadius
                local hp_check = damagelib.calc_on_hit_damage(player, close_turret, true) * 2 < close_turret.health
                local dis_check = my_path:dist(close_turret) < range and player_pos:dist(close_turret) < range

                if hp_check and dis_check then
                    player:castSpell("pos", 1, close_turret.pos)
                    lc_w_loop = game.time + 0.4
                end
            end
            if utils:is_valid(last_aa_target) and (last_aa_target.type == TYPE_INHIB or last_aa_target.type == TYPE_NEXUS) then
                player:castSpell("pos", 1, last_aa_target.pos)
                lc_w_loop = game.time + 0.4
            end
        end
        if mymenu.lc.w_jg:get() then
            if utils:is_valid(aa_target) and utils:is_epic_monster(aa_target) and player_pos:dist(aa_target) < 1100 then
                player:castSpell('pos', 1, aa_target.pos)
                lc_w_loop = game.time + 0.2
            end
        end
    end
end

local draw_p_info = {
    buff_c = 0,
    buff_t = 0,
    i = 0,
    x1 = 0,
    y = 0,
    width = 0,
    color = 0,
}
function Ezreal:Draw_setting()
    local DPI_FACTOR = graphics.height > 1080 and graphics.height / 1080 * 0.9 or 1
    local long = 105 * DPI_FACTOR
    local width = 4 * DPI_FACTOR
    local offset = 4.5 * DPI_FACTOR

    local base_x = player.barPos.x + 58 + long
    local y = player.barPos.y + 137 + offset
    local buff_c = utils:get_buff_count(player, "ezrealpassivestacks")
    local buff_t = utils:has_buff(player, "ezrealpassivestacks") and
        player.buff["ezrealpassivestacks"].endTime - game.time or 0
    local color = buff_c == 5 and 0xffff0000 or 0xffdddd00
    local i = buff_c - 1

    draw_p_info.buff_c = buff_c
    draw_p_info.buff_t = buff_t
    draw_p_info.i = i
    draw_p_info.x1 = base_x
    draw_p_info.y = y
    draw_p_info.width = width
    draw_p_info.color = color
end

local r_loop = 0
function Ezreal:Semi_R()
    if not self.r_ready then return end
    if not mymenu.semi_r:get() then return end
    if r_loop > game.time then return end

    local target = utils:get_target(self.r_pred.range, "AP")
    if not target then return end

    local seg = Ezreal:pred_can_hit(self.r_pred, target)
    if not seg then return end

    local cast_pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)

    player:castSpell('pos', 3, cast_pos)
    r_loop = game.time + 0.1
end

local semi_w_loop = 0
function Ezreal:Semi_W()
    if not mymenu.semi_w:get() then return end
    if not self.w_ready then return end
    if semi_w_loop > game.time then return end

    local target = utils:get_target(self.w_pred.range, "AD")
    if not target then return end

    self:cast_w(target)
    w_loop = game.time + 0.2
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Ezreal:tick()
    if player.isDead then return end

    self:spell_check()

    self:Automatic()
    self:Combo()
    self:Mixed()
    self:Laneclear()
    self:Semi_R()
    self:Semi_W()

    self:Draw_setting()

    -- print(orb.core.next_attack)
    -- print(orb.core.time_to_next_attack())
    -- print(orb.core.is_winding_up_attack())
end

local q_pred_c_1 = false
local q_pred_c_2 = false
local auto_q_pred_c_1 = false
local auto_q_pred_c_2 = false
function Ezreal:slow_tick()
    if player.isDead then return end

    if player.levelRef >= mymenu.hc.q_hero:get() and not q_pred_c_1 then
        self.q_pred.collision = {
            minion = true,
            wall = true,
            hero = false,
        }
        q_pred_c_1 = true
    end
    if player.levelRef >= mymenu.hc.q_minion:get() and not q_pred_c_2 then
        self.q_pred.collision = {
            minion = false,
            wall = true,
            hero = false,
        }
        q_pred_c_2 = true
    end
    if player.levelRef >= mymenu.hc.auto_q_hero:get() and not auto_q_pred_c_1 then
        self.auto_q_pred.collision = {
            minion = true,
            wall = true,
            hero = false,
        }
        auto_q_pred_c_1 = true
    end
    if player.levelRef >= mymenu.hc.auto_q_minion:get() and not auto_q_pred_c_2 then
        self.auto_q_pred.collision = {
            minion = false,
            wall = true,
            hero = false,
        }
        auto_q_pred_c_2 = true
    end
end

function Ezreal:process_spell(spell)
    if not spell or player.isDead then return end

    if spell.owner and spell.owner.type == TYPE_HERO and spell.owner.team == TEAM_ENEMY and spell.name == "SummonerFlash" then
        local spell_pos = spell.owner.pos + (spell.endPos - spell.owner.pos):norm() * 475
        if player.pos:dist(spell_pos) < 475 and self.e_ready and utils:get_real_hp_pre(player) < 80 then
            local pos = player.pos - (spell.owner.pos - player.pos) * 500
            player:castSpell('pos', 2, pos)
        end
    end

    if spell.owner and spell.owner == player then
        if spell.isBasicAttack then
            aa_target = spell.target
        end
        if spell.name == "EzrealW" then
            self.last_w_t = game.time
            orb.core.set_pause_move(0.25)
            orb.core.set_pause_attack(0.25)
        end
        if spell.name == "EzrealQ" then
            orb.core.set_pause_move(0.25)
            orb.core.set_pause_attack(0.25)
        end
    end

    -- last_q_t
    -- last_w_t
    -- last_e_t
    -- last_r_t
end

function Ezreal:finish_spell(spell)
    if not spell or player.isDead then return end
end

function Ezreal:on_cast_spell(args)
    if not args or player.isDead then return end

    --print( args.spellSlot)
end

function Ezreal:path(target)
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

local cast_spell_q_pos = vec3(0, 0, 0)
local pred_spell_q_pos = vec3(0, 0, 0)
local stop_time = 0

function Ezreal:Draw_test()
    local target = utils:get_target(self.q_pred.range, "AD")

    if target and self.q_ready then --
        if game.time > stop_time then
            local seg = pred.linear.get_prediction(self.q_pred, target)
            if not seg then return end
            local col = pred.collision.get_prediction(self.q_pred, seg, target)
            if col then return end

            local pred_1 = pred.trace.linear.hardlock(self.q_pred, seg, target)
            local pred_2 = pred.trace.linear.hardlockmove(self.q_pred, seg, target)
            local pred_3 = false --pred.trace.newpath(target, 0.166666, 0.5)

            local hit_t = player.pos:dist(target.pos) / self.q_pred.speed + self.q_pred.delay
            local next_path = utils:check_2Dpath(target, hit_t)
            local pred_4 = player.pos2D:dist(next_path) < self.q_pred.range

            local cast_pos = vec3(seg.endPos.x, 0, seg.endPos.y)
            local pred_pos = player.pos + (cast_pos - player.pos):norm() * 400


            if pred_4 and (pred_1 or pred_2 or pred_3 or Ezreal:pred_check(target)) then --
                pred_spell_q_pos = vec3(pred_pos.x, 0, pred_pos.z)
            else
                pred_spell_q_pos = vec3(0, 0, 0)
            end
        end
    end

    if game.time < stop_time + 0.2 then
        if cast_spell_q_pos ~= vec3(0, 0, 0) then
            graphics.draw_circle(cast_spell_q_pos, 30, 2, 0xFFFFFFFF, 3)
        end
    end
    if pred_spell_q_pos ~= vec3(0, 0, 0) then
        graphics.draw_circle(pred_spell_q_pos, 50, 2, 0xFFFF8080, 3)
    end
end

function Ezreal:dmg_output()
    if not mymenu.dr.q_damage:get()
        and
        not mymenu.dr.w_damage:get()
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

            if mymenu.dr.q_damage:get() and self.q_ready then
                dmg.q = dmg_lib:Ezreal_Q(player, enemy)
            end
            if mymenu.dr.w_damage:get() and self.w_ready then
                dmg.w = dmg_lib:Ezreal_W(player, enemy)
            end
            if mymenu.dr.e_damage:get() and self.e_ready then
                dmg.e = dmg_lib:Ezreal_E(player, enemy)
            end
            if mymenu.dr.r_damage:get() and self.r_ready then
                dmg.r = dmg_lib:Ezreal_R(player, enemy)
            end

            if mymenu.dr.aa_damage:get() > 0 then
                dmg.aa = damagelib.calc_aa_damage(player, enemy, true) +
                    damagelib.calc_aa_damage(player, enemy, false) * (mymenu.dr.aa_damage:get() - 1)
            end

            utils:draw_hp_bar(enemy, dmg)
        end
    end
end

function Ezreal:new_draw()
    if player.isDead then return end

    if keyboard.isKeyDown(0x09) then return end

    if mymenu.dr.Q:get() then
        local color = self.q_ready and common.drawdr_menu.clr_q:get() or
            utils:set_alpha(common.drawdr_menu.clr_q:get(), 120)
        --graphics.draw_circle(player.pos, self.q_range, 2, color, 72)
        --circle_q:update_circle(player.pos, self.q_range, 3, color)
        utils:draw_circle("q_range", player.pos, self.q_range, color)
    end
    if mymenu.dr.R:get() then
        local color = self.r_ready and common.drawdr_menu.clr_r:get() or
            utils:set_alpha(common.drawdr_menu.clr_r:get(), 120)
        --graphics.draw_circle(player.pos, self.r_range, 2, color, 36)
        --utils:draw_circle("r_range", player.pos, self.r_range, color)
        minimap.draw_circle(player.pos, self.r_range, 1, color, 18)
    end

    if draw_p_info.buff_c > 0 then
        for i = 0, draw_p_info.i do
            local x1 = draw_p_info.x1 + (i * 22)
            local x2 = i == draw_p_info.buff_c - 1 and x1 + draw_p_info.buff_t / 6 * 17 or x1 + 17
            local y = draw_p_info.y
            local width = draw_p_info.width
            local color = draw_p_info.color
            graphics.draw_line_2D(x1, y, x2, y, width, color)
        end
    end

    local state_style = utils.menuc.draw_state_menu.state_style:get()
    local text_size = utils.menuc.draw_state_menu.text_size:get()
    local state_color = utils.menuc.draw_state_menu.text_color:get()
    local state_pos = player.pos + vec3(50, 0, -50)
    local p2d = graphics.world_to_screen(state_pos)
    local state_list = {
        { mymenu.sf,     mymenu.dr.sf:get() },
        { mymenu.auto_q, mymenu.dr.auto_q:get() },
        { mymenu.semi_r, mymenu.dr.semi_r:get() },

    }
    for _, list in ipairs(state_list) do
        if list[2] == true and list[1] and list[1] == mymenu.sf and (list[1]:get() or state_style == 1) then
            local key = (list[1].key and "[" .. list[1].key .. "] ") or
                (list[1].toggle and "[" .. list[1].toggle .. "] ")
                or
                nil
            if key then
                local lc = list[1].text
                local fast_lc = list[1].text .. " (fast)"                          --keyboard.isKeyDown(1)
                local text = keyboard.isKeyDown(1) and self.is_laneclear and key .. fast_lc or key .. lc --
                local size = text_size
                local color = list[1]:get() and state_color or utils:set_alpha(state_color, 100)
                graphics.draw_text_2D(text, size, p2d.x, p2d.y, color)
                p2d.y = p2d.y + text_size
            end
        elseif list[2] == true and list[1] and (list[1]:get() or state_style == 1) then
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

    Ezreal:dmg_output()
    --Ezreal:Draw_test()
end

function Ezreal:init()
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

return Ezreal:init()
