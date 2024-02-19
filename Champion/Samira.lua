local Samira = {}

---@type utils
local utils = module.load(header.id, "Help/utils")
local my_name = player.charName
local spell_data = module.load(header.id, "Help/spell_database")

local dmg_lib = module.load(header.id, "Help/dmg_lib")

local orb = module.internal('orb')
local pred = module.internal('pred')
local damagelib = module.internal('damagelib')
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

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "Use E", true)
    mymenu.combo:slider("e_s", " ^- Use E->R combo if hp <= x%", 0, 0, 100, 1)
    mymenu.combo:slider("e_dash", " ^- Dash >= x range", 300, 0, 400, 1)

    mymenu.combo:header("header_4", "R")
    mymenu.combo:boolean("r", "Use R", true)
    mymenu.combo:boolean("r_ks", " ^- If killable", true)
    mymenu.combo:slider("r_aoe", " ^- AOE >= x", 2, 0, 6, 1)
    mymenu.combo:boolean("r_solo", " ^- Solo", true)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "Harass")
    -- #region harass
    mymenu.harass:header("header_1", "Q")
    mymenu.harass:slider("q", "Use Q if Mana >= x % ( 100 = Disable )", 0, 0, 100, 1)

    mymenu.harass:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "Automatic")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "Killsteal", true)
    mymenu.auto:header("header_2", "W")
    mymenu.auto:boolean("w_ks", "Killsteal", true)
    mymenu.auto:boolean("no_w_ks_brust", " ^- Don't use killsteal in brust", true)
    mymenu.auto:header("header_wdodge", "W dodge")
    local w_count = 0
    for i = 0, objManager.enemies_n - 1 do
        local champion = objManager.enemies[i]
        local hero_name = champion.charName
        local hero_data = spell_data[hero_name]
        if hero_data then
            for _, spell in ipairs(hero_data) do
                w_count = w_count + 1
                local missile = spell.missile
                if missile == true then
                    local menu_tab = mymenu.auto["w_" .. hero_name]
                    if not menu_tab then
                        mymenu.auto:menu("w_" .. hero_name, hero_name)
                    end
                    mymenu.auto["w_" .. hero_name]:slider(spell.name,
                        hero_name .. " " .. spell.Spell .. " " .. "  Hp <= x", spell.menu, 0, 100, 1)

                    mymenu.auto["w_" .. hero_name]:set('icon', champion.iconSquare)
                end
            end
        end
    end
    if w_count == 0 then
        mymenu.auto:header("e_data", "No data")
    end
    mymenu.auto:header("header_3", "E")
    mymenu.auto:boolean("e_ks", "Killsteal", true)
    mymenu.auto:header("header_5", "")
    -- #endregion

    mymenu:menu("lc", "Laneclear")
    -- #region laneclear
    mymenu.lc:header("header_1", "Laneclear")
    mymenu.lc:boolean("q_lc", "Laneclear Q", true)
    mymenu.lc:header("header_2", "Jungle clear")
    mymenu.lc:boolean("q_jg", "Jungleclear Q", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("hc", "Hitchance")
    -- #region hitchance
    mymenu.hc:header("header_1", "Q")
    mymenu.hc:slider("q_range", "Range %", 90, 70, 100, 1)
    --mymenu.hc:dropdown("q_hc", "Hitchance", 2, { "Fast", "High" })
    mymenu.hc:header("header_5", "")
    --mymenu.hc:dropdown("w_hc", "Hitchance", 4, { "Low", "Mid", "High", "Very high" })
    -- #endregion

    mymenu:menu("dr", "Drawings")
    -- #region Drawings
    mymenu.dr:header("range", "Range")
    mymenu.dr:boolean("Q", "Draw Q", true)
    mymenu.dr:boolean("W", "Draw W", false)
    mymenu.dr:boolean("E", "Draw E", true)
    mymenu.dr:boolean("R", "Draw R", false)

    mymenu.dr:header("damage", "Damage")
    mymenu.dr:boolean("q_damage", "Draw Q", true)
    mymenu.dr:boolean("w_damage", "Draw W", true)
    mymenu.dr:boolean("e_damage", "Draw E", true)
    mymenu.dr:boolean("r_damage", "Draw R", true)
    mymenu.dr:slider("aa_damage", "Draw AA", 0, 0, 5, 1)

    mymenu.dr:header("state", "State")
    mymenu.dr:boolean("sf", "SpellFarm", true)
    mymenu.dr:boolean("dive", "Dive", true)
    mymenu.dr:boolean("brust", "Brust", true)
    mymenu.dr:boolean("auto_q", "Auto Q", true)
    mymenu.dr:boolean("semi_e", "Semi E", true)

    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "Key")
    mymenu:keybind("sf", "SpellFarm", nil, 'MMB')
    mymenu:keybind("dive", "Dive", nil, 'T')
    mymenu:keybind("brust", "Brust", nil, 'A')
    mymenu:keybind("auto_q", "Auto Q", nil, 'U')
    mymenu:keybind("semi_e", "Semi E", 'E', nil)
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

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "使用E", true)
    mymenu.combo:slider("e_s", " ^- 使用 E->R 连招当生命 <= x%", 0, 0, 100, 1)
    mymenu.combo:slider("e_dash", " ^- 使用E >= x范围", 300, 0, 400, 1)

    mymenu.combo:header("header_4", "R")
    mymenu.combo:boolean("r", "使用R", true)
    mymenu.combo:boolean("r_ks", " ^- 如果可击杀", true)
    mymenu.combo:slider("r_aoe", " ^- AOE >= x", 2, 0, 6, 1)
    mymenu.combo:boolean("r_solo", " ^- 单挑", true)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "骚扰")
    -- #region harass
    mymenu.harass:header("header_1", "Q")
    mymenu.harass:slider("q", "使用Q魔力 >= x % ( 100 = 禁止 )", 0, 0, 100, 1)

    mymenu.harass:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "自动")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "捡人头", true)
    mymenu.auto:header("header_2", "W")
    mymenu.auto:boolean("w_ks", "捡人头", true)
    mymenu.auto:boolean("no_w_ks_brust", " ^- 秒S不用W捡人头", true)
    mymenu.auto:header("header_wdodge", "W格挡")
    local w_count = 0
    for i = 0, objManager.enemies_n - 1 do
        local champion = objManager.enemies[i]
        local hero_name = champion.charName
        local hero_data = spell_data[hero_name]
        if hero_data then
            for _, spell in ipairs(hero_data) do
                w_count = w_count + 1
                local missile = spell.missile
                if missile == true then
                    local menu_tab = mymenu.auto["w_" .. hero_name]
                    if not menu_tab then
                        mymenu.auto:menu("w_" .. hero_name, hero_name)
                    end
                    mymenu.auto["w_" .. hero_name]:slider(spell.name,
                        hero_name .. " " .. spell.Spell .. " " .. "  Hp <= x", spell.menu, 0, 100, 1)

                    mymenu.auto["w_" .. hero_name]:set('icon', champion.iconSquare)
                end
            end
        end
    end
    if w_count == 0 then
        mymenu.auto:header("e_data", "没有资料")
    end
    mymenu.auto:header("header_3", "E")
    mymenu.auto:boolean("e_ks", "捡人头", true)
    mymenu.auto:header("header_5", "")
    -- #endregion

    mymenu:menu("lc", "清线")
    -- #region laneclear
    mymenu.lc:header("header_1", "清兵")
    mymenu.lc:boolean("q_lc", "清兵Q", true)
    mymenu.lc:header("header_2", "清野")
    mymenu.lc:boolean("q_jg", "清野Q", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("hc", "命中率")
    -- #region hitchance
    mymenu.hc:header("header_1", "Q")
    mymenu.hc:slider("q_range", "范围%", 90, 70, 100, 1)
    --mymenu.hc:dropdown("q_hc", "Hitchance", 2, { "Fast", "High" })
    mymenu.hc:header("header_5", "")
    --mymenu.hc:dropdown("w_hc", "Hitchance", 4, { "Low", "Mid", "High", "Very high" })
    -- #endregion

    mymenu:menu("dr", "绘制")
    -- #region Drawings
    mymenu.dr:header("range", "范围")
    mymenu.dr:boolean("Q", "绘制Q", true)
    mymenu.dr:boolean("W", "绘制W", false)
    mymenu.dr:boolean("E", "绘制E", true)
    mymenu.dr:boolean("R", "绘制R", false)

    mymenu.dr:header("damage", "伤害")
    mymenu.dr:boolean("q_damage", "绘制Q", true)
    mymenu.dr:boolean("w_damage", "绘制W", true)
    mymenu.dr:boolean("e_damage", "绘制E", true)
    mymenu.dr:boolean("r_damage", "绘制R", true)
    mymenu.dr:slider("aa_damage", "绘制AA", 0, 0, 5, 1)

    mymenu.dr:header("state", "状态")
    mymenu.dr:boolean("sf", "发育", true)
    mymenu.dr:boolean("dive", "越塔", true)
    mymenu.dr:boolean("brust", "秒S", true)
    mymenu.dr:boolean("auto_q", "自动Q", true)
    mymenu.dr:boolean("semi_e", "半手动E", true)

    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "快捷键")
    mymenu:keybind("sf", "发育", nil, 'MMB')
    mymenu:keybind("dive", "越塔", nil, 'T')
    mymenu:keybind("brust", "秒S", nil, 'A')
    mymenu:keybind("auto_q", "自动Q", nil, 'U')
    mymenu:keybind("semi_e", "半手动E", 'E', nil)
    mymenu:header("header_end", "")
