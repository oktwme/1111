---@type utils
local utils = module.load(header.id, "Help/utils")

local my_name = "Nilah"

local dmg_lib = module.load(header.id, "Help/dmg_lib")
local spell_data = module.load(header.id, "Help/spell_database")
local damagelib = module.internal('damagelib')
local orb = module.internal('orb')
local pred = module.internal('pred')
local evade = module.seek('evade')

local spelldb_aa = module.load(header.id, "Help/spell_database_attacks")

local mymenu = nil
if hanbot.language == 2 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name)
    mymenu:header(my_name, "Klee: " .. my_name)

    utils:menu_utils(mymenu)

    mymenu:set("icon", player.iconSquare)

    mymenu:menu("combo_menu", "Combo")
    mymenu:menu("harass_menu", "Harass")
    mymenu:menu("auto_menu", "Automatic")
    mymenu:menu("farm_menu", "Laneclear")
    mymenu:menu("hc", "Hitchance")
    mymenu:menu("flee_menu", "Flee")
    mymenu:menu("draw_menu", "Drawings")

    --#region combo_menu
    mymenu.combo_menu:header("q_header", "Q")
    mymenu.combo_menu:boolean("q", "Use Q", true)

    mymenu.combo_menu:header("e_header", "E")
    mymenu.combo_menu:boolean("combo_e", "Use E", true)
    mymenu.combo_menu:boolean("dash_e", "Follow dash", true)
    mymenu.combo_menu:boolean("safe_e", "Save check", true)
    mymenu.combo_menu.safe_e:set("tooltip", 'Logic setting -> Save Check')
    mymenu.combo_menu:boolean("logic_e", "Logic E", true)
    --mymenu.combo_menu:slider("e_max_enemy", "Max enemies around", 2, 1, 5, 1)

    mymenu.combo_menu:header("r_header", "R")
    mymenu.combo_menu:boolean("r", "Combo R", true)
    --#endregion

    --#region harass_menu
    mymenu.harass_menu:header("q_header", "Q")
    mymenu.harass_menu:slider("q", "Use Q if Mana >= x % ( 100 = Disable )", 0, 0, 100, 1)

    mymenu.harass_menu:header("end_header", "")
    --#endregion

    --#region auto_menu
    mymenu.auto_menu:header("w_header_0", "W save")
    mymenu.auto_menu:slider("save_me", "Save me if hp <= x %", 18, -1, 60, 1)
    mymenu.auto_menu.save_me:set("tooltip", "-1 = disabled")

    mymenu.auto_menu:header("w_header_1", "W dodge")
    mymenu.auto_menu:menu("w_whitelist_aa", "Special attack")
    local enemies = utils:get_enemies()
    for i = 1, #enemies
    do
        local v = enemies[i]
        if v and spelldb_aa[v.charName] and #spelldb_aa[v.charName] > 0
        then
            mymenu.auto_menu.w_whitelist_aa:header("w_header_aa_" .. v.charName:lower(), v.charName)

            local champion_entry = spelldb_aa[v.charName]
            for x = 1, #champion_entry
            do
                local supported_spell = champion_entry[x]
                mymenu.auto_menu.w_whitelist_aa:boolean(supported_spell[2], supported_spell[1], true)
                if supported_spell[3] ~= nil
                then
                    local spell = v:spellSlot(supported_spell[3])
                    if spell
                    then
                        mymenu.auto_menu.w_whitelist_aa[supported_spell[2]]:set('icon', spell.icon)
                    end
                end
            end
        end
    end
    mymenu.auto_menu:menu("w_spell", "Other spell")
    for i = 0, objManager.enemies_n - 1 do
        local champion = objManager.enemies[i]
        local hero_name = champion.charName
        local hero_data = spell_data[hero_name]
        if hero_data then
            for _, spell in ipairs(hero_data) do
                local menu_tab = mymenu.auto_menu.w_spell["w_" .. hero_name]
                if not menu_tab then
                    mymenu.auto_menu.w_spell:menu("w_" .. hero_name, hero_name)
                end
                mymenu.auto_menu.w_spell["w_" .. hero_name]:slider(spell.name,
                    hero_name .. " " .. spell.Spell .. " " .. "  Hp <= x", 0, 0, 100, 1)
            end
        end
    end
    mymenu.auto_menu:header("end_header", "")
    --#endregion

    --#region flee_menu
    mymenu.flee_menu:header("e_header1", "E")
    mymenu.flee_menu:boolean("flee_e", "Use E", true)
    mymenu.flee_menu:boolean("flee_e_heroes", " ^ - Use on heroes", false)
    mymenu.flee_menu:header("end_header", "")
    --#endregion

    --#region farm_menu
    mymenu.farm_menu:header("q_header", "Q")
    mymenu.farm_menu:boolean("lasthit_q", "Lasthit Q", true)
    mymenu.farm_menu:boolean("farm_q", "Laneclear Q", true)
    mymenu.farm_menu:boolean("farm_q_fast", "Fast laneclear Q", true)
    mymenu.farm_menu:boolean("jungle_q", "Jungle Q", true)
    mymenu.farm_menu:header("end_header", "")
    --#endregion

    --#region Hitchance
    mymenu.hc:header("header_q", "Q")
    mymenu.hc:slider("q_range", "Range %", 100, 70, 100, 1)
    mymenu.hc:header("header_5", "")
    --#endregion

    --#region draw_menu
    mymenu.draw_menu:header("draw_ranges_header", "Ranges")
    mymenu.draw_menu:boolean("q_range", "Q range", true)
    mymenu.draw_menu:boolean("e_range", "E range", false)
    mymenu.draw_menu:boolean("r_range", "R range", false)

    mymenu.draw_menu:header("draw_damage_header", "Damage")
    mymenu.draw_menu:boolean("q_damage", "Draw Q", true)
    mymenu.draw_menu:boolean("e_damage", "Draw E", true)
    mymenu.draw_menu:boolean("r_damage", "Draw R", true)
    mymenu.draw_menu:slider("aa_damage", "Draw AA", 1, 0, 5, 1)

    mymenu.draw_menu:header("state", "State")
    mymenu.draw_menu:boolean("sf", "SpellFarm", true)
    mymenu.draw_menu:boolean("dive", "Dive", true)
    mymenu.draw_menu:boolean("semi_e", "Semi E", true)

    mymenu.draw_menu:header("end_header", "")
    --#endregion

    --#region keys
    mymenu:header("kys_header", "Keys")
    mymenu:keybind("sf", "SpellFarm", nil, 'MMB')
    mymenu:keybind("dive", "Dive", nil, 'T')
    mymenu:keybind("semi_e", "Semi E", 'E', nil)
    mymenu:header("end_header", "")
    --#endregion

    utils:menu_common(nil, { 255, 234, 167 }, nil, { 250, 177, 160 }, { 181, 52, 113 })
