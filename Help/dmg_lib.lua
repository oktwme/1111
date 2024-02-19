local dmg_lib = {}
---@type utils
local utils = module.load(header.id, "Help/utils")
local damage = module.internal('damagelib')
local myhero = player

function dmg_lib:ad(target)
    if not target then return player.totalAd end
    return target.totalAd
end

function dmg_lib:base_ad(target)
    if not target then return player.baseAd end
    return target.baseAd
end

function dmg_lib:bonus_ad(target)
    if not target then return player.bonusAd end
    return target.bonusAd
end

function dmg_lib:ap(target)
    if not target then return player.totalAp end
    return target.totalAp
end

function dmg_lib:as(target)
    if not target then return 1 / player:attackDelay() end
    return 1 / target:attackDelay()
end

function dmg_lib:as_per(target)
    if not target then return player.attackSpeedMod end
    return target.attackSpeedMod
end

function dmg_lib:crit(target)
    if not target then return player.crit end
    return target.crit
end

function dmg_lib:have_sheen(src, target)
    local dmg = 0
    --3057 sheen Sheen
    --6632 6632buff Divine Sunderer
    --3508 3508buff Essence Reaver
    --6662 6662buff Iceborn Gauntlet
    --3100 lichbane Lich Bane
    --3078 3078trinityforce Trinity Force

    local function check_item_dmg(item_id, buff_name, physical, magical)
        local slot = nil
        local have_item = false

        for i = 0, 6 do
            local item_slot = player:inventorySlot(i)
            if item_slot and item_slot.hasItem and item_slot.id == item_id then
                slot = i + 6
                have_item = true
            end
        end

        if (have_item and src:spellSlot(slot).cooldown == 0) or utils:has_buff(src, buff_name) then
            if target then
                dmg = dmg + damage.calc_physical_damage(src, target, physical, 0, 0)
                dmg = dmg + damage.calc_magical_damage(src, target, magical)
            else
                dmg = dmg + physical + magical
            end
        end
    end

    -- Sheen
    check_item_dmg(3057, "sheen", dmg_lib:base_ad(src), 0)

    -- Divine Sunderer
    local sheen_hp = 0
    if target then
        sheen_hp = target.maxHealth * 0.02
    end
    check_item_dmg(6632, "6632buff", dmg_lib:base_ad(src) * 1.6 + sheen_hp, 0)

    -- Essence Reaver
    check_item_dmg(3508, "3508buff", dmg_lib:base_ad(src) * 1.3 + dmg_lib:bonus_ad(src) * 0.2, 0)

    -- Iceborn Gauntlet
    check_item_dmg(6662, "6662buff", dmg_lib:base_ad(src), 0)

    -- Lich Bane
    check_item_dmg(3100, "lichbane", 0, dmg_lib:base_ad(src) * 0.75 + dmg_lib:ap(src) * 0.5)

    -- Trinity Force
    check_item_dmg(3078, "3078trinityforce", dmg_lib:base_ad(src) * 2, 0)

    return dmg
end

--incorrect
-- ///////////////////////////////////////////////////////////////////////////////////////////

-- #region Briar
function dmg_lib:Briar_Q(src, target)
    if not src or not target then return 0 end
    if src:spellSlot(0).state ~= 0 then return 0 end

    local q_level = src:spellSlot(0).level
    if q_level == 0 then return 0 end

    local base_dmg = 60 + 40 * (q_level - 1)
    local ad_dmg = dmg_lib:bonus_ad(src) * 0.8

    local total_dmg = base_dmg + ad_dmg

    return damage.calc_magical_damage(src, target, total_dmg)
end

function dmg_lib:Briar_W(src, target)
    if not src or not target then return 0 end
    if src:spellSlot(1).state ~= 0 then return 0 end

    local w_level = src:spellSlot(1).level
    if w_level == 0 then return 0 end

    local base_dmg = 5 + 15 * (w_level - 1)
    local ad_dmg = dmg_lib:ad(src) * 1.05
    local miss_hp = target.maxHealth - target.health
    local percent = 0.1 + dmg_lib:bonus_ad(src) / 100 * 0.04
    local hp_dmg = miss_hp * percent

    local total_dmg = base_dmg + ad_dmg + hp_dmg

    return damage.calc_magical_damage(src, target, total_dmg)
end

function dmg_lib:Briar_E(src, target)
    if not src or not target then return 0 end
    if src:spellSlot(2).state ~= 0 then return 0 end

    local e_level = src:spellSlot(2).level
    if e_level == 0 then return 0 end

    local base_dmg = 220 + 110 * (e_level - 1)
    local ad_dmg = dmg_lib:bonus_ad(src) * 3.4
    local ap_dmg = dmg_lib:ap(src) * 3.4

    local total_dmg = base_dmg + ad_dmg + ap_dmg

    return damage.calc_magical_damage(src, target, total_dmg)
