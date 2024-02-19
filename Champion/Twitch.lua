--[[
    Twitch cast w on Yasuo's W?
    ping always >
]]
local Twitch = {}

---@type utils
local utils = module.load(header.id, "Help/utils")
local dmg_lib = module.load(header.id, "Help/dmg_lib")
local my_name = player.charName

local orb = module.internal('orb')
local pred = module.internal('pred')
local damagelib = module.internal('damagelib')
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
    mymenu.combo:header("header_w", "W")
    mymenu.combo:boolean("w", "Use W", true)
    mymenu.combo:boolean("w_disable_q", " ^- Don't use W during Q", true)
    mymenu.combo:slider("w_disable_r", " ^- Use W during R if as <= x/100", 130, 100, 300, 1)
    mymenu.combo:slider("w_qaw", " ^- Use Q -> AA -> W if as <= x/100", 200, 100, 300, 1)
    mymenu.combo:slider("w_as_block", " ^- Other if as <= x/100", 150, 100, 300, 1)

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "Use E", true)

    mymenu.combo:header("header_4", "R")
    mymenu.combo:boolean("r_aoe", "AOE", true)

    local elements_w = { mymenu.combo.w_disable_q, mymenu.combo.w_disable_r, mymenu.combo.w_qaw, mymenu.combo.w_as_block }
    utils:set_visible(elements_w, mymenu.combo.w:get())
    mymenu.combo.w:set('callback', function(old, new) utils:hide_menu(elements_w, true, old, new) end)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "Harass")
    -- #region harass
    mymenu.harass:header("header_2", "W")
    mymenu.harass:slider("w", "Use W if Mana >= x % ( 100 = Disable )", 30, 0, 100, 1)
    mymenu.harass:header("header_3", "E")
    mymenu.harass:slider("e", "X stack", 6, 0, 7, 1)
    mymenu.harass:boolean("e_steal", "E steal monster", true)

    mymenu.harass:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "Automatic")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "Auto Q after kill and have enemy", true)
    mymenu.auto:boolean("q_r", "Auto Q if R (get attack speed buff)", true)
    -- #endregion

    mymenu:menu("lc", "Laneclear")
    -- #region laneclear
    mymenu.lc:header("header_1", "Laneclear")
    mymenu.lc:boolean("e_lc", "Laneclear E", true)
    mymenu.lc:header("header_2", "Jungle clear")
    mymenu.lc:boolean("e_jg", "Jungle E", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("dr", "Drawings")
    -- #region Drawings
    mymenu.dr:header("range", "Range")
    mymenu.dr:boolean("Q", "Draw Q", true)
    mymenu.dr:boolean("W", "Draw W", false)
    mymenu.dr:boolean("E", "Draw E", true)
    mymenu.dr:boolean("R", "Draw R", false)

    mymenu.dr:header("damage", "Damage")
    mymenu.dr:boolean("e_damage", "Draw E", true)
    mymenu.dr:boolean("e_damage_monster", " ^- Include monster", true)
    --mymenu.dr:boolean("e_damage_minion", " ^- Include minion", true)
    mymenu.dr:slider("aa_damage", "Draw AA", 0, 0, 5, 1)

    mymenu.dr:header("state", "State")
    mymenu.dr:boolean("sf", "SpellFarm", true)
    mymenu.dr:boolean("semi_w", "Semi W", true)
    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "Key")
    mymenu:keybind("sf", "SpellFarm", nil, 'MMB')
    mymenu:keybind("semi_w", "Semi W", 'T', nil)
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
    mymenu.combo:header("header_w", "W")
    mymenu.combo:boolean("w", "使用W", true)
    mymenu.combo:boolean("w_disable_q", " ^- 隐身(Q)时不用W", true)
    mymenu.combo:slider("w_disable_r", " ^- 有R时史用 W 当攻速 <= x/100", 130, 100, 300, 1)
    mymenu.combo:slider("w_qaw", " ^- 使用 Q -> 普攻 -> W 当攻速 <= x/100", 200, 100, 300, 1)
    mymenu.combo:slider("w_as_block", " ^- 其他当攻速 <= x/100", 150, 100, 300, 1)

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "使用E", true)

    mymenu.combo:header("header_4", "R")
    mymenu.combo:boolean("r_aoe", "AOE", true)

    local elements_w = { mymenu.combo.w_disable_q, mymenu.combo.w_disable_r, mymenu.combo.w_qaw, mymenu.combo.w_as_block }
    utils:set_visible(elements_w, mymenu.combo.w:get())
    mymenu.combo.w:set('callback', function(old, new) utils:hide_menu(elements_w, true, old, new) end)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "骚扰")
    -- #region harass
    mymenu.harass:header("header_2", "W")
    mymenu.harass:slider("w", "使用W魔力 >= x % ( 100 = 禁止 )", 30, 0, 100, 1)
    mymenu.harass:header("header_3", "E")
    mymenu.harass:slider("e", "X层", 6, 0, 7, 1)
    mymenu.harass:boolean("e_steal", "E抢野怪", true)

    mymenu.harass:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "自动")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "击杀后自动Q(敌人在附近时)", true)
    mymenu.auto:boolean("q_r", "R时自动Q (获取攻速)", true)
    -- #endregion

    mymenu:menu("lc", "清线")
    -- #region laneclear
    mymenu.lc:header("header_1", "清兵")
    mymenu.lc:boolean("e_lc", "清兵E", true)
    mymenu.lc:header("header_2", "清野")
    mymenu.lc:boolean("e_jg", "清野E", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("dr", "绘制")
    -- #region Drawings
    mymenu.dr:header("range", "范围")
    mymenu.dr:boolean("Q", "绘制Q", true)
    mymenu.dr:boolean("W", "绘制W", false)
    mymenu.dr:boolean("E", "绘制E", true)
    mymenu.dr:boolean("R", "绘制R", false)

    mymenu.dr:header("damage", "伤害")
    mymenu.dr:boolean("e_damage", "绘制E", true)
    mymenu.dr:boolean("e_damage_monster", " ^- 包含野怪", true)
    --mymenu.dr:boolean("e_damage_minion", " ^- Include minion", true)
    mymenu.dr:slider("aa_damage", "绘制普攻", 0, 0, 5, 1)

    mymenu.dr:header("state", "状态")
    mymenu.dr:boolean("sf", "发育", true)
    mymenu.dr:boolean("semi_w", "半手动W", true)
    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "快捷键")
    mymenu:keybind("sf", "发育", nil, 'MMB')
    mymenu:keybind("semi_w", "半手动W", 'T', nil)
    mymenu:header("header_end", "")