end
local common = utils:menu_common()

function Samira:load()
    self.is_combo = false
    self.is_mixed = false
    self.is_laneclear = false
    self.is_fastclear = false
    self.is_lasthit = false

    self.p_range = 650

    self.last_q_t = 0
    self.q_range = 0
    self.q_ready = false
    self.q_level = 0
    self.q_pred = {
        delay = 0.25,
        speed = 2600,
        width = 60,
        boundingRadiusMod = 1,
        range = 1100,
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

    self.last_e_t = 0
    self.e_range = 0
    self.e_ready = false
    self.e_level = 0

    self.last_r_t = 0
    self.r_range = 0
    self.r_ready = false
    self.r_level = 0

    self.last_spell = "No"
    self.p_stack = 0
end

function Samira:spell_check()
    self.is_combo = orb.menu.combat.key:get()
    self.is_mixed = orb.menu.hybrid.key:get()
    self.is_laneclear = orb.menu.lane_clear.key:get() and mymenu.sf:get()
    --self.is_fastclear = orb.core.is_mode_active( OrbwalkingMode.LaneClear) and orb.farm.is_spell_clear_active() and orb.farm.is_fast_clear_enabled()
    self.is_lasthit = self.is_laneclear or orb.menu.last_hit.key:get()

    self.q_range = 950 * mymenu.hc.q_range:get() / 100
    self.q_pred.range = self.q_range
    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0

    self.w_range = 380
    self.w_level = player:spellSlot(1).level
    self.w_ready = self.w_level > 0 and player:spellSlot(1).state == 0

    self.e_range = 600
    self.e_level = player:spellSlot(2).level
    self.e_ready = self.e_level > 0 and player:spellSlot(2).state == 0

    self.r_range = 600
    self.r_level = player:spellSlot(3).level
    self.r_ready = self.r_level > 0 and player:spellSlot(3).state == 0

    self.p_stack = utils:get_buff_count2(player, "SamiraPassiveCombo")
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Samira:can_kill(target)
    if not target then return false end
    local dmg = 0
    local can_stack = 0
    if self.q_ready then
        dmg = dmg + dmg_lib:Samira_Q(player, target)
        can_stack = can_stack + 1
    end
    if self.w_ready then
        dmg = dmg + dmg_lib:Samira_W(player, target)
        if mymenu.brust:get() then
            can_stack = can_stack + 1
        end
    end
    if self.e_ready then
        dmg = dmg + dmg_lib:Samira_E(player, target)
        can_stack = can_stack + 1
    end

    local can_r = false
    if can_stack == 3 then
        can_r = true
    elseif can_stack == 2 and self.p_stack >= 2 then
        can_r = true
    elseif can_stack == 1 and self.p_stack >= 4 then
        can_r = true
    elseif self.p_stack == 5 and self.last_spell ~= "A" then
        can_r = true
    elseif self.p_stack == 6 then
        can_r = true
    end
    if can_r and self.r_level > 0 then
        dmg = dmg + dmg_lib:Samira_R(player, target)
    else
        dmg = dmg + damagelib.calc_aa_damage(player, target, true) * 3
    end

    if dmg >= utils:get_real_hp(target, true, true) then
        return true
    else
        return false
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Samira:cast_q(target)
    if not target then return end

    if utils:ignore_spell(target) then return end
    if utils:has_buff(target, "SamiraW") then return end

    local path = utils:check_2Dpath(target, 0.25 + network.latency):to3D(target.y)
    if player.pos:dist(path) < 340 and not player.path.isDashing then
        player:castSpell('pos', 0, target.pos)
        return
    else
        local seg = pred.linear.get_prediction(self.q_pred, target)
        if not seg then return end
        local col = pred.collision.get_prediction(self.q_pred, seg, target)
        if col then return end

        local pred_1 = pred.trace.linear.hardlock(self.q_pred, seg, target)
        local pred_2 = pred.trace.linear.hardlockmove(self.q_pred, seg, target)
        local pred_3 = pred.trace.newpath(target, 0.3, 0.5)
        local pred_4 = self.q_level >= 3

        local in_aa = utils:in_aa_range(player, target)
        local good_time = (in_aa and (utils.after_aa_t >= game.time or (utils.time_until_next_aa > 0.2 and not player.activeSpell))) or
            (not in_aa and not player.activeSpell)

        if (pred_1 or pred_2 or pred_3 or pred_4) and good_time then
            local cast_pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)
            player:castSpell('pos', 0, cast_pos)
        end
    end