end

-- #endregion

-- #region Ezreal
function dmg_lib:Ezreal_Q(src, target)
    if not src or not target then return 0 end

    if src:spellSlot(0).state ~= 0 then return 0 end

    local q_level = src:spellSlot(0).level
    if q_level == 0 then return 0 end

    local base_dmg = 20 + 25 * (q_level - 1)
    local total_dmg = base_dmg + dmg_lib:ad(src) * 1.3 + dmg_lib:ap(src) * 0.15

    return damage.calc_physical_damage(src, target, total_dmg) + dmg_lib:have_sheen(src, target)
end

function dmg_lib:Ezreal_W(src, target)
    if not src or not target then return 0 end

    if src:spellSlot(1).state ~= 0 then return 0 end

    local w_level = src:spellSlot(1).level
    if w_level == 0 then return 0 end

    local base_dmg = 80 + 55 * (w_level - 1)
    local ap_dmg = 0.7 + 0.05 * (w_level - 1)
    local total_dmg = base_dmg + dmg_lib:bonus_ad(src) * 0.6 + dmg_lib:ap(src) * ap_dmg

    return damage.calc_magical_damage(src, target, total_dmg)
end

function dmg_lib:Ezreal_E(src, target)
    if not src or not target then return 0 end

    if src:spellSlot(2).state ~= 0 then return 0 end

    local e_level = src:spellSlot(2).level
    if e_level == 0 then return 0 end

    local base_dmg = 80 + 50 * (e_level - 1)
    local total_dmg = base_dmg + dmg_lib:bonus_ad(src) * 0.5 + dmg_lib:ap(src) * 0.75

    return damage.calc_magical_damage(src, target, total_dmg)
end

function dmg_lib:Ezreal_R(src, target)
    if not src or not target then return 0 end

    if src:spellSlot(3).state ~= 0 then return 0 end

    local r_level = src:spellSlot(3).level
    if r_level == 0 then return 0 end

    local base_dmg = 350 + 150 * (r_level - 1)
    local total_dmg = base_dmg + dmg_lib:bonus_ad(src) + dmg_lib:ap(src) * 0.9

    if utils:is_valid_minion(target) then
        total_dmg = total_dmg / 2
    end

    return damage.calc_magical_damage(src, target, total_dmg)
end

-- #endregion

-- #region Jinx
function dmg_lib:Jinx_W(src, target)
    if not src or not target then return 0 end

    if src:spellSlot(1).state ~= 0 then return 0 end

    local w_level = src:spellSlot(1).level
    if w_level == 0 then return 0 end

    local base_dmg = 10 + 50 * (w_level - 1)
    local total_dmg = base_dmg + dmg_lib:ad(src) * 1.6

    return damage.calc_physical_damage(src, target, total_dmg)
end

-- #endregion

-- #region Kaisa
function dmg_lib:Kaisa_P(src, target, miss_hp)
    if not src or not target then return 0 end

    local hp = not miss_hp and 0 or miss_hp
    local base_dmg = 15 + dmg_lib:ap(src) / 100 * 6
    local miss_hp = target.maxHealth - (utils:get_real_hp(target, true, false, true) - hp)

    local total_dmg = miss_hp * base_dmg / 100

    return damage.calc_magical_damage(src, target, total_dmg)
end

function dmg_lib:Kaisa_Q(src, target)
    if not src or not target then return 0 end
    if src:spellSlot(0).state ~= 0 then return 0 end

    local q_level = src:spellSlot(0).level
    if q_level == 0 then return 0 end

    local base_dmg = 40 + 15 * (q_level - 1)
    local missile_1 = base_dmg + dmg_lib:bonus_ad(src) * 0.5 + dmg_lib:ap(src) * 0.3
    local missile_other = missile_1 * 0.25

    local function q_count()
        local count = utils:count_enemy(src.pos, 665, 1, 1, 1, 1, 1, 1)
        local values = { 6, 6, 3, 2, 2, 2, 1 }
        return count >= 0 and count <= #values and values[count + 1] or 1
    end

    local function q_count_evolve()
        local count = utils:count_enemy(src.pos, 665, 1, 1, 1, 1, 1, 1)
        local values = { 12, 12, 6, 4, 3, 3, 2, 2, 2, 2, 2, 2, 1 }
        return count >= 0 and count <= #values and values[count + 1] or 1
    end

    local q_missiles = utils:has_buff(src, "KaisaQEvolved") and q_count_evolve() or q_count()
    local total_dmg = missile_1 + missile_other * (q_missiles - 1)

    if utils:is_valid_minion(target) and utils:get_real_hp_pre(target) < 35 then
        total_dmg = total_dmg * 2
    end

    return damage.calc_physical_damage(src, target, total_dmg)