end
local common = utils:menu_common()


function Twitch:load()
    self.is_combo = false
    self.is_mixed = false
    self.is_laneclear = false
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
        speed = 1400,
        radius = 300,
        boundingRadiusMod = 0,
        range = 950,
        collision = {
            minion = false,
            wall = true,
            hero = false,
        },
    }

    self.last_e_t = 0
    self.e_range = 0
    self.e_ready = false
    self.e_level = 0
    self.e_pred = {
        delay = 0.25,
        speed = 3000,
        width = 70,
        boundingRadiusMod = 1,
        range = 1200,
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
        delay = 0.25,
        speed = 5000,
        width = 60,
        boundingRadiusMod = 1,
        range = 1100,
        collision = {
            minion = false,
            wall = true,
            hero = true,
        },
    }

    self.q_aa_t = 0
end

function Twitch:spell_check()
    self.is_combo = orb.menu.combat.key:get()
    self.is_mixed = orb.menu.hybrid.key:get()
    self.is_laneclear = orb.menu.lane_clear.key:get() and mymenu.sf:get()
    self.is_lasthit = self.is_laneclear or orb.menu.last_hit.key:get()

    self.q_range = utils:has_buff(player, "twitchhideinshadows") and
        (player.buff["twitchhideinshadows"].endTime - game.time) * player.moveSpeed or
        player.moveSpeed * (9 + self.q_level)
    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0

    self.w_range = 950
    self.w_level = player:spellSlot(1).level
    self.w_ready = self.w_level > 0 and player:spellSlot(1).state == 0

    self.e_range = 1200
    self.e_level = player:spellSlot(2).level
    self.e_ready = self.e_level > 0 and player:spellSlot(2).state == 0

    self.r_range = player.attackRange + player.boundingRadius
    self.r_level = player:spellSlot(3).level
    self.r_ready = self.r_level > 0 and player:spellSlot(3).state == 0
    self.r_pred.delay = player:attackCastDelay(64)

    if utils:has_buff(player, "twitchhideinshadows") then
        self.q_aa_t = game.time + player:attackCastDelay(64) + 0.06
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Twitch:E_stack(target)
    local buff = utils:get_buff_count2(target, "twitchdeadlyvenom") --TwitchDeadlyVenom
    return buff
end