end

function Samira:E_pos(target)
    if self.e_level == 0 or not self.e_ready or not target then
        return vec3(0, 0, 0)
    end

    local e_range = 650
    local target_pos = target.pos
    local my_pos = player.pos

    for i = e_range, 0, -10 do
        local r_pos = player.pos + (target_pos - my_pos):norm() * i
        if not navmesh.isWall(r_pos) then
            return r_pos
        end
    end
    return vec3(0, 0, 0)
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

local ks_loop = 0
function Samira:ks()
    if ks_loop > game.time then return end
    ks_loop = game.time + 0.2
    local can_ks = utils:use_automatic(mymenu.logic_menu.automatic_menu.ks_turret:get(),
        mymenu.logic_menu.automatic_menu.ks_grass:get(),
        mymenu.logic_menu.automatic_menu.ks_recall:get())

    if not can_ks then return end

    local r_buff = utils:has_buff(player, "SamiraR")
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if utils:is_valid(obj) and not obj.isZombie then
            local end_pos = Samira:E_pos(obj)
            if self.e_ready and mymenu.auto.e_ks:get() and dmg_lib:Samira_E(player, obj) > utils:get_real_hp(obj)
                and
                player.pos:dist(obj.pos) <= self.e_range
                and
                (not utils:in_enemy_turret(end_pos) or mymenu.dive:get())
                and
                (not evade or evade.core.is_action_safe(end_pos, 1600, 0) == true)
            then
                player:castSpell('obj', _E, obj)
                ks_loop = game.time + 0.1
                break
            elseif not r_buff then
                if self.q_ready and mymenu.auto.q_ks:get() and dmg_lib:Samira_Q(player, obj) > utils:get_real_hp(obj, true, true) and player.pos:dist(obj.pos) <= self.q_range then
                    Samira:cast_q(obj)
                    ks_loop = game.time + 0.1
                elseif self.w_ready and mymenu.auto.w_ks:get()
                    and
                    (not mymenu.auto.no_w_ks_brust:get() or mymenu.brust:get())
                    and
                    dmg_lib:Samira_W(player, obj) / 2 > utils:get_real_hp(obj, true, true)
                    and
                    player.pos:dist(obj.pos) <= self.w_range
                then
                    player:castSpell('self', _W)
                    ks_loop = game.time + 0.3
                end
            end
        end
    end