elseif hanbot.language == 1 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name)
    mymenu:header(my_name, "Klee: " .. my_name)

    utils:menu_utils(mymenu)

    mymenu:set("icon", player.iconSquare)

    mymenu:menu("combo_menu", "连招")
    mymenu:menu("harass_menu", "骚扰")
    mymenu:menu("auto_menu", "自动")
    mymenu:menu("farm_menu", "清线")
    mymenu:menu("hc", "命中率")
    mymenu:menu("flee_menu", "逃跑")
    mymenu:menu("draw_menu", "绘制")

    --#region combo_menu
    mymenu.combo_menu:header("q_header", "Q")
    mymenu.combo_menu:boolean("q", "使用Q", true)

    mymenu.combo_menu:header("e_header", "E")
    mymenu.combo_menu:boolean("combo_e", "使用E", true)
    mymenu.combo_menu:boolean("dash_e", "跟随位移", true)
    mymenu.combo_menu:boolean("safe_e", "安全检查", true)
    mymenu.combo_menu.safe_e:set("tooltip", '逻辑设置 -> 安全检查')
    mymenu.combo_menu:boolean("logic_e", "逻辑E", true)

    mymenu.combo_menu:header("r_header", "R")
    mymenu.combo_menu:boolean("r", "连招R", true)

    mymenu.combo_menu:header("end_header", "")
    --#endregion

    --#region harass_menu
    mymenu.harass_menu:header("q_header", "Q")
    mymenu.harass_menu:slider("q", "使用Q魔力 >= x % ( 100 = 禁止 )", 0, 0, 100, 1)

    mymenu.harass_menu:header("end_header", "")
    --#endregion

    --#region flee_menu
    mymenu.flee_menu:header("e_header1", "E")
    mymenu.flee_menu:boolean("flee_e", "使用E", true)
    mymenu.flee_menu:boolean("flee_e_heroes", " ^ - 用于英雄", false)

    mymenu.flee_menu:header("end_header", "")
    --#endregion

    --#region farm_menu
    mymenu.farm_menu:header("q_header", "Q")
    mymenu.farm_menu:boolean("lasthit_q", "最后一击Q", true)
    mymenu.farm_menu:boolean("farm_q", "清兵Q", true)
    mymenu.farm_menu:boolean("farm_q_fast", "快速清兵Q", true)
    mymenu.farm_menu:boolean("jungle_q", "清野Q", true)

    mymenu.farm_menu:header("end_header", "")
    --#endregion

    --#region Hitchance
    mymenu.hc:header("header_q", "Q")
    mymenu.hc:slider("q_range", "范围%", 100, 70, 100, 1)
    mymenu.hc:header("header_5", "")
    --#endregion

    --#region auto_menu
    mymenu.auto_menu:header("w_header_0", "W save")
    mymenu.auto_menu:slider("save_me", "Save me if hp <= x %", 18, -1, 60, 1)
    mymenu.auto_menu.save_me:set("tooltip", "-1 = disabled")

    mymenu.auto_menu:header("w_header_1", "W躲避")
    mymenu.auto_menu:menu("w_whitelist_aa", "特殊普攻")
    local enemies = utils:get_enemies()
    for i = 1, #enemies
    do
        local v = enemies[i]
        if v and spelldb_aa[v.charName] and #spelldb_aa[v.charName] > 0
        then
            mymenu.auto_menu.w_whitelist_aa:header("w_header_aa_" .. v.charName:lower(), v.charName)

            local champion_entry = spelldb_aa[v.charName]
            for x = 1, #champion_entry
            do
                local supported_spell = champion_entry[x]
                mymenu.auto_menu.w_whitelist_aa:boolean(supported_spell[2], supported_spell[1], true)
                if supported_spell[3] ~= nil
                then
                    local spell = v:spellSlot(supported_spell[3])
                    if spell
                    then
                        mymenu.auto_menu.w_whitelist_aa[supported_spell[2]]:set('icon', spell.icon)
                    end
                end
            end
        end
    end
    mymenu.auto_menu:menu("w_spell", "其他技能")
    for i = 0, objManager.enemies_n - 1 do
        local champion = objManager.enemies[i]
        local hero_name = champion.charName
        local hero_data = spell_data[hero_name]
        if hero_data then
            for _, spell in ipairs(hero_data) do
                local menu_tab = mymenu.auto_menu.w_spell["w_" .. hero_name]
                if not menu_tab then
                    mymenu.auto_menu.w_spell:menu("w_" .. hero_name, hero_name)
                end
                mymenu.auto_menu.w_spell["w_" .. hero_name]:slider(spell.name,
                    hero_name .. " " .. spell.Spell .. " " .. "  Hp <= x", 0, 0, 100, 1)
            end
        end
    end
    mymenu.auto_menu:header("end_header", "")
    --#endregion

    --#region draw_menu
    mymenu.draw_menu:header("draw_ranges_header", "范围")
    mymenu.draw_menu:boolean("q_range", "Q范围", true)
    mymenu.draw_menu:boolean("e_range", "E范围", false)
    mymenu.draw_menu:boolean("r_range", "R范围", false)

    mymenu.draw_menu:header("draw_damage_header", "伤害")
    mymenu.draw_menu:boolean("q_damage", "绘制Q", true)
    mymenu.draw_menu:boolean("e_damage", "绘制E", true)
    mymenu.draw_menu:boolean("r_damage", "绘制R", true)
    mymenu.draw_menu:slider("aa_damage", "绘制普攻", 1, 0, 5, 1)

    mymenu.draw_menu:header("state", "状态")
    mymenu.draw_menu:boolean("sf", "发育", true)
    mymenu.draw_menu:boolean("dive", "越塔", true)
    mymenu.draw_menu:boolean("semi_e", "半手动E", true)

    mymenu.draw_menu:header("end_header", "")
    --#endregion

    --#region keys
    mymenu:header("kys_header", "Keys")
    mymenu:keybind("sf", "SpellFarm", nil, 'MMB')
    mymenu:keybind("dive", "Dive", nil, 'T')
    mymenu:keybind("semi_e", "Semi E", 'E', nil)
    mymenu:header("end_header", "")
    --#endregion

    utils:menu_common(nil, { 255, 234, 167 }, nil, { 250, 177, 160 }, { 181, 52, 113 })