-- ///////////////////////////////////////////////////////////////////////////////////////////
local auto_q_loop = 0
function Twitch:Automatic()
    if auto_q_loop > game.time then return end
    if mymenu.auto.q_r:get() and self.q_ready and utils:has_buff(player, "TwitchFullAutomatic") and not utils:has_buff(player, "twitchhideinshadowsbuff") then
        player:castSpell('self', 0)
        auto_q_loop = game.time + 1
    end
end

local w_loop = 0
function Twitch:W_logic()
    if not self.w_ready then return end
    if w_loop > game.time then return end

    local target = utils:get_target(self.w_range, "AD")
    if utils:is_valid(utils.orb_t) and utils.orb_t.type == TYPE_HERO then
        target = utils.orb_t
    end

    if not target then return end

    local use_w_after_aa = utils.after_aa_t >= game.time
    local use_w_mana = player.mana - player.manaCost2 - player.manaCost1 > 0
    local block_w_1 = utils:has_buff(player, "twitchhideinshadows") and mymenu.combo.w_disable_q:get()
    local block_w_2 = utils:has_buff(player, "twitchfullautomatic") and
        mymenu.combo.w_disable_r:get() / 100 < dmg_lib:as(player)
    local block_w_3 = self.q_aa_t > game.time and mymenu.combo.w_qaw:get() / 100 < dmg_lib:as(player)
    local block_w_4 = not utils:has_buff(player, "twitchfullautomatic") and self.q_aa_t < game.time and
        mymenu.combo.w_as_block:get() / 100 < dmg_lib:as()

    local b_block_w = block_w_1 or block_w_2 or block_w_3 or block_w_4
    local combo_w = self.is_combo and mymenu.combo.w:get() and use_w_after_aa and use_w_mana and not b_block_w
    local mixed_w = self.is_mixed and use_w_after_aa and use_w_mana and
        utils:get_mana_pre(player) >= mymenu.harass.w:get() and not utils:in_enemy_turret(player.pos)

    if combo_w or mixed_w or mymenu.semi_w:get() then
        local seg = pred.circular.get_prediction(self.w_pred, target)
        if seg then
            local path = utils:check_2Dpath(target, 0.2)
            local cast_pos = path:to3D(target.y)
            player:castSpell('pos', 1, cast_pos)
            w_loop = game.time + 1

            -- local col = pred.collision.get_prediction(self.w_pred, seg, target)
            -- if not col then
            --     local path = utils:check_2Dpath(target, 0.15)
            --     local cast_pos = path:to3D(target.y)
            --     player:castSpell('pos', 1, cast_pos)
            --     w_loop = game.time + 1
            -- end
        end
    end
end

local e_loop = 0
function Twitch:E_logic()
    if not self.e_ready then return end
    if e_loop > game.time then return end

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        local is_valid = utils:is_valid(obj) and player.pos:dist(obj.pos) <= self.e_range
        --local good_time = (utils:in_aa_range(player, obj) and utils.after_aa_t > game.time) or not player.activeSpell
        if is_valid and -- and good_time
            utils:ignore_spell(obj) == false and not utils:has_buff(obj, "SamiraW")
        then
            local seg = pred.linear.get_prediction(self.e_pred, obj)
            if seg then
                local col = pred.collision.get_prediction(self.e_pred, seg, obj)
                if not col then
                    local can_kill = utils:get_real_hp(obj, true, true, true) <
                        dmg_lib:Twitch_E(player, obj, Twitch:E_stack(obj))
                    local mix_e = self.is_mixed and mymenu.harass.e:get() <= Twitch:E_stack(obj)
                    if can_kill or mix_e then --
                        player:castSpell('self', 2)
                        -- chat.print("target hp: " .. obj.health .. " real hp: " .. utils:get_real_hp(obj, true, true, true))
                        -- chat.print("E dmg: " .. dmg_lib:Twitch_E(player, obj, Twitch:E_stack(obj)))
                        e_loop = game.time + 1
                        break
                    end
                end
            end
        end
    end

    local last_aa_t = utils.last_aa_target
    if last_aa_t then
        local after_aa = utils.after_aa_t > game.time
        local is_hero = last_aa_t.type == TYPE_HERO and last_aa_t.team == TEAM_ENEMY
        local aa_t_hp = utils:get_real_hp(last_aa_t, true, true, true)
        local stack = Twitch:E_stack(last_aa_t) == 6 and 6 or Twitch:E_stack(last_aa_t) + 1

        local can_kill = is_hero and after_aa and
            aa_t_hp < dmg_lib:Twitch_E(player, last_aa_t, stack) + damagelib.calc_aa_damage(player, last_aa_t, false)

        local mix_e = self.is_mixed and is_hero
            and
            (mymenu.harass.e:get() <= Twitch:E_stack(last_aa_t)
                or
                mymenu.harass.e:get() <= Twitch:E_stack(last_aa_t) + 1 and after_aa)

        local steal_monster =
            (self.is_mixed and mymenu.harass.e_steal:get() or self.is_laneclear and mymenu.lc.e_jg:get() and mymenu.sf:get())
            and
            last_aa_t.isSmiteMonster
            and
            (last_aa_t.health < dmg_lib:Twitch_E(player, last_aa_t, Twitch:E_stack(last_aa_t))
                or
                after_aa and last_aa_t.health < dmg_lib:Twitch_E(player, last_aa_t, stack) + damagelib.calc_aa_damage(player, last_aa_t, false))

        if mix_e or can_kill or steal_monster then
            player:castSpell('self', 2)
            e_loop = game.time + 1
        end
    end

    local count = 0
    if self.is_laneclear and mymenu.lc.e_lc:get() and mymenu.sf:get() then
        local Obj = objManager.minions["farm"]
        local Obj_size = objManager.minions.size["farm"]
        for i = 0, Obj_size - 1 do
            local obj = Obj[i]
            if utils:is_valid(obj) and player.pos:dist(obj.pos) <= self.e_range then
                local can_kill = utils:get_real_hp(obj, true, true, true) <
                    dmg_lib:Twitch_E(player, obj, Twitch:E_stack(obj))
                if can_kill then
                    count = count + 1
                end
            end
        end
    end
    if count >= 3 then
        player:castSpell('self', 2)
        e_loop = game.time + 1
    end