end

local w_loop = 0
function Samira:w_dodge()
    if not self.w_ready then return end
    if w_loop > game.time then return end

    if evade then
        for i = evade.core.skillshots.n, 1, -1 do
            local spell = evade.core.skillshots[i]
            if not spell or not spell.name then return end

            if spell:contains(player) then
                local menu0 = mymenu.auto["w_" .. spell.owner.charName]
                if not menu0 then return end

                local menu = mymenu.auto["w_" .. spell.owner.charName][spell.name]
                if not menu then return end

                local start_pos = vec3(spell.start_pos.x, 0, spell.start_pos.y)
                local hit_t = 0
                if spell.data.speed == math.huge then
                    hit_t = 0.2
                else
                    hit_t = start_pos:dist(player.pos) / spell.data.speed
                end

                if hit_t > 0 and 0.2 + network.latency > hit_t and menu:get() >= utils:get_real_hp_pre(player) then
                    player:castSpell('self', 1)
                    w_loop = game.time + 1
                end
            end
        end
        for i = evade.core.targeted.n, 1, -1 do
            local function filter()
                local spell = evade.core.targeted[i]
                if not spell then return false end
                if not spell.owner then return false end
                if not spell.owner.type == TYPE_HERO then return false end
                if not spell.name or not spell.missile or not spell.target then return false end
                if not spell.target == player then return false end
                if spell.missile.pos:dist(player.pos) > 250 then return false end

                local menu0 = mymenu.auto["w_" .. spell.owner.charName]
                if not menu0 then return false end

                local menu = mymenu.auto["w_" .. spell.owner.charName][spell.name]
                if not menu then return false end

                if menu:get() >= utils:get_real_hp_pre(player) then
                    return true
                end
                return false
            end

            if filter() then
                player:castSpell('self', 1)
                w_loop = game.time + 1
            end
            -- local spell = evade.core.targeted[i]

            -- if not spell or not spell.name or not spell.missile or not spell.target then return end
            -- if spell.target == player and spell.missile.pos:dist(player.pos) < 250 then
            --     local menu0 = mymenu.auto["w_" .. spell.owner.charName]
            --     if not menu0 then return end

            --     local menu = mymenu.auto["w_" .. spell.owner.charName][spell.name]
            --     if not menu then return end

            --     if menu:get() >= utils:get_real_hp_pre(player) then
            --         player:castSpell('pos', 1, spell.missile.pos)
            --         w_loop = game.time + 1
            --     end
            -- end
        end
    end