end


local Nilah =
{
    q_pred = function(q_range)
        return {
            delay = 0.35,
            speed = math.huge,
            width = 150,
            range = q_range,
            boundingRadiusMod = 1,

            collision = {
                wall = false,
            },
        }
    end
}

Nilah.evade_queue = {}

function Nilah:on_process_spell_cast(spell)
    if not spell or not spell.owner or spell.owner.team == player.team
    then
        return
    end

    local spell_name = spell.name
    if not mymenu.auto_menu.w_whitelist_aa[spell_name]
    then
        return
    end

    if not spell.target or spell.target.networkID ~= player.networkID
    then
        return
    end

    local delay = spell.clientWindUpTime or 0
    if delay > 0
    then
        delay = delay - network.latency / 2 - 0.1
    end

    table.insert(Nilah.evade_queue, {
        menu = mymenu.auto_menu.w_whitelist_aa[spell_name],
        t_hit = game.time + delay
    })
end

function Nilah:update_states()
    self.is_combo = orb.menu.combat.key:get()
    self.is_mixed = orb.menu.hybrid.key:get()
    self.is_laneclear = orb.menu.lane_clear.key:get() and mymenu.sf:get()
    self.is_fastclear = self.is_laneclear and orb.menu.lane_clear.panic_key:get()
    self.is_lasthit = self.is_laneclear or orb.menu.last_hit.key:get()
    self.is_flee = orb.menu.flee.key:get()

    self.is_under_turret = utils:in_enemy_turret(player.pos)

    --q
    self.q_range = 600 * mymenu.hc.q_range:get() / 100
    self.q_range_farm = 575
    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0

    --w
    self.w_level = player:spellSlot(1).level
    self.w_ready = self.w_level > 0 and player:spellSlot(1).state == 0

    --e
    self.e_range = 550
    self.e_level = player:spellSlot(2).level
    self.e_ready = self.e_level > 0 and player:spellSlot(2).state == 0

    --r
    self.r_range = 450
    self.r_level = player:spellSlot(3).level
    self.r_ready = self.r_level > 0 and player:spellSlot(3).state == 0