end

function dmg_lib:Kaisa_W(src, target)
    if not src or not target then return 0 end
    if src:spellSlot(1).state ~= 0 then return 0 end

    local w_level = src:spellSlot(1).level
    if w_level == 0 then return 0 end

    local base_dmg = 30 + 25 * (w_level - 1)
    local total_dmg = base_dmg + dmg_lib:ad(src) * 1.3 + dmg_lib:ap(src) * 0.45

    return damage.calc_magical_damage(src, target, total_dmg)
end

-- #endregion

-- #region Samira
function dmg_lib:Samira_Q(src, target)
    if not src or not target then return 0 end

    if src:spellSlot(0).state ~= 0 then return 0 end

    local q_level = src:spellSlot(0).level
    if q_level == 0 then return 0 end

    local crit = player.crit * 1.25 + 1 - player.crit
    local base_dmg = 5 * (q_level - 1)
    local ad = (0.85 + (q_level - 1) * 0.1)
    local total_dmg = (base_dmg + dmg_lib:ad(src) * ad) * crit

    return damage.calc_physical_damage(src, target, total_dmg)
end

function dmg_lib:Samira_W(src, target)
    if not src or not target then return 0 end

    if src:spellSlot(1).state ~= 0 then return 0 end

    local w_level = src:spellSlot(1).level
    if w_level == 0 then return 0 end

    local base_dmg = 40 + 30 * (w_level - 1)
    local total_dmg = base_dmg + dmg_lib:bonus_ad(src) * 1.6

    return damage.calc_physical_damage(src, target, total_dmg)
end

function dmg_lib:Samira_E(src, target)
    if not src or not target then return 0 end

    if src:spellSlot(2).state ~= 0 then return 0 end

    local e_level = src:spellSlot(2).level
    if e_level == 0 then return 0 end

    local base_dmg = 50 + 10 * (e_level - 1)
    local total_dmg = base_dmg + dmg_lib:bonus_ad(src) * 0.2

    return damage.calc_physical_damage(src, target, total_dmg)
end

function dmg_lib:Samira_R(src, target)
    if not src or not target then return 0 end

    local r_level = src:spellSlot(3).level
    if r_level == 0 then return 0 end

    local crit = player.crit * player.critDamageMultiplier + 1 - player.crit
    local base_dmg = 50 + 100 * (r_level - 1)
    local total_dmg = (base_dmg + dmg_lib:ad(src) * 5) * crit

    local buff = utils:has_buff(src, "SamiraR")
    if buff then
        local t = math.max(buff.endTime - game.time, 0) / 2.25
        return damage.calc_physical_damage(src, target, total_dmg * t)
    else
        return damage.calc_physical_damage(src, target, total_dmg)
    end
end

-- #endregion

-- #region Tristana
function dmg_lib:Tristana_W(src, target)
    if not src or not target then return 0 end

    if src:spellSlot(1).state ~= 0 then return 0 end

    local w_level = src:spellSlot(1).level
    if w_level == 0 then return 0 end

    local base_dmg = 95 + 50 * (w_level - 1)
    local total_dmg = base_dmg + dmg_lib:ap(src) * 0.5

    return damage.calc_magical_damage(src, target, total_dmg)
end

function dmg_lib:Tristana_E(src, target, stack)
    if not src or not target then return 0 end
    if stack >= 87 then return 0 end

    if src:spellSlot(2).state ~= 0 then return 0 end

    local e_level = src:spellSlot(2).level
    if e_level == 0 then return 0 end

    local base_dmg = 70 + 10 * (e_level - 1)
    local ad_dmg = dmg_lib:bonus_ad(src) * (0.5 + 0.25 * (e_level - 1))
    local ap_dmg = dmg_lib:ap(src) * 0.5

    local e_dmg = base_dmg + ad_dmg + ap_dmg
    local total_dmg = e_dmg * (1 + stack * 0.3) * (1 + dmg_lib:crit(src) * 0.333)

    return damage.calc_physical_damage(src, target, total_dmg)
end

function dmg_lib:Tristana_R(src, target)
    if not src or not target then return 0 end

    if src:spellSlot(3).state ~= 0 then return 0 end

    local r_level = src:spellSlot(3).level
    if r_level == 0 then return 0 end

    local base_dmg = 300 + 100 * (r_level - 1)
    local ap_dmg = dmg_lib:ap(src) * 0.5

    local total_dmg = base_dmg + ap_dmg

    return damage.calc_magical_damage(src, target, total_dmg)
end

-- #endregion