end

local auto_q_loop = 0
function Samira:Auto_Q()
    if not self.q_ready then return end
    if not mymenu.auto_q:get() then return end
    if game.time < auto_q_loop then return end
    local target = utils:get_target(self.q_range, self.q_pred, false, nil, nil, "line")

    if target then
        Samira:cast_q(target)
        auto_q_loop = game.time + 0.1
    end
end

function Samira:Automatic()
    local can_automatic = utils:use_automatic(mymenu.logic_menu.automatic_menu.turret:get(),
        mymenu.logic_menu.automatic_menu.grass:get(),
        mymenu.logic_menu.automatic_menu.recall:get())

    Samira:ks()
    Samira:w_dodge()
    if can_automatic then
        Samira:Auto_Q()
    end
end

local brust_loop = 0
local brust_use_w = 0
local brust_w_manget = 0
function Samira:Brust_logic()
    if self.r_level == 0 then return end
    local target = utils:get_target(self.e_range, "AD")
    local orb_t = utils.orb_t
    if orb_t and orb_t.type == TYPE_HERO and orb_t.team == TEAM_ENEMY and not orb_t.isZombie then
        target = orb_t
    end

    if brust_w_manget > game.time and target and target.pos:dist(player.pos) > self.w_range - 50 then
        orb.core.set_pause_move(0.04)
        local pos = target.pos + (player.pos - target.pos):norm() * (self.w_range - 50)
        player:move(pos)
    end

    if target and utils:count_enemy_hero(player.pos, self.w_range) > 0 and brust_use_w > game.time then
        player:castSpell('self', _W, nil, nil, true)
    end

    if target and brust_loop < game.time then
        local end_pos = Samira:E_pos(target)
        local use_e = not utils:in_enemy_turret(end_pos) or mymenu.dive:get()

        local all_spell = self.q_ready and self.w_ready and self.e_ready
        local only_qe = self.q_ready and not self.w_ready and self.e_ready
        local only_we = self.w_ready and not self.q_ready and self.e_ready
        local one_stack =
            (self.p_stack == 0 and utils.after_aa_t >= game.time)
            or
            (self.last_spell == "A" and self.p_stack >= 1) --and self.p_stack <= 2
        -- or
        -- (self.last_spell ~= "A" and self.p_stack <= 2 and self.p_stack >= 1 and utils.after_aa_t >= game.time)
        local eqw = self.p_stack == 3

        if all_spell and utils:count_enemy_hero(player.pos, self.w_range) > utils:count_enemy_hero(player.pos, self.w_range / 2) and one_stack and use_e then
            brust_w_manget = game.time + 0.75
            player:castSpell('self', _W, nil, nil, true)
            player:castSpell('obj', _E, target, nil, true)
            player:castSpell('pos', _Q, target.pos, nil, true)
            brust_loop = game.time + 0.2
            -- elseif all_spell and dis <= self.w_range and one_stack and use_e then
            --     brust_w_manget = game.time + 0.75
            --     player:castSpell('self', _W, nil, nil, true)
            --     player:castSpell('obj', _E, target, nil, true)
            --     player:castSpell('pos', _Q, target.pos, nil, true)
            --     brust_loop = game.time + 0.2
        elseif all_spell and utils:count_enemy_hero(player.pos, self.w_range) == 0 and (one_stack or eqw) and use_e then
            player:castSpell('obj', _E, target, nil, true)
            player:castSpell('pos', _Q, target.pos, nil, true)
            brust_use_w = game.time + 0.5
            brust_loop = game.time + 0.2
        elseif self.last_spell ~= "E" and (only_qe or only_we) and self.p_stack >= 3 and use_e then
            player:castSpell('obj', _E, target, nil, true)
            player:castSpell('pos', _Q, target.pos, nil, true)
            brust_use_w = game.time + 0.5
            brust_loop = game.time + 0.2
        elseif self.last_spell == "A" and self.p_stack == 4 and use_e then
            player:castSpell('obj', _E, target, nil, true)
            player:castSpell('pos', _Q, target.pos, nil, true)
            brust_use_w = game.time + 0.5
            brust_loop = game.time + 0.2
        elseif self.p_stack == 5 and use_e then
            player:castSpell('obj', _E, target, nil, true)
            player:castSpell('pos', _Q, target.pos, nil, true)
            brust_loop = game.time + 0.2
        end
    end

    if self.r_ready and utils:count_enemy_hero(player.pos, self.r_range) > 0 and utils:is_valid(target) then
        player:castSpell('self', _R)
    end