end

function Nilah:logic_q()
    if not self.q_ready then return end
    if not orb.core.can_action() or utils:in_attack() then return end

    --#region enemy_q
    if (self.is_combo and mymenu.combo_menu.q:get())
        or
        (self.is_mixed and mymenu.harass.q:get() <= utils:get_mana_pre(player) and not self.is_under_turret)
    then
        local target = utils:get_target(self.q_range, "AD")

        if target and (not utils:in_aa_range(target) or utils:should_reset_aa(0))
        then
            local pred_result = pred.linear.get_prediction(self.q_pred(self.q_range), target)
            local target_path = utils:check_2Dpath(target, 0.35)
            local target_path_check = target_path:dist(player.pos2D) < 600
            if pred_result and target_path_check
            then
                player:castSpell('pos', 0, vec3(pred_result.endPos.x, target.pos.y, pred_result.endPos.y))
                return
            end
        end
    end
    --#endregion

    if not mymenu.sf:get() then return end

    --#region lasthit_q
    if (self.is_lasthit and (mymenu.farm_menu.lasthit_q:get()))
        or
        (self.is_laneclear and (mymenu.farm_menu.farm_q:get()))
        or
        (self.is_fastclear and mymenu.farm_menu.farm_q_fast:get())
    then
        local lasthit_minions = utils:get_list("farm")
        if #lasthit_minions > 0
        then
            utils:remove_if(lasthit_minions, function(obj)
                return not obj.isLaneMinion or
                    obj.pos:dist(player.pos) > self.q_range_farm
                    or
                    obj.health - damagelib.get_spell_damage('NilahQ', 0, player, obj, false, 0) > 0
                    or
                    utils:is_minion_lasthitted(obj.networkID)
            end)

            if #lasthit_minions > 0
            then
                table.sort(lasthit_minions, function(v1, v2)
                    return v1.health < v2.health
                end)

                local pred_result = pred.linear.get_prediction(self.q_pred(self.q_range_farm),
                    lasthit_minions[1])
                if pred_result
                then
                    player:castSpell('pos', 0, vec3(pred_result.endPos.x, lasthit_minions[1].pos.y, pred_result.endPos.y))
                    return
                end
            end
        end
    end
    --#endregion

    --#region farm_q
    if (self.is_laneclear and mymenu.farm_menu.farm_q:get()) or (self.is_fastclear and mymenu.farm_menu.farm_q_fast:get())
    then
        local lc_pos = utils:get_best_lc_pos("line", self.q_pred(self.q_range_farm), 2, false, 0)
        if lc_pos and lc_pos:len() > 0
        then
            player:castSpell('pos', 0, lc_pos)
            return
        end
    end
    --#endregion

    --#region jungle_q
    if (self.is_laneclear and mymenu.farm_menu.jungle_q:get())
    then
        local lc_pos = utils:get_best_lc_pos("line", self.q_pred(self.q_range_farm), 1, true, 0)
        if lc_pos and lc_pos:len() > 0 and not player.activeSpell and utils.last_aa_target and not utils.last_aa_target.isLaneMinion
        then
            player:castSpell('pos', 0, lc_pos)
            return
        end
    end
    --#endregion