-- #region Twitch
function dmg_lib:Twitch_E(src, target, stack)
    if not src or not target then return 0 end

    if src:spellSlot(2).state ~= 0 then return 0 end

    local e_level = src:spellSlot(2).level
    if e_level == 0 then return 0 end

    local base_dmg = 20 + 10 * (e_level - 1)
    local stack_dmg = 15 + 5 * (e_level - 1) + dmg_lib:bonus_ad(src) * 0.35
    local total_ad_dmg = base_dmg + stack_dmg * stack
    local total_ap_dmg = dmg_lib:ap(src) * 0.3 * stack

    return damage.calc_physical_damage(src, target, total_ad_dmg) + damage.calc_magical_damage(src, target, total_ap_dmg)
end

-- #endregion

-- #region Yasuo
function dmg_lib:Yasuo_Q(src, target)
    if not src then return 0 end
    --if src:spellSlot(0).state ~= 0 then return 0 end

    local q_level = src:spellSlot(0).level
    if q_level == 0 then return 0 end

    local base_dmg = 20 + 25 * (q_level - 1)
    local q_crit_damage = myhero.critDamageMultiplier > 1.98 and 1.84793 or 1.46995
    local dmg1 = (base_dmg + dmg_lib:ad(src) * q_crit_damage) * dmg_lib:crit(src)
    local dmg2 = (base_dmg + dmg_lib:ad(src) * 1.05) * (1 - dmg_lib:crit(src))

    if not target then return dmg1 + dmg2 end
    local dmg_3 = 0
    if target.isLaneMinion or target.isMonster then
        for i = 0, 5, 1 do
            if player:itemID(i) == 6670 then
                dmg_3 = dmg_3 + 20
            end
        end
    end
    local total_dmg = dmg1 + dmg2 + dmg_3

    return damage.calc_physical_damage(src, target, total_dmg)
end

function dmg_lib:Yasuo_E(src, target)
    if not src or not target then return 0 end
    if src:spellSlot(2).state ~= 0 then return 0 end

    local e_level = src:spellSlot(2).level
    if e_level == 0 then return 0 end

    local base_dmg = 60 + 10 * (e_level - 1)
    local ad_dmg = dmg_lib:bonus_ad(src) * 0.2
    local ap_dmg = dmg_lib:ap(src) * 0.6
    local e_dmg = base_dmg + ad_dmg + ap_dmg

    local my_lvl = 15 + 10 / 17 * (src.levelRef - 1)
    local e_buff = utils:get_buff_count(myhero, "YasuoDashScalar")
    local e_extras = e_dmg * (my_lvl / 100) * e_buff

    local total_dmg = e_dmg + e_extras

    return damage.calc_magical_damage(src, target, total_dmg)
end

function dmg_lib:Yasuo_R(src, target)
    if not src or not target then return 0 end
    if src:spellSlot(3).state ~= 0 then return 0 end

    local r_level = src:spellSlot(3).level
    if r_level == 0 then return 0 end

    local base_dmg = 200 + 150 * (r_level - 1)
    local ad_dmg = dmg_lib:bonus_ad(src) * 1.5

    local total_dmg = base_dmg + ad_dmg

    return damage.calc_physical_damage(src, target, total_dmg)
end

-- #endregion

--correct

dmg_lib.fnvhash =
{
    TotalDamage = game.fnvhash("TotalDamage"),
    ActiveDamage = game.fnvhash("ActiveDamage")
}
function dmg_lib:load_damagemap()
    --chat.print( "["..player:spellSlot(3).name.."]" )
    --chat.print( player:spellSlot(3):getTooltip( 0 ) )

    --#region Blitzcrank
    --Q
    damage.handlers[game.spellhash("RocketGrab")] = function(source, target, is_raw_damage, stage)
        local spell_slot = source:spellSlot(0)
        if not spell_slot
        then
            return 0
        end

        local raw_damage = spell_slot:calculate(0, dmg_lib.fnvhash.TotalDamage)
        if is_raw_damage or not target or not target.valid
        then
            return raw_damage
        end

        return damage.calc_magical_damage(source, target, raw_damage)
    end

    --E
    damage.handlers[game.spellhash("PowerFist")] = function(source, target, is_raw_damage, stage)
        local spell_slot = source:spellSlot(2)
        if not spell_slot
        then
            return 0
        end

        local raw_damage = spell_slot:calculate(0, dmg_lib.fnvhash.TotalDamage)
        if is_raw_damage or not target or not target.valid
        then
            return raw_damage
        end

        return damage.calc_physical_damage(source, target, raw_damage)
    end

    --R
    damage.handlers[game.spellhash("StaticField")] = function(source, target, is_raw_damage, stage)
        local spell_slot = source:spellSlot(3)
        if not spell_slot
        then
            return 0
        end

        local raw_damage = spell_slot:calculate(0, dmg_lib.fnvhash.ActiveDamage)
        if is_raw_damage or not target or not target.valid
        then
            return raw_damage
        end

        return damage.calc_magical_damage(source, target, raw_damage)
    end
    --#endregion
end

return dmg_lib