end

local q_loop = 0
function Samira:Q_logic(mode)
    if not self.q_ready then return end
    if game.time < q_loop then return end
    if utils:is_evade() then return end
    
    local can_q = false
    if mode == 'combo' and mymenu.combo.q:get() then
        can_q = true
    end
    if mode == 'mix' and mymenu.harass.q:get() <= utils:get_mana_pre(player) then
        can_q = true
    end
    if not can_q then return end

    local target = utils:get_target(self.q_range, "AD")
    local orb_t = utils.orb_t
    if orb_t and orb_t.type == TYPE_HERO and orb_t.team == TEAM_ENEMY then
        target = orb_t
    end

    if target then
        Samira:cast_q(target)
        q_loop = game.time + 0.1
    end
end

local e_loop = 0
function Samira:E_logic()
    if not self.e_ready or e_loop > game.time then return end

    local target = utils:get_target(self.e_range, "AD")
    -- local orb_t = utils.orb_t
    -- if orb_t and orb_t.type == TYPE_HERO and orb_t.team == TEAM_ENEMY then
    --     target = orb_t
    -- end

    if not target then return end
    if not utils:has_buff(player, "SamiraR") and self.p_stack == 0 then return end

    local can_e_1 = Samira:can_kill(target)
        and
        (utils:get_real_hp_pre(player) > 60 or player.health > target.health)

    local can_e_2 = utils:has_buff(player, "SamiraR")
        and
        math.max(player.buff["samirar"].endTime - game.time, 0) > 0.5

    local can_e_3 = mymenu.combo.e_s:get() >= utils:get_real_hp_pre(player)
        and
        (
            (self.last_spell ~= "A" and self.p_stack >= 4)
            or
            (self.last_spell ~= "E" and self.p_stack >= 5)
        )

    local good_time = utils:has_buff(player, "SamiraR")
        or
        utils.after_aa_t >= game.time
        or
        not player.activeSpell

    if target.pos:dist(player.pos) > mymenu.combo.e_dash:get() and good_time and (can_e_1 or can_e_2 or can_e_3) then
        local end_pos = Samira:E_pos(target)
        if (not utils:in_enemy_turret(end_pos) or mymenu.dive:get())
            and
            (not evade or evade.core.is_action_safe(end_pos, 1600, 0) == true)
        then
            player:castSpell('obj', 2, target)
            e_loop = game.time + 0.1
            return
        end
    end
end

local r_loop = 0
function Samira:R_logic()
    if not self.r_ready or r_loop > game.time then return end

    local target = utils:get_target(self.r_range, "AD")
    local use_r_1 = target and dmg_lib:Samira_R(player, target) > utils:get_real_hp(target, true, true)
    local use_r_2 = utils:count_enemy_hero(player.pos, self.r_range) >= mymenu.combo.r_aoe:get()
    local use_r_3 = utils:count_enemy_hero(player.pos, 1000)
    if use_r_1 or use_r_2 or use_r_3 then
        player:castSpell('self', 3)
        r_loop = game.time + 1
    end
end