end

local w_loop = 0
function Nilah:w_dodge()
    if w_loop > game.time then return end

    if evade then
        for i = evade.core.skillshots.n, 1, -1 do
            local spell = evade.core.skillshots[i]
            if not spell or not spell.name then return end

            if spell:contains(player) then
                local menu0 = mymenu.auto_menu.w_spell["w_" .. spell.owner.charName]
                if not menu0 then return end

                --spell:get_hit_time(pos2D)
                local menu = mymenu.auto_menu.w_spell["w_" .. spell.owner.charName][spell.name]
                if not menu then return end

                if menu:get() < utils:get_real_hp_pre(player) then return end
                local hit_t = spell:get_hit_time(player.pos2D) - game.time

                if hit_t > 0 and 0.2 + network.latency > hit_t then
                    player:castSpell('self', 1)
                    w_loop = game.time + 1
                end
            end
        end
        for i = evade.core.targeted.n, 1, -1 do
            local spell = evade.core.targeted[i]
            if not spell or not spell.name or not spell.missile or not spell.target then return end

            if spell.target == player and spell.missile.pos:dist(player.pos) < 250 then
                local menu0 = mymenu.auto_menu.w_spell["w_" .. spell.owner.charName]
                if not menu0 then return end

                local menu = mymenu.auto_menu.w_spell["w_" .. spell.owner.charName][spell.name]
                if not menu then return end

                if menu:get() >= utils:get_real_hp_pre(player) then
                    player:castSpell('pos', 1, spell.missile.pos)
                    w_loop = game.time + 1
                end
            end
        end
    end