end

function Twitch:R_logic()
    if not mymenu.combo.r_aoe then return end
    if not self.is_combo then return end
    if not utils:has_buff(player, "TwitchFullAutomatic") then return end
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    local max = 0
    local target = nil
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if utils:is_valid(obj) and utils:in_aa_range(player, obj)
            and
            utils:ignore_aa(obj) == false
        then
            local seg = pred.linear.get_prediction(self.r_pred, obj)
            if seg then
                local col = pred.collision.get_prediction(self.r_pred, seg, obj)
                if col and #col > max then
                    max = #col
                    target = obj
                end
            end
        end
    end
    if target then
        orb.combat.target = target
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Twitch:tick()
    if player.isDead then return end

    self:spell_check()

    self:Automatic()
    self:E_logic()
    self:W_logic()
    -- print(orb.core.next_attack)
    -- print(orb.core.time_to_next_attack())
    -- print(orb.core.is_winding_up_attack())
end

function Twitch:slow_tick()
    if player.isDead then return end

    if mymenu.auto.q_ks:get() and self.q_ready then
        local dead_enemy = utils:check_die()
        if dead_enemy and dead_enemy.pos:dist(player.pos) < 800 and utils:count_enemy_hero(player.pos, 1000) > 0 then
            player:castSpell('self', 0)
        end
    end
end

function Twitch:process_spell(spell)
    if not spell or player.isDead then return end

    --print(spell.name)


    -- last_q_t
    -- last_w_t
    -- last_e_t
    -- last_r_t
end

function Twitch:finish_spell(spell)
    if not spell or player.isDead then return end
end

function Twitch:on_cast_spell(args)
    if not args or player.isDead then return end
    --print( args.spellSlot)
end

function Twitch:path(target)
    if not target or player.isDead then return end
end