local aa_p_target_loop = 0
function Samira:AA_P_target()
    if game.time < aa_p_target_loop then return end
    if game.time > utils.after_aa_t and player.activeSpell then return end

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if obj and obj.pos:dist(player.pos) <= self.p_range then
            if obj.buff[BUFF_STUN] or obj.buff[BUFF_SNARE] or obj.buff[BUFF_KNOCKUP] or obj.buff[BUFF_CHARM] or
                obj.buff[BUFF_FLEE] or obj.buff[BUFF_TAUNT] or obj.buff[BUFF_ASLEEP] or obj.buff[BUFF_SUPPRESSION]
            then
                if not utils:has_buff(obj, "samirapcooldown") then
                    player:attack(obj)
                    aa_p_target_loop = game.time + player:attackDelay() - player:attackCastDelay(64)
                    break
                end
            end
        end
    end
end

function Samira:Combo()
    if not self.is_combo then return end

    if mymenu.brust:get() then
        self:Brust_logic()
    end
    Samira:E_logic()
    local brust_combo = mymenu.brust:get() and self.w_ready and self.e_ready and self.r_level > 0
    if not brust_combo then
        Samira:Q_logic('combo')
    end
    Samira:R_logic()
    Samira:AA_P_target()
end

function Samira:Mixed()
    if not self.is_mixed then return end
    Samira:Q_logic('mix')
end

local q_farm_pred = {
    width = 200,
    delay = 0.25,
    speed = math.huge,
    range = 300,
    boundingRadiusMod = 0.7,
    collision = { hero = false, minion = false, walls = true },
}

function Samira:Laneclear()
    if not self.is_laneclear then return end
    if not self.q_ready then return end
    if player.activeSpell then return end

    if mymenu.lc.q_lc:get() then
        local q_pos = utils:get_best_lc_pos("line", q_farm_pred, 3, false, 0)
        if q_pos ~= vec3(0, 0, 0) then
            player:castSpell('pos', _Q, q_pos)
        end
    end
    if mymenu.lc.q_jg:get()
        and
        utils.last_aa_target and utils.last_aa_target.isMonster
        and
        utils.last_aa_target.health > damagelib.calc_aa_damage(player, utils.last_aa_target, true) * 1.5
    then
        player:castSpell('pos', _Q, utils.last_aa_target.pos)
    end
end

function Samira:FastLaneclear()
    if not self.is_fastclear then return end
end

local semi_e_loop = 0
function Samira:Semi_E()
    if not self.e_ready then return end
    if semi_e_loop > game.time then return end
    if not mymenu.semi_e:get() then return end

    local target = nil
    local min_angle = 90

    if not target then
        local Obj1 = objManager.enemies
        local Obj1_size = objManager.enemies_n
        for i = 0, Obj1_size - 1 do
            local obj = Obj1[i]
            if utils:is_valid(obj) and player.pos:dist(obj.pos) <= self.e_range then
                local angle = utils:calc_angle(obj.pos2D, player.pos2D, game.mousePos2D)
                if angle < min_angle then
                    target = obj
                    min_angle = angle
                end
            end
        end
        if not target then
            local Obj2 = objManager.minions[TEAM_ENEMY]
            local Obj2_size = objManager.minions.size[TEAM_ENEMY]
            for i = 0, Obj2_size - 1 do
                local obj = Obj2[i]
                if utils:is_valid_minion(obj) and player.pos:dist(obj.pos) <= self.e_range then
                    local angle = utils:calc_angle(obj.pos2D, player.pos2D, game.mousePos2D)
                    if angle < min_angle then
                        target = obj
                        min_angle = angle
                    end
                end
            end
            if not target then
                local Obj3 = objManager.minions[TEAM_NEUTRAL]
                local Obj3_size = objManager.minions.size[TEAM_NEUTRAL]
                for i = 0, Obj3_size - 1 do
                    local obj = Obj3[i]
                    if utils:is_valid(obj) and player.pos:dist(obj.pos) <= self.e_range then
                        local angle = utils:calc_angle(obj.pos2D, player.pos2D, game.mousePos2D)
                        if angle < min_angle then
                            target = obj
                            min_angle = angle
                        end
                    end
                end
            end
        end
    end

    if target then
        player:castSpell('pos', _E, target.pos)
        semi_e_loop = game.time + 0.5
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Samira:tick()
    if player.isDead then return end

    self:spell_check()

    self:Automatic()
    self:Combo()
    self:Mixed()
    self:Laneclear()
    self:FastLaneclear()
    self:Semi_E()

    -- print(orb.core.next_attack)
    -- print(orb.core.time_to_next_attack())
    -- print(orb.core.is_winding_up_attack())
end