end

function Nilah:logic_w()
    if not self.w_ready then return end

    Nilah:w_dodge()
    --#region special_attacks
    if #Nilah.evade_queue > 0
    then
        utils:remove_if(Nilah.evade_queue, function(e)
            return e.t_hit > game.time + 0.2
        end)

        if #Nilah.evade_queue > 0
        then
            table.sort(Nilah.evade_queue, function(e1, e2)
                return e1.t_hit < e2.t_hit
            end)

            if Nilah.evade_queue[1].t_hit >= game.time
            then
                player:castSpell('self', 1)
                return
            end
        end
    end
    --#endregion

    --#region self
    if mymenu.auto_menu.save_me:get() ~= -1
    then
        local pred_health, incoming_damage = utils:get_health_prediction(player, true, true, false)
        local health_pred_p = pred_health / player.maxHealth * 100

        if health_pred_p <= mymenu.auto_menu.save_me:get() and incoming_damage > 0
        then
            player:castSpell('self', 1)
            return
        end
    end
    --#endregion

    --#region allies
    -- if mymenu.auto_menu.save_ally:get() ~= -1
    -- then
    --     local allies = utils:get_allies(true)
    --     if #allies > 0
    --     then
    --         local save_ally = utils:find_if(allies, function(v)
    --             if not v or v.isDead or v.pos:dist(player.pos) > v.boundingRadius + player.boundingRadius
    --             then
    --                 return false
    --             end

    --             if not mymenu.auto_menu.w_whitelist_ally["wl_" .. v.charName:lower()] or not mymenu.auto_menu.w_whitelist_ally["wl_" .. v.charName:lower()]:get()
    --             then
    --                 return false
    --             end

    --             local pred_health, incoming_damage = utils:get_health_prediction(v, true, true, false)
    --             local health_pred_p = pred_health / v.maxHealth * 100

    --             return health_pred_p <= mymenu.auto_menu.save_ally:get() and incoming_damage > 0
    --         end)

    --         if save_ally
    --         then
    --             player:castSpell('self', 1)
    --             return
    --         end
    --     end
    -- end
    --#endregion
end

function Nilah:can_kill(target)
    local damage = 0.0

    if (self.q_ready)
    then
        damage = damage + damagelib.get_spell_damage('NilahQ', 0, player, target, false, 0)
    end

    if (self.e_ready)
    then
        damage = damage + damagelib.get_spell_damage('NilahE', 2, player, target, false, 0)
    end

    if (self.r_ready)
    then
        damage = damage + damagelib.get_spell_damage('NilahR', 3, player, target, false, 0)
    end

    damage = damage + damagelib.calc_aa_damage(player, target, true) * 2

    return utils:get_real_hp(target, true, true, false) - damage < 0
end

function Nilah:get_e_position(target)
    for i = 550, 100, -10
    do
        local v1 = utils:extend_vec(player.pos, target.pos, i)
        if (not navmesh.isWall(v1) and not navmesh.isStructure(v1))
        then
            return v1
        end
    end

    return nil
end