function Twitch:dmg_output()
    if not mymenu.dr.e_damage:get()
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

            if mymenu.dr.e_damage:get() and self.e_ready then
                dmg.e = dmg_lib:Twitch_E(player, enemy, Twitch:E_stack(enemy))
            end

            if mymenu.dr.aa_damage:get() > 0 then
                dmg.aa = damagelib.calc_aa_damage(player, enemy, true) +
                    damagelib.calc_aa_damage(player, enemy, false) * (mymenu.dr.aa_damage:get() - 1)
            end

            utils:draw_hp_bar(enemy, dmg)
        end
    end

    if self.e_ready then
        if mymenu.dr.e_damage_monster:get() then
            local Obj = objManager.minions[TEAM_NEUTRAL]
            local Obj_size = objManager.minions.size[TEAM_NEUTRAL]
            for i = 0, Obj_size - 1 do
                local enemy = Obj[i]
                if utils:is_valid(enemy) and enemy.pos:dist(player.pos) < self.e_range and enemy.isVisible and enemy.isOnScreen then
                    local dmg = { passive = 0, aa = 0, q = 0, w = 0, e = 0, r = 0 }

                    dmg.e = dmg_lib:Twitch_E(player, enemy, Twitch:E_stack(enemy))

                    utils:draw_hp_bar(enemy, dmg)
                end
            end
        end
        -- if mymenu.dr.e_damage_minion:get() then
        --     local Obj = objManager.minions["farm"]
        --     local Obj_size = objManager.minions.size["farm"]
        --     for i = 0, Obj_size - 1 do
        --         local enemy = Obj[i]
        --         if utils:is_valid(enemy) and enemy.pos:dist(player.pos) < self.e_range and enemy.isVisible and enemy.isOnScreen then
        --             local dmg = { passive = 0, aa = 0, q = 0, w = 0, e = 0, r = 0 }

        --             dmg.e = dmg_lib:Twitch_E(player, enemy, Twitch:E_stack(enemy))

        --             utils:draw_hp_bar(enemy, dmg)
        --         end
        --     end
        -- end
    end
end

local q_hide_range_loop = true
local q_hide_range = graphics.create_effect(graphics.CIRCLE_FILL)
function Twitch:new_draw()
    if player.isDead then return end

    if keyboard.isKeyDown(0x09) then
        q_hide_range:hide()
        return
    end

    if mymenu.dr.Q:get() then
        local color = self.q_ready and common.drawdr_menu.clr_q:get() or
            utils:set_alpha(common.drawdr_menu.clr_q:get(), 100)
        minimap.draw_circle(player.pos, self.q_range, 1, color, 18)
        if self.q_range > 500 then
            utils:draw_circle("q_range", player.pos, self.q_range, color)
        end
        if utils:has_buff(player, "twitchhideinshadows") then
            q_hide_range:show()
            if utils:count_enemy_hero(player.pos, 500) > 0 then
                q_hide_range:update_circle(player.pos, 500, 1, 0x30ff5050)
                q_hide_range_loop = true
            else
                q_hide_range:update_circle(player.pos, 500, 1, 0x20ffffff)
                q_hide_range_loop = true
            end
        elseif q_hide_range_loop == true then
            q_hide_range:update_circle(player.pos, 500, 1, 0x00ffffff)
            q_hide_range_loop = false
        end
    end

    if not utils:has_buff(player, "twitchhideinshadows") then
        if mymenu.dr.W:get() then
            local color = self.w_ready and common.drawdr_menu.clr_w:get() or
                utils:set_alpha(common.drawdr_menu.clr_w:get(), 120)
            utils:draw_circle("w_range", player.pos, self.w_range, color)
        end
        if mymenu.dr.E:get() then
            local color = self.e_ready and common.drawdr_menu.clr_e:get() or
                utils:set_alpha(common.drawdr_menu.clr_e:get(), 120)
            utils:draw_circle("e_range", player.pos, self.e_range, color)
        end
        if mymenu.dr.R:get() then
            local color = self.r_ready and common.drawdr_menu.clr_r:get() or
                utils:set_alpha(common.drawdr_menu.clr_r:get(), 120)
            utils:draw_circle("r_range", player.pos, self.r_range, color)
        end
    end

    local state_style = utils.menuc.draw_state_menu.state_style:get()
    local text_size = utils.menuc.draw_state_menu.text_size:get()
    local state_color = utils.menuc.draw_state_menu.text_color:get()
    local state_pos = player.pos + vec3(50, 0, -50)
    local p2d = graphics.world_to_screen(state_pos)
    local state_list = {
        { mymenu.sf,     mymenu.dr.sf:get() },
        { mymenu.semi_w, mymenu.dr.semi_w:get() },
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

    Twitch:dmg_output()
end

function Twitch:init()
    local function on_tick_orb()
        self:R_logic()
    end
    orb.combat.register_f_pre_tick(on_tick_orb)
    self:load()
    local tick_function = utils.on_slow_tick(10, function() self:slow_tick() end)
    cb.add(cb.tick, tick_function)
    cb.add(cb.tick, function() self:tick() end)
    cb.add(cb.spell, function(...) self:process_spell(...) end)
    cb.add(cb.cast_finish, function(...) self:finish_spell(...) end)
    cb.add(cb.cast_spell, function(...) self:on_cast_spell(...) end)

    cb.add(cb.path, function(...) self:path(...) end)
    cb.add(cb.draw, function() self:new_draw() end)
end

return Twitch:init()