function Samira:slow_tick()
    if player.isDead then return end

    if player.levelRef < 4 then
        self.p_range = 650
    elseif player.levelRef < 8 then
        self.p_range = 727.5
    elseif player.levelRef < 12 then
        self.p_range = 805
    elseif player.levelRef < 16 then
        self.p_range = 882.5
    else
        self.p_range = 960
    end
end

function Samira:process_spell(spell)
    if not spell or player.isDead then return end

    --print(spell.name)
    if spell.owner and spell.owner == player then
        if spell.name == "SamiraQ" or spell.name == "SamiraQBufferedSword" then
            self.last_spell = "Q"
        elseif spell.name == "SamiraW" then
            self.last_spell = "W"
        elseif spell.name == "SamiraE" then
            self.last_spell = "E"
        elseif spell.name == "SamiraR" then
            self.last_spell = "R"
        end
    end


    -- last_q_t
    -- last_w_t
    -- last_e_t
    -- last_r_t
end

function Samira:finish_spell(spell)
    if not spell or player.isDead then return end
end

function Samira:on_cast_spell(args)
    if not args or player.isDead then return end
    --print( args.spellSlot)
end

function Samira:path(target)
    if not target or player.isDead then return end
end

function Samira:dmg_output()
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
                dmg.q = dmg_lib:Samira_Q(player, enemy)
            end
            if mymenu.dr.w_damage:get() and self.w_ready then
                dmg.w = dmg_lib:Samira_W(player, enemy)
            end
            if mymenu.dr.e_damage:get() and self.e_ready then
                dmg.e = dmg_lib:Samira_E(player, enemy)
            end
            if mymenu.dr.r_damage:get() then
                dmg.r = dmg_lib:Samira_R(player, enemy)
            end

            if mymenu.dr.aa_damage:get() > 0 then
                dmg.aa = damagelib.calc_aa_damage(player, enemy, true) +
                    damagelib.calc_aa_damage(player, enemy, false) * (mymenu.dr.aa_damage:get() - 1)
            end

            utils:draw_hp_bar(enemy, dmg)
        end
    end
end

function Samira:new_draw()
    if player.isDead then return end

    if mymenu.dr.Q:get() and not utils:has_buff(player, "SamiraR") then
        local color = self.q_ready and common.drawdr_menu.clr_q:get() or
            utils:set_alpha(common.drawdr_menu.clr_q:get(), 100)
        utils:draw_circle("q_range", player.pos, self.q_range, color)
    end
    if mymenu.dr.W:get() and not utils:has_buff(player, "SamiraR") then
        local color = self.w_ready and common.drawdr_menu.clr_w:get() or
            utils:set_alpha(common.drawdr_menu.clr_w:get(), 100)
        utils:draw_circle("w_range", player.pos, self.w_range, color)
    end
    if mymenu.dr.E:get() and not utils:has_buff(player, "SamiraR") then
        local color = self.e_ready and common.drawdr_menu.clr_e:get() or
            utils:set_alpha(common.drawdr_menu.clr_e:get(), 100)
        utils:draw_circle("e_range", player.pos, self.e_range, color)
    end
    if mymenu.dr.R:get() and not utils:has_buff(player, "SamiraR") then
        local color = self.r_ready and common.drawdr_menu.clr_r:get() or
            utils:set_alpha(common.drawdr_menu.clr_r:get(), 100)
        utils:draw_circle("r_range", player.pos, self.r_range, color)
    end

    local state_style = utils.menuc.draw_state_menu.state_style:get()
    local text_size = utils.menuc.draw_state_menu.text_size:get()
    local state_color = utils.menuc.draw_state_menu.text_color:get()
    local state_pos = player.pos + vec3(50, 0, -50)
    local p2d = graphics.world_to_screen(state_pos)
    local state_list = {
        { mymenu.sf,     mymenu.dr.sf:get() },
        { mymenu.dive,   mymenu.dr.dive:get() },
        { mymenu.brust,  mymenu.dr.brust:get() },
        { mymenu.auto_q, mymenu.dr.auto_q:get() },
        { mymenu.semi_e, mymenu.dr.semi_e:get() },


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

    Samira:dmg_output()
end

function Samira:init()
    local function after_attack()
        if utils.last_aa_target and utils.last_aa_target.type == TYPE_HERO then
            self.last_spell = "A"
        end
        orb.combat.set_invoke_after_attack(false)
    end
    orb.combat.register_f_after_attack(after_attack)

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

return Samira:init()