function Nilah:logic_e()
    if not self.e_ready then return end
    if not orb.core.can_action() or utils:in_attack() then return end

    local target = utils:get_target(self.e_range, "AD")

    --#region enemy_e
    if (self.is_combo and mymenu.combo_menu.combo_e:get()) --or (self.is_mixed and mymenu.harass_menu.harass_e:get())
    then
        if target and (not utils:in_aa_range(target) or utils:should_reset_aa(0))
        then
            local e_pos = self:get_e_position(target)
            if e_pos
            then
                local is_safe = utils:save_check(player.pos, mymenu) or not mymenu.combo_menu.safe_e:get()
                -- local is_safe = not mymenu.combo_menu.safe_e:get() or
                --     ((mymenu.combo_menu.e_max_enemy:get() == 5 or e_pos:countEnemies(600) <= mymenu.combo_menu.e_max_enemy:get()) and player.health / player.maxHealth >= 0.33)
                if utils:in_enemy_turret(e_pos) and not mymenu.dive:get()
                then
                    is_safe = false
                end

                if evade and not evade.core.is_action_safe(e_pos, 2200, network.latency)
                then
                    is_safe = false
                end
                local can_kill = (self:can_kill(target) and not utils:in_aa_range(player, target))
                    or
                    not mymenu.combo_menu.logic_e:get()
                local follow_dash = mymenu.combo_menu.dash_e:get() and target.path and target.path.isDashing
                if (follow_dash or can_kill) and is_safe
                then
                    player:castSpell('obj', 2, target)
                    return
                end
            end
        end
    end
    --#endregion

    --#region semi_e
    if mymenu.semi_e:get()
    then
        if target
        then
            local e_pos = self:get_e_position(target)
            if e_pos
            then
                local is_safe = true
                if evade and not evade.core.is_action_safe(e_pos, 2200, network.latency / 2 + 1 / 30)
                then
                    is_safe = false
                end
                if is_safe
                then
                    player:castSpell('obj', 2, target)
                    return
                end
            end
        end
    end
    --#endregion

    --#region flee_e
    if self.is_flee and mymenu.flee_menu.flee_e:get()
    then
        --utils:calc_angle(obj.pos2D, player.pos2D, game.mousePos2D)
        local minions = utils:get_list("farm")
        if mymenu.flee_menu.flee_e_heroes:get()
        then
            local enemies = utils:get_enemies()
            for i = 1, #enemies do table.insert(minions, enemies[i]) end
        end

        local jungle_minions = utils:get_list(TEAM_NEUTRAL)
        for i = 1, #jungle_minions do table.insert(minions, jungle_minions[i]) end

        if #minions > 0
        then
            utils:remove_if(minions, function(v)
                if not utils:is_valid(v) or v.pos:dist(player.pos) > self.e_range
                then
                    return true
                end

                if utils:calc_angle(v.pos2D, player.pos2D, game.mousePos2D) > 33
                then
                    return true
                end

                local e_pos = self:get_e_position(v)
                if not e_pos
                then
                    return true
                end

                if utils:in_enemy_turret(e_pos)
                then
                    return true
                end

                if evade and not evade.core.is_action_safe(e_pos, 2200, network.latency / 2 + 1 / 30)
                then
                    return true
                end

                return false
            end)

            if #minions > 0
            then
                table.sort(minions, function(v1, v2)
                    return utils:calc_angle(v1.pos2D, player.pos2D, game.mousePos2D) <
                        utils:calc_angle(v2.pos2D, player.pos2D, game.mousePos2D)
                end)

                player:castSpell('obj', 2, minions[1])
            end
        end
    end
    --#endregion
end

function Nilah:logic_r()
    if not self.r_ready then return end
    if not orb.core.can_action() or utils:in_attack() then return end

    local target = utils:get_target(self.r_range, "AD")

    if self.is_combo and mymenu.combo_menu.r:get()
    then
        if target and utils:is_valid(target)
        then
            local pred = pred.core.get_pos_after_time(target, 0.2)
            if pred and pred:dist(player.pos) <= self.r_range - 20 and self:can_kill(target) and
                (utils:get_real_hp(target, true, true, false) - damagelib.calc_aa_damage(player, target, true) * 3 > 0 or (player.pos:countEnemies(self.r_range) > 1))
            then
                player:castSpell('self', 3)
                return
            end
        end
    end
end

function Nilah:on_tick()
    if not player or player.isDead
    then
        Nilah.evade_queue = {}
        return
    end

    self:update_states()

    --
    --  Logic
    --
    self:logic_w()
    self:logic_q()
    self:logic_e()
    self:logic_r()
end

--#region draw
function Nilah:draw_damage()
    if not mymenu.draw_menu.q_damage:get()
        and
        not mymenu.draw_menu.e_damage:get()
        and
        not mymenu.draw_menu.r_damage:get()
        and
        mymenu.draw_menu.aa_damage:get() == 0
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
            local dmg =
            {
                passive = 0,
                aa = mymenu.draw_menu.aa_damage:get() > 0 and
                    (damagelib.calc_aa_damage(player, enemy, false) * mymenu.draw_menu.aa_damage:get()) or 0,
                q = (mymenu.draw_menu.q_damage:get() and self.q_ready) and
                    damagelib.get_spell_damage('NilahQ', 0, player, enemy, false, 0) or 0,
                w = 0,
                e = (mymenu.draw_menu.e_damage:get() and self.e_ready) and
                    damagelib.get_spell_damage('NilahE', 2, player, enemy, false, 0) or 0,
                r = (mymenu.draw_menu.r_damage:get() and self.r_ready) and
                    damagelib.get_spell_damage('NilahR', 3, player, enemy, false, 0) or 0,
            }

            utils:draw_hp_bar(enemy, dmg)
        end
    end
end

function Nilah:on_draw()
    if not player or player.isDead then return end

    if keyboard.isKeyDown(0x09) then return end

    if mymenu.draw_menu.q_range:get() and self.q_range and self.q_level > 0
    then
        utils:draw_circle("q_range", player.pos, self.q_range, utils.menuc.drawdr_menu.clr_q:get(), nil,
            self.q_ready and 255 or 50)
    end

    if mymenu.draw_menu.e_range:get() and self.e_range and self.e_level > 0
    then
        utils:draw_circle("e_range", player.pos, self.e_range, utils.menuc.drawdr_menu.clr_e:get(), nil,
            self.e_ready and 255 or 50)
    end

    if mymenu.draw_menu.r_range:get() and self.r_range and self.r_level > 0
    then
        utils:draw_circle("r_range", player.pos, self.r_range, utils.menuc.drawdr_menu.clr_r:get(), nil,
            self.r_ready and 255 or 50)
    end

    local state_style = utils.menuc.draw_state_menu.state_style:get()
    local text_size = utils.menuc.draw_state_menu.text_size:get()
    local state_color = utils.menuc.draw_state_menu.text_color:get()
    local state_pos = player.pos + vec3(50, 0, -50)
    local p2d = graphics.world_to_screen(state_pos)
    local state_list = {
        { mymenu.sf,     mymenu.draw_menu.sf:get() },
        { mymenu.dive,   mymenu.draw_menu.dive:get() },
        { mymenu.semi_e, mymenu.draw_menu.semi_e:get() },
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

local function nilah_on_tick()
    Nilah:on_tick()
end

local function nilah_on_draw()
    Nilah:on_draw()
end

local function nilah_on_process_spell(spell)
    Nilah:on_process_spell_cast(spell)
end

function Nilah:bind_callbacks(b_remove)
    if not b_remove
    then
        if self.b_callbacks_registered
        then
            return
        end

        cb.add(cb.tick, nilah_on_tick)
        cb.add(cb.draw, nilah_on_draw)
        cb.add(cb.spell, nilah_on_process_spell)

        self.b_callbacks_registered = true
    elseif b_remove and b_remove == true
    then
        cb.remove(cb.tick, nilah_on_tick)
        cb.remove(cb.draw, nilah_on_draw)
        cb.remove(cb.spell, nilah_on_process_spell)

        self.b_callbacks_registered = false
    end
end

function Nilah:init(b_callbacks)
    if b_callbacks
    then
        self:bind_callbacks()
    end
end

return Nilah:init(true)
