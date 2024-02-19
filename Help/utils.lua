---@class utils
local utils = {}
local myhero = player
local my_name = myhero.charName

local orb = module.internal('orb')
local pred = module.internal('pred')
local damage = module.internal('damagelib')
local evade = module.seek('evade')
local interrupter = module.load(header.id, "Help/interrupter")
local ts = module.load(header.id, "target_selector/target_selector")
local core_ts = module.internal('TS')

local clip = module.internal('clipper')
local polygon = clip.polygon
local polygons = clip.polygonshud_pos
local clipper = clip.clipper
local clipper_enum = clip.enum

local start_time = 0
local print_check = false

--敌方温泉
utils.enemy_nexus_obelisk = nil
utils.ally_nexus_obelisk = nil

function utils.on_slow_tick(fps, f)
    local last_tick_time = 0
    local min_time_per_tick = 1 / fps

    return function()
        local curr_time = game.time
        if (curr_time - last_tick_time) >= min_time_per_tick then
            last_tick_time = curr_time
            f()
        end
    end
end

function utils:load()
    self.last_aa_target = nil
    self.last_aa_target_t = 0
    self.orb_t = nil
    self.selector_t = nil

    self.last_aa_time = 0
    self.last_aa_time_end = 0
    self.last_aa_time_end_cast = 0
    self.before_aa_t = 0
    self.next_aa_t = 0
    self.time_until_next_aa = 0
    self.after_aa_t = 0

    self.menuc = nil

    self.flash_slot = -1
end

-- #region math
function utils:calc_angle(pos1, pos2, pos3)
    return math.abs(mathf.angle_between(pos2, pos3, pos1) * 180 / 3.14159)
end

function utils:face(target, pos)
    local path = target.path.serverPos
    return pos:distSqr(path) > pos:distSqr(path + target.direction)
end

function utils:bit_lshift(a, n)
    return a * (2 ^ n)
end

function utils:bit_rshift(a, n)
    return math.floor(a / (2 ^ n))
end

function utils:bit_and(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then
            result = result + bitval
        end
        bitval = bitval * 2
        a = math.floor(a / 2)
        b = math.floor(b / 2)
    end
    return result
end

function utils:bit_or(a, b)
    local result = 0
    local bitval = 1
    while a > 0 or b > 0 do
        if a % 2 == 1 or b % 2 == 1 then
            result = result + bitval
        end
        bitval = bitval * 2
        a = math.floor(a / 2)
        b = math.floor(b / 2)
    end
    return result
end

function utils:set_alpha(color, alpha_value)
    local color_without_alpha = self:bit_and(color, 0x00FFFFFF)
    local new_alpha = self:bit_lshift((self:bit_and(math.floor(alpha_value), 0xFF)), 24)

    return self:bit_or(new_alpha, color_without_alpha)
end

-- #endregion math

-- #region obj
function utils:is_valid(target)
    if target and target.valid and not target.isDead and target.isVisible and target.isTargetable then
        return true
    end
    return false
end

function utils:is_valid_minion(target)
    if target and target.valid and not target.isDead and target.isVisible and target.isTargetable and (target.isLaneMinion or target.isPet) then
        return true
    end
    return false
end

function utils:is_baron(target)
    if not target then
        return false
    end

    local name = string.lower(target.name)

    return string.find(name, "sru_baron") ~= nil
end

function utils:is_crab(target)
    if not target then
        return false
    end

    local name = string.lower(target.name)

    return string.find(name, "sru_crab") ~= nil
end

function utils:is_epic_monster(target)
    if not target then return false end

    local name = string.lower(target.name)

    return string.find(name, "sru_baron") ~= nil or
        string.find(name, "sru_dragon") ~= nil or
        string.find(name, "sru_riftherald") ~= nil
end

function utils:is_buff_monster(target)
    if not target then return false end

    local name = string.lower(target.name)

    return string.find(name, "sru_red") ~= nil or
        string.find(name, "sru_blue") ~= nil
end

function utils:is_small_monster(target)
    if not target then return false end

    local name = string.lower(target.name)

    return string.find(name, "sru_crab") ~= nil or
        (string.find(name, "sru_murkwolf") ~= nil and string.find(name, "mini") == nil) or
        (string.find(name, "sru_krug") ~= nil and string.find(name, "mini") == nil) or
        (string.find(name, "sru_razorbeak") ~= nil and string.find(name, "mini") == nil) or
        string.find(name, "sru_gromp") ~= nil
end

function utils:count_ally_hero(pos, range)
    local OAO = player.pos:dist(pos) <= range
    if OAO then
        return pos:countAllies(range) - 1
    else
        return pos:countAllies(range) - 1
    end
    -- local count = 0
    -- local allies = objManager.allies
    -- local allies_n = objManager.allies_n

    -- for i = 0, allies_n - 1 do
    --     local obj = allies[i]
    --     if obj and utils:is_valid(obj) and obj ~= player and pos:dist(obj.pos) <= range then
    --         count = count + 1
    --     end
    -- end

    -- return count
end

function utils:count_enemy_hero(pos, range)
    return pos:countEnemies(range)
    -- local count = 0
    -- local enemys = objManager.enemies
    -- local enemys_n = objManager.enemies_n

    -- for i = 0, enemys_n - 1 do
    --     local obj = enemys[i]
    --     if obj and utils:is_valid(obj) and obj ~= player and pos:dist(obj.pos) <= range then
    --         count = count + 1
    --     end
    -- end

    -- return count
end

function utils:in_enemy_turret(pos)
    local Obj1 = objManager.turrets[TEAM_ENEMY]
    local Obj1_size = objManager.turrets.size[TEAM_ENEMY]
    for i = 0, Obj1_size - 1 do
        local obj = Obj1[i]
        local range = myhero.boundingRadius + obj.boundingRadius + 755
        if not obj.isDead and pos:dist(obj.pos) < range then
            return true
        end
    end

    if self.enemy_nexus_obelisk and pos:dist(self.enemy_nexus_obelisk) < 1350 then
        return true
    end

    return false
end

function utils:close_turret(target)
    if not target then return nil end

    local turret_list = {}
    local Obj = target.team == TEAM_ENEMY and objManager.turrets[TEAM_ENEMY] or objManager.turrets[TEAM_ALLY]
    local Obj_size = target.team == TEAM_ENEMY and objManager.turrets.size[TEAM_ENEMY] or
        objManager.turrets.size[TEAM_ALLY]
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if obj and not obj.isDead and obj.valid then
            turret_list[#turret_list + 1] = obj
        end
    end

    table.sort(turret_list, function(a, b)
        return a.pos:dist(target.pos) < b.pos:dist(target.pos)
    end)

    return #turret_list > 0 and turret_list[1] or nil
end

function utils:close_enemy_turret()
    local turret_list = {}
    local Obj = objManager.turrets[TEAM_ENEMY]
    local Obj_size = objManager.turrets.size[TEAM_ENEMY]
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if obj and not obj.isDead and obj.valid then
            turret_list[#turret_list + 1] = obj
        end
    end

    table.sort(turret_list, function(a, b)
        return a.pos:dist(player.pos) < b.pos:dist(player.pos)
    end)

    return #turret_list > 0 and turret_list[1] or nil
end

function utils:in_ally_turret(pos, range)
    local Obj1 = objManager.turrets[TEAM_ALLY]
    local Obj1_size = objManager.turrets.size[TEAM_ALLY]
    for i = 0, Obj1_size - 1 do
        local obj = Obj1[i]
        local no_range = range and range or myhero.boundingRadius + obj.boundingRadius + 755
        if utils:is_valid(obj) and pos:dist(obj.pos) < no_range then
            return true
        end
    end

    -- local Obj2 = objManager
    -- local Obj2_size = objManager.maxObjects
    -- for i = 0, Obj2_size - 1 do
    --     local obj = Obj2.get(i)
    --     if obj and obj.type == TYPE_SPAWN and obj.team == TEAM_ALLY and pos:dist(obj.pos) < 1000 then
    --         return true
    --     end
    -- end

    return false
end

function utils:is_structure(target)
    return (target.type == TYPE_TURRET or target.type == TYPE_INHIB or target.type == TYPE_NEXUS)
end

function utils:count_enemy(pos, range, hero, minion, epic, buff, small, other)
    local count = 0

    local Obj1 = objManager.minions[TEAM_NEUTRAL]
    local Obj1_size = objManager.minions.size[TEAM_NEUTRAL]
    for i = 0, Obj1_size - 1 do
        local obj = Obj1[i]
        if utils:is_valid(obj) and obj.pos:dist(pos) <= range then
            if self:is_epic_monster(obj) and epic == 1 then
                count = count + 1
            elseif self:is_buff_monster(obj) and buff == 1 then
                count = count + 1
            elseif self:is_small_monster(obj) and small == 1 then
                count = count + 1
            elseif other == 1 then
                count = count + 1
            end
        end
    end

    local Obj2 = objManager.minions["lane_enemy"]
    local Obj2_size = objManager.minions.size["lane_enemy"]
    for i = 0, Obj2_size - 1 do
        local obj = Obj2[i]
        if utils:is_valid(obj) and obj.pos:dist(pos) <= range and minion == 1 then
            count = count + 1
        end
    end

    local Obj3 = objManager.enemies
    local Obj3_size = objManager.enemies_n
    for i = 0, Obj3_size - 1 do
        local obj = Obj3[i]
        if utils:is_valid(obj) and obj.pos:dist(pos) <= range and hero == 1 then
            count = count + 1
        end
    end

    return count
end

function utils:get_real_hp(target, all, ad, ap)
    if not target then return 0 end
    local hp = target.health
    if all then
        hp = hp + target.allShield
    end
    if ad then
        hp = hp + target.physicalShield
    end
    if ap then
        hp = hp + target.magicalShield
        if utils:has_buff(target, "ASSETS/Perks/Styles/Sorcery/NullifyingOrb/PerkNullifyingOrbActive.lua") then
            hp = hp + target.bonusAd * 0.14 + target.totalAp * 0.09 + 35 + 75 / 17 * target.levelRef
        end
    end
    return hp
end

function utils:get_real_hp_pre(target)
    if not target then return 0 end
    return self:get_real_hp(target, true, true, true) / target.maxHealth * 100
end

function utils:get_mana_pre(target)
    return target and target.mana / target.maxMana * 100 or 0
end

function utils:circle_points(origin, range, quality)
    local closedList = {}
    for i = 1, quality do
        local angle = i * 2 * math.pi / quality
        table.insert(closedList, vec2(
            origin.x + range * math.cos(angle),
            origin.z + range * math.sin(angle)))
    end
    return closedList
end

function utils:animate_color(color, min_alpha, max_alpha, period)
    local alpha_range = max_alpha - min_alpha

    local phase = (game.time % period) / period
    local alpha_value = 0.5 * alpha_range * math.sin(2 * math.pi * phase) + 0.5 * alpha_range + min_alpha

    return self:set_alpha(color, alpha_value)
end

function utils:draw_hp_bar(target, dmg_table)
    if not target then return end
    if not utils:is_valid(target) then return end
    if target.isPlant or target.isWard or target.isTrap or target.isPet or not target.isVisible then return end

    local dmg = 0
    local dmg_aa = 0
    local dmg_p = 0
    local dmg_q = 0
    local dmg_w = 0
    local dmg_e = 0
    local dmg_r = 0

    local mode = self.menuc.drawdd_menu.dmg_style:get()

    if type(dmg_table) == "table"
    then
        dmg_aa = dmg_table.aa or 0
        dmg_p  = dmg_table.passive or 0
        dmg_q  = dmg_table.q or 0
        dmg_w  = dmg_table.w or 0
        dmg_e  = dmg_table.e or 0
        dmg_r  = dmg_table.r or 0

        dmg    = dmg_aa + dmg_q + dmg_w + dmg_e + dmg_r + dmg_p
    else
        dmg = dmg_table
        mode = 1
    end

    if dmg <= 0 then return end

    local details = {
        baron = { long = 170, offset = 6, width = 13, x = 221, y = 273 },
        epic = { long = 143, offset = 5, width = 9, x = 236, y = 185 },
        crab = { long = 143, offset = 5.5, width = 12, x = 236, y = 186 },
        hero = { long = 105, offset = 4.5, width = 11.5, x = 163, y = 118 },
        default = { long = 143, offset = 4, width = 9, x = 236, y = 186 },
        others = { long = 80, offset = 1.5, width = 3.5 },
    }

    local chosenDetail
    if utils:is_baron(target) then
        chosenDetail = details.baron
    elseif utils:is_epic_monster(target) then
        chosenDetail = details.epic
    elseif utils:is_crab(target) then
        chosenDetail = details.crab
    elseif target.type == TYPE_HERO then
        chosenDetail = details.hero
    elseif utils:is_buff_monster(target) or utils:is_small_monster(target) then
        chosenDetail = details.default
    else
        chosenDetail = 0
    end
    --local chosenDetail = { long = orb.utility.get_bar_width(target), offset = 1.5, width = 3.5 }

    if chosenDetail == 0 then return end

    local DPI_FACTOR = graphics.height > 1080 and graphics.height / 1080 * 0.9 or 1

    chosenDetail.long = chosenDetail.long * DPI_FACTOR
    chosenDetail.width = chosenDetail.width * DPI_FACTOR
    chosenDetail.offset = chosenDetail.offset * DPI_FACTOR

    local _163 = 163 * DPI_FACTOR
    local x1 = target.barPos.x + _163 + chosenDetail.long * utils:get_real_hp_pre(target) / 100
    local y = target.barPos.y + 118 * DPI_FACTOR + chosenDetail.offset

    --graphics.draw_line_2D(target.barPos.x + _163, target.barPos.y + 123, target.barPos.x + 268, target.barPos.y + 123, chosenDetail.width, self.menuc.drawdd_menu.clr_dmg:get())

    if mode == 1 or dmg_aa == nil or dmg_q == nil or dmg_w == nil or dmg_e == nil or dmg_r == nil then
        local dmg_pre = utils:get_real_hp_pre(target) - dmg / target.maxHealth * 100
        local pos = target.barPos.x + _163 + chosenDetail.long * (dmg_pre) / 100

        local x2 = 0
        if target.barPos.x + _163 < pos then
            x2 = pos
            graphics.draw_line_2D(x1, y, x2, y, chosenDetail.width, self.menuc.drawdd_menu.clr_dmg:get())
        else
            x2 = target.barPos.x + _163

            local color = self:animate_color(self.menuc.drawdd_menu.clr_lt:get(), 60, 180, 1)
            graphics.draw_line_2D(x1, y, x2, y, chosenDetail.width, self.menuc.drawdd_menu.clr_lt:get())
        end
    elseif mode == 2 then
        local dmg_pre = utils:get_real_hp_pre(target) - dmg / target.maxHealth * 100
        local pos = target.barPos.x + _163 + chosenDetail.long * (dmg_pre) / 100

        local x2 = 0
        if target.barPos.x + _163 < pos
        then
            x2 = x1

            if dmg_r > 0
            then
                local width = chosenDetail.width * dmg_r / 100
                x2 = x2 - width

                graphics.draw_line_2D(x1, y, x2 - 10, y, chosenDetail.width, self.menuc.drawdd_menu.clr_r:get())

                x1 = x1 - width
            end

            if dmg_e > 0
            then
                local width = chosenDetail.width * dmg_e / 100
                x2 = x2 - width

                graphics.draw_line_2D(x1, y, x2, y, chosenDetail.width, self.menuc.drawdd_menu.clr_e:get())

                x1 = x1 - width
            end

            if dmg_w > 0
            then
                local width = chosenDetail.width * dmg_w / 100
                x2 = x2 - width

                graphics.draw_line_2D(x1, y, x2, y, chosenDetail.width, self.menuc.drawdd_menu.clr_w:get())

                x1 = x1 - width
            end

            if dmg_q > 0
            then
                local width = chosenDetail.width * dmg_q / 100
                x2 = x2 - width

                graphics.draw_line_2D(x1, y, x2, y, chosenDetail.width, self.menuc.drawdd_menu.clr_q:get())

                x1 = x1 - width
            end

            if dmg_p > 0
            then
                local width = chosenDetail.width * dmg_p / 100
                x2 = x2 - width

                graphics.draw_line_2D(x1, y, x2, y, chosenDetail.width, self.menuc.drawdd_menu.clr_p:get())

                x1 = x1 - width
            end

            if dmg_aa > 0
            then
                local width = chosenDetail.width * dmg_aa / 100
                x2 = x2 - width

                graphics.draw_line_2D(x1, y, x2, y, chosenDetail.width, self.menuc.drawdd_menu.clr_aa:get())

                x1 = x1 - width
            end
        else
            x2 = target.barPos.x + _163
            local color = self:animate_color(self.menuc.drawdd_menu.clr_lt:get(), 60, 180, 1)
            graphics.draw_line_2D(x1, y, x2, y, chosenDetail.width, color)
        end
    end
end

function utils:draw_gradient_arc(center_point, radius, start_angle, end_angle, color1, color2, t, num_segments, rel)
    local r1 = self:bit_rshift(self:bit_and(color1, 0xFF0000), 16)
    local g1 = self:bit_rshift(self:bit_and(color1, 0x00FF00), 8)
    local b1 = self:bit_and(color1, 0x0000FF)
    local a1 = self:bit_rshift(self:bit_and(color1, 0xFF000000), 24)

    local r2 = self:bit_rshift(self:bit_and(color2, 0xFF0000), 16)
    local g2 = self:bit_rshift(self:bit_and(color2, 0x00FF00), 8)
    local b2 = self:bit_and(color2, 0x0000FF)
    local a2 = self:bit_rshift(self:bit_and(color2, 0xFF000000), 24)

    local dr = r2 - r1
    local dg = g2 - g1
    local db = b2 - b1
    local da = a2 - a1

    local angle_step = (end_angle - start_angle) / num_segments;
    local end_point_r = self:extend_vec(center_point, rel ~= nil and rel or player.pos, radius)
    for i = 1, num_segments
    do
        local current_angle = start_angle + (i * angle_step)
        local next_angle = start_angle + ((i + 1) * angle_step)

        local r = r1 + ((dr < 0) and -((-dr * i) / num_segments) or (dr * i) / num_segments)
        local g = g1 + ((dg < 0) and -((-dg * i) / num_segments) or (dg * i) / num_segments)
        local b = b1 + ((db < 0) and -((-db * i) / num_segments) or (db * i) / num_segments)
        local a = a1 + ((da < 0) and -((-da * i) / num_segments) or (da * i) / num_segments)

        r = math.min(255, math.max(0, r))
        g = math.min(255, math.max(0, g))
        b = math.min(255, math.max(0, b))
        a = math.min(255, math.max(0, a))

        local start_point = center_point +
            (utils:extend_vec(center_point, end_point_r, radius) - center_point):rotate(math.rad(current_angle))
        local end_point = center_point + (end_point_r - center_point):rotate(math.rad(next_angle))

        graphics.draw_line(start_point, end_point, t, graphics.argb(a, r, g, b))
    end
end

function utils:draw_gradient_arc_screen(center_point, radius, start_angle, end_angle, color1, color2, t, num_segments,
                                        rel)
    local angle_step = (end_angle - start_angle) / num_segments;

    local r1 = self:bit_rshift(self:bit_and(color1, 0xFF0000), 16)
    local g1 = self:bit_rshift(self:bit_and(color1, 0x00FF00), 8)
    local b1 = self:bit_and(color1, 0x0000FF)
    local a1 = self:bit_rshift(self:bit_and(color1, 0xFF000000), 24)

    local r2 = self:bit_rshift(self:bit_and(color2, 0xFF0000), 16)
    local g2 = self:bit_rshift(self:bit_and(color2, 0x00FF00), 8)
    local b2 = self:bit_and(color2, 0x0000FF)
    local a2 = self:bit_rshift(self:bit_and(color2, 0xFF000000), 24)

    local dr = r2 - r1
    local dg = g2 - g1
    local db = b2 - b1
    local da = a2 - a1

    local end_point_r = self:extend_vec(center_point, rel ~= nil and rel or player.pos, radius)
    for i = 0, num_segments
    do
        local current_angle = start_angle + (i * angle_step)
        local next_angle = start_angle + ((i + 1) * angle_step)

        local r = r1 + ((dr < 0) and -((-dr * i) / num_segments) or (dr * i) / num_segments)
        local g = g1 + ((dg < 0) and -((-dg * i) / num_segments) or (dg * i) / num_segments)
        local b = b1 + ((db < 0) and -((-db * i) / num_segments) or (db * i) / num_segments)
        local a = a1 + ((da < 0) and -((-da * i) / num_segments) or (da * i) / num_segments)

        --unsigned long current_color = ( a << 24 ) | ( r << 16 ) | ( g << 8 ) | b;

        --// Calculate the end point of the current line segment

        local start_point = center_point +
            (utils:extend_vec(center_point, end_point_r, radius) - center_point):rotate(math.rad(current_angle))
        local end_point = center_point + (end_point_r - center_point):rotate(math.rad(next_angle))

        graphics.draw_line_2D(start_point.x, start_point.y, end_point.x, end_point.y, t, graphics.argb(a, r, g, b))
    end
end

function utils:has_buff(target, name)
    if not target then
        return false
    end
    local buff_name = string.lower(name)
    local buff_hash = game.fnvhash(buff_name)
    local buff = target:findBuff(buff_hash)

    return buff
    --return target:findBuff(buff_hash)


    -- local buff_name = string.lower(name)
    -- if target.buff and target.buff[buff_name] then
    --     return true
    -- end
    -- return false
end

function utils:get_buff_count(target, name)
    if not (target or name or utils:is_valid(target)) then
        return 0
    end

    local buff_name = string.lower(name)
    local buff_hash = game.fnvhash(buff_name)

    return target:getBuffStacks(buff_hash)
end

function utils:get_buff_count2(target, name)
    if not (target or name or utils:is_valid(target)) then
        return 0
    end

    local buff_name = string.lower(name)
    local buff_hash = game.fnvhash(buff_name)

    return target:getBuffCount(buff_hash)
end

local cc_buff_list = {
    [BUFF_STUN] = true,
    [BUFF_TAUNT] = true,
    [BUFF_SNARE] = true,
    [BUFF_NEARSIGHT] = true,
    [BUFF_FEAR] = true,
    [BUFF_CHARM] = true,
    [BUFF_SUPPRESSION] = true,
    [BUFF_FLEE] = true,
    [BUFF_KNOCKUP] = true,
    [BUFF_ASLEEP] = true,
}
function utils:get_cc_time(target)
    local cc_time = 0
    for buff_id, _ in pairs(cc_buff_list) do
        local buff = target.buff[buff_id]
        if buff and buff.valid and buff.endTime - game.time > cc_time then
            cc_time = buff.endTime - game.time
        end
    end
    return cc_time
end

local afk_buff_list = {
    ["willrevive"] = true,
    ["chronoshift"] = true,
    ["zhonyasringshield"] = true,
    ["bardrstasis"] = true,
    ["lissandrarself"] = true,
    ["chronorevive"] = true,
}
function utils:get_gold_time(target)
    local afk_time = 0
    for buff_id, _ in pairs(afk_buff_list) do
        local buff = utils:has_buff(target, buff_id)
        if buff and buff.valid and buff.endTime - game.time > afk_time then
            afk_time = buff.endTime - game.time
        end
    end
    return afk_time
end

function utils:special_cast(target, hit_t)
    local afk_time = 0
    if utils:get_gold_time(target) > afk_time then
        afk_time = utils:get_gold_time(target)
    end
    if utils:get_cc_time(target) > afk_time then
        afk_time = utils:get_cc_time(target)
    end

    if afk_time > 0 and hit_t > afk_time then
        return true
    end
    return false
end

function utils:cc_hit()

end

function utils:get_target(range, _type, include_hitbox, _menu_whitelist, _ignore_function, _pred_type)
    -- local function ts_func(result, target, distance)
    --     if distance > range + ((b_include_hitbox ~= nil and b_include_hitbox == true) and (player.boundingRadius + target.boundingRadius) or (0))
    --     then
    --         return false
    --     end

    --     --whitelist
    --     if menu_wl
    --     then
    --         local key = target.charName:lower()
    --         if not menu_wl[key] or not menu_wl[key]:get()
    --         then
    --             return false
    --         end
    --     end

    --     --extra check (optional)
    --     if ignore_fn ~= nil and ignore_fn(target)
    --     then
    --         return false
    --     end

    --     result.target = target

    --     return true
    -- end

    -- local res = ts.get_result(ts_func)
    -- return res.target

    --target_selector:get_target(range, _type, include_hitbox, _menu_whitelist, _ignore_function, _pred_type)
    return ts:get_target(range, _type, include_hitbox, _menu_whitelist, _ignore_function, _pred_type)
end

function utils:ignore_cc(target)
    if not target then return false end

    -- if target.actionState2 == 2 or target.actionState2 == 6 or target.actionState == 33562638 then
    --     return true
    -- end

    if target.buff.type and (target.buff.type[BUFF_SPELLSHIELD] or target.buff.type[BUFF_SPELLIMMUNITY]) then
        return true
    end
    return false
end

local ignore_spell_hash = {
    ["NocturneShroudofDarkness"] = true,
    ["itemmagekillerveil"] = true,
    ["bansheesveil"] = true,
    ["SivirE"] = true,
    ["malzaharpassiveshield"] = true,
    ["MorganaE"] = true,
}
function utils:ignore_spell(target)
    if not utils:is_valid(target) then return false end

    if target and target.buff and target.buff.type then
        return target.buff.type == BUFF_SPELLSHIELD or target.buff.type == BUFF_SPELLIMMUNITY or
            target.buff.type == BUFF_INVULNERABILITY
    end

    for buff_id, _ in pairs(ignore_spell_hash) do
        local buff = utils:has_buff(target, buff_id)
        if buff then
            return true
        end
    end
    return false
end

function utils:ignore_aa(target)
    if utils:has_buff(target, "JaxCounterStrike")
        or
        utils:has_buff(target, "ShenW")
        or
        utils:has_buff(target, "SamiraW")
    then
        return true
    end
    if utils:has_buff(myhero, "BlindingDart") then
        return true
    end
    return false
end

--drop fps
local now_buff = {}
function utils:check_buff(target, get, lose)
    if not target then return end

    for i = 0, target.buffManager.count - 1 do
        local buff = target.buffManager:get(i)
        if buff.valid then
            if not now_buff[buff.name] and get then
                print("get buff: " .. buff.name)
            end
            now_buff[buff.name] = true
        end
    end

    for buff_name, _ in pairs(now_buff) do
        local has_buff = false
        for i = 0, target.buffManager.count - 1 do
            local current_buff = target.buffManager:get(i)
            if current_buff.valid and current_buff.name == buff_name then
                has_buff = true
                break
            end
        end
        if not has_buff and lose then
            print("lose buff: " .. buff_name)
            now_buff[buff_name] = nil
        end
    end
end

function utils:check_2Dpath(obj, delay)
    if not obj then return false end

    if not obj.path.isMoving or obj.active_spell then
        return obj.pos2D
    end
    local obj_2D = obj.pos:to2D()
    local obj_path = obj.path.endPos2D
    local dist = obj_2D:dist(obj_path)
    local dir = (obj_path - obj_2D):norm()
    local path_end_pos = obj_2D + dir * obj.moveSpeed * delay
    local path_dist = obj_2D:dist(path_end_pos)
    if path_dist > dist then
        return obj_path
    else
        return path_end_pos
    end
end

local dead_enemy = {}
function utils:check_die()
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if obj then
            if obj.isDead and not dead_enemy[obj.networkID] then
                dead_enemy[obj.networkID] = true
                return obj
            end
            if not obj.isDead and dead_enemy[obj.networkID] then
                dead_enemy[obj.networkID] = nil
            end
        end
    end
    return nil
end

function utils:in_table(tbl, v)
    for i = 1, #tbl
    do
        if tbl[i] == v
        then
            return true
        end
    end

    return false
end

utils.itemstatikshankcharge_hash = game.fnvhash("itemstatikshankcharge")
utils.special_aa_buffs = { game.fnvhash("lichbane"), game.fnvhash("sheen"), game.fnvhash("PowerFist"), game.fnvhash( "ViktorPowerTransferReturn" ) }
function utils:has_special_aa(obj)
    local v = obj ~= nil and obj or player

    local buffs = v.buff
    for _, buff in pairs(buffs)
    do
        if buff.valid
        then
            local buff_name = game.fnvhash(buff.name)
            if self:in_table(self.special_aa_buffs, buff_name) or (buff_name == self.itemstatikshankcharge_hash and buff.count >= 100)
            then
                return true
            end
        end
    end

    return false
end

function utils:in_aa_range(_src, _target, extra)
    local source = _target ~= nil and _src or player
    local target = _target ~= nil and _target or _src

    return source.pos:dist(target.pos) <=
        source.attackRange + source.boundingRadius + target.boundingRadius + (extra ~= nil and extra or 0)
end

function utils:extend_vec(from, to, range)
    return from + ((to - from):norm() * range);
end

function utils:get_health_prediction(v, b_ad, b_ap, b_true)
    if not evade then return 0, 0 end

    local ad_damage, ap_damage, true_damage, buff_list = evade.damage.count(v)

    local damage = 0
    if b_ad
    then
        damage = damage + ad_damage
    end

    if b_ap
    then
        damage = damage + ap_damage
    end

    if b_true
    then
        damage = damage + true_damage
    end

    return self:get_real_hp(v, true, b_ad, b_ap) - damage, damage
end

function utils:is_evade()
    if evade and evade.core.is_active() then return true end
    return false
end

-- #endregion obj

-- #region menu
function utils:set_visible(elements, visible)
    for _, element in ipairs(elements) do
        element:set('visible', visible)
    end
end

function utils:hide_menu(elements, value, old, new)
    if new then
        utils:set_visible(elements, value)
    else
        utils:set_visible(elements, not value)
    end
end

function utils:reset_menu_utils(menu_obj)
    menu_obj.logic_menu.save_check.s_ignore:set('value', true)
    menu_obj.logic_menu.save_check.s_my_hp:set('value', 30)
    menu_obj.logic_menu.save_check.s_my_hp:set('visible', false)
    menu_obj.logic_menu.save_check.s_t_hp:set('value', 50)
    menu_obj.logic_menu.save_check.s_t_hp:set('visible', false)
    menu_obj.logic_menu.save_check.s_r:set('value', 300)
    menu_obj.logic_menu.save_check.s_r:set('visible', false)



    menu_obj.logic_menu.save_check.m_ignore:set('value', false)
    menu_obj.logic_menu.save_check.m_my_hp:set('value', 30)
    menu_obj.logic_menu.save_check.m_ally_r:set('value', 400)
    menu_obj.logic_menu.save_check.m_enemy_r:set('value', 400)
    menu_obj.logic_menu.save_check.m_enemy:set('value', 2)

    menu_obj.logic_menu.save_check.l_ignore:set('value', false)
    menu_obj.logic_menu.save_check.l_my_hp:set('value', 50)
    menu_obj.logic_menu.save_check.l_ally_r:set('value', 400)
    menu_obj.logic_menu.save_check.l_enemy_r:set('value', 400)
    menu_obj.logic_menu.save_check.l_enemy:set('value', 1)

    local idiot = {
        ["Janna"] = true,
        ["Sona"] = true,
        ["Lux"] = true,
        ["Nami"] = true,
        ["Morgana"] = true,
        ["Yuumi"] = true,
        ["Soraka"] = true
    }

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        local default = idiot[obj.charName] and 0 or 300
        menu_obj.logic_menu.dash_check[obj.charName]:set('value', default)
    end

    menu_obj.logic_menu.dash_check.ignore_hp:set('value', 50)
    menu_obj.logic_menu.dash_check.ignore_dps:set('value', 2)

    menu_obj.logic_menu.automatic_menu.ks_turret:set('value', false)
    menu_obj.logic_menu.automatic_menu.ks_grass:set('value', false)
    menu_obj.logic_menu.automatic_menu.ks_recall:set('value', false)

    menu_obj.logic_menu.automatic_menu.turret:set('value', true)
    menu_obj.logic_menu.automatic_menu.grass:set('value', true)
    menu_obj.logic_menu.automatic_menu.recall:set('value', true)
end

function utils:menu_utils(menu_obj)
    if hanbot.language == 2 then
        menu_obj:menu("logic_menu", "Logic setting")
        -- #region Save Check
        menu_obj.logic_menu:menu("save_check", "Save Check")

        -- Solo
        menu_obj.logic_menu.save_check:header("header_solo", "Solo")
        menu_obj.logic_menu.save_check:boolean("s_ignore", "Ignore", true)
        --menu_obj.logic_menu.save_check:dropdown("s_ignore", "Ignore", 1, { "True", "False" })
        menu_obj.logic_menu.save_check:slider("s_my_hp", "If my hp <= x%", 30, 0, 100, 1)
        menu_obj.logic_menu.save_check:slider("s_t_hp", "If target hp >= x%", 50, 0, 100, 1)
        menu_obj.logic_menu.save_check:slider("s_r", "Range <= x", 300, 0, 1000, 1)

        -- Allies >= Enemies
        menu_obj.logic_menu.save_check:header("header_allies_ge_enemies", "Allies >= Enemies")
        menu_obj.logic_menu.save_check:boolean("m_ignore", "Ignore", false)
        --menu_obj.logic_menu.save_check:dropdown("m_ignore", "Ignore", 1, { "True", "False" })
        menu_obj.logic_menu.save_check:slider("m_my_hp", "If my hp <= x%", 30, 0, 100, 1)
        menu_obj.logic_menu.save_check:slider("m_ally_r", "Ally Range check", 400, 0, 1500, 1)
        menu_obj.logic_menu.save_check:slider("m_enemy_r", "Enemy dist me <= x", 400, 0, 1500, 1)
        menu_obj.logic_menu.save_check:slider("m_enemy", " ^- Enemy >= x", 2, 0, 5, 1)

        -- Allies < Enemies
        menu_obj.logic_menu.save_check:header("header_allies_lt_enemies", "Allies < Enemies")
        menu_obj.logic_menu.save_check:boolean("l_ignore", "Ignore", false)
        --menu_obj.logic_menu.save_check:dropdown("l_ignore", "Ignore", 1, { "True", "False" })
        menu_obj.logic_menu.save_check:slider("l_my_hp", "If my hp <= x%", 50, 0, 100, 1)
        menu_obj.logic_menu.save_check:slider("l_ally_r", "Ally Range check", 400, 0, 1500, 1)
        menu_obj.logic_menu.save_check:slider("l_enemy_r", "Enemy dist me <= x", 400, 0, 1500, 1)
        menu_obj.logic_menu.save_check:slider("l_enemy", " ^- Enemy >= x", 1, 0, 5, 1)

        local s_elements = { menu_obj.logic_menu.save_check.s_my_hp, menu_obj.logic_menu.save_check.s_t_hp,
            menu_obj.logic_menu.save_check.s_r }
        local m_elements = { menu_obj.logic_menu.save_check.m_my_hp, menu_obj.logic_menu.save_check.m_ally_r,
            menu_obj.logic_menu.save_check.m_enemy_r, menu_obj.logic_menu.save_check.m_enemy }
        local l_elements = { menu_obj.logic_menu.save_check.l_my_hp, menu_obj.logic_menu.save_check.l_ally_r,
            menu_obj.logic_menu.save_check.l_enemy_r, menu_obj.logic_menu.save_check.l_enemy }

        self:set_visible(s_elements, not menu_obj.logic_menu.save_check.s_ignore:get())
        self:set_visible(m_elements, not menu_obj.logic_menu.save_check.m_ignore:get())
        self:set_visible(l_elements, not menu_obj.logic_menu.save_check.l_ignore:get())

        menu_obj.logic_menu.save_check.s_ignore:set('callback',
            function(old, new) utils:hide_menu(s_elements, false, old, new) end)
        menu_obj.logic_menu.save_check.m_ignore:set('callback',
            function(old, new) utils:hide_menu(m_elements, false, old, new) end)
        menu_obj.logic_menu.save_check.l_ignore:set('callback',
            function(old, new) utils:hide_menu(l_elements, false, old, new) end)

        menu_obj.logic_menu.save_check:header("note_1", "Save checks need fulfill all conditions")

        -- #endregion Save Check

        -- #region Dash Check
        menu_obj.logic_menu:menu("dash_check", "Dash Check")

        local idiot = {
            ["Janna"] = true,
            ["Sona"] = true,
            ["Lux"] = true,
            ["Nami"] = true,
            ["Morgana"] = true,
            ["Yuumi"] = true,
            ["Soraka"] = true
        }

        menu_obj.logic_menu.dash_check:header("header_1", "Don't close enemy x distance ( 0 = Disable )")
        for i = 0, objManager.enemies_n - 1 do
            local enemy = objManager.enemies[i]
            if not menu_obj.logic_menu.dash_check[enemy.charName] then
                local default = idiot[enemy.charName] and 0 or 300
                menu_obj.logic_menu.dash_check:slider(enemy.charName, enemy.charName, default, 0, 500, 1)
            end
        end

        menu_obj.logic_menu.dash_check:header("header_2", "Ignore")
        menu_obj.logic_menu.dash_check:slider("ignore_hp", " ^- If my hp >= x%", 50, 0, 100, 1)
        menu_obj.logic_menu.dash_check:slider("ignore_dps", " ^- If can kill (DPS)", 2, 1, 5, 1)
        menu_obj.logic_menu.dash_check:header("end", "")
        -- #endregion Dash Check

        -- #region Automatic
        menu_obj.logic_menu:menu("automatic_menu", "Automatic")

        -- Killsteal
        menu_obj.logic_menu.automatic_menu:header("header_killsteal", "Killsteal")
        menu_obj.logic_menu.automatic_menu:boolean("ks_turret", "Don't use in turret", false)
        menu_obj.logic_menu.automatic_menu:boolean("ks_grass", "Don't use in grass", false)
        menu_obj.logic_menu.automatic_menu:boolean("ks_recall", "Don't use in recall", false)

        -- Other
        menu_obj.logic_menu.automatic_menu:header("header_other", "Other")
        menu_obj.logic_menu.automatic_menu:boolean("turret", "Don't use in turret", true)
        menu_obj.logic_menu.automatic_menu:boolean("grass", "Don't use in grass", true)
        menu_obj.logic_menu.automatic_menu:boolean("recall", "Don't use in recall", true)
        menu_obj.logic_menu.automatic_menu:header("1", "")
        -- #endregion Automatic

        menu_obj.logic_menu:button("reset_menu", "Reset Menu", "Reset it!",
            function() utils:reset_menu_utils(menu_obj) end)
    elseif hanbot.language == 1 then
        menu_obj:menu("logic_menu", "逻辑设置")
        -- #region Save Check
        menu_obj.logic_menu:menu("save_check", "安全检查")

        -- Solo
        menu_obj.logic_menu.save_check:header("header_solo", "单挑")
        menu_obj.logic_menu.save_check:boolean("s_ignore", "无视", true)
        --menu_obj.logic_menu.save_check:dropdown("s_ignore", "Ignore", 1, { "True", "False" })
        menu_obj.logic_menu.save_check:slider("s_my_hp", "如果我的生命 <= x%", 30, 0, 100, 1)
        menu_obj.logic_menu.save_check:slider("s_t_hp", "如果敌人生命 >= x%", 50, 0, 100, 1)
        menu_obj.logic_menu.save_check:slider("s_r", "范围 <= x", 300, 0, 1000, 1)

        -- Allies >= Enemies
        menu_obj.logic_menu.save_check:header("header_allies_ge_enemies", "友军 >= 敌军")
        menu_obj.logic_menu.save_check:boolean("m_ignore", "无视", false)
        --menu_obj.logic_menu.save_check:dropdown("m_ignore", "Ignore", 1, { "True", "False" })
        menu_obj.logic_menu.save_check:slider("m_my_hp", "如果我的生命 <= x%", 30, 0, 100, 1)
        menu_obj.logic_menu.save_check:slider("m_ally_r", "队友范围检查", 400, 0, 1500, 1)
        menu_obj.logic_menu.save_check:slider("m_enemy_r", "敌人距离我 <= x", 400, 0, 1500, 1)
        menu_obj.logic_menu.save_check:slider("m_enemy", " ^- 敌人数量 >= x", 2, 0, 5, 1)

        -- Allies < Enemies
        menu_obj.logic_menu.save_check:header("header_allies_lt_enemies", "友军 < 敌军")
        menu_obj.logic_menu.save_check:boolean("l_ignore", "无视", false)
        --menu_obj.logic_menu.save_check:dropdown("l_ignore", "Ignore", 1, { "True", "False" })
        menu_obj.logic_menu.save_check:slider("l_my_hp", "如果我的生命 <= x%", 50, 0, 100, 1)
        menu_obj.logic_menu.save_check:slider("l_ally_r", "队友范围检查", 400, 0, 1500, 1)
        menu_obj.logic_menu.save_check:slider("l_enemy_r", "敌人距离我 <= x", 400, 0, 1500, 1)
        menu_obj.logic_menu.save_check:slider("l_enemy", " ^- 敌人 >= x", 1, 0, 5, 1)

        local s_elements = { menu_obj.logic_menu.save_check.s_my_hp, menu_obj.logic_menu.save_check.s_t_hp,
            menu_obj.logic_menu.save_check.s_r }
        local m_elements = { menu_obj.logic_menu.save_check.m_my_hp, menu_obj.logic_menu.save_check.m_ally_r,
            menu_obj.logic_menu.save_check.m_enemy_r, menu_obj.logic_menu.save_check.m_enemy }
        local l_elements = { menu_obj.logic_menu.save_check.l_my_hp, menu_obj.logic_menu.save_check.l_ally_r,
            menu_obj.logic_menu.save_check.l_enemy_r, menu_obj.logic_menu.save_check.l_enemy }

        self:set_visible(s_elements, not menu_obj.logic_menu.save_check.s_ignore:get())
        self:set_visible(m_elements, not menu_obj.logic_menu.save_check.m_ignore:get())
        self:set_visible(l_elements, not menu_obj.logic_menu.save_check.l_ignore:get())

        menu_obj.logic_menu.save_check.s_ignore:set('callback',
            function(old, new) utils:hide_menu(s_elements, false, old, new) end)
        menu_obj.logic_menu.save_check.m_ignore:set('callback',
            function(old, new) utils:hide_menu(m_elements, false, old, new) end)
        menu_obj.logic_menu.save_check.l_ignore:set('callback',
            function(old, new) utils:hide_menu(l_elements, false, old, new) end)

        menu_obj.logic_menu.save_check:header("note_1", "安全检查必须满足所有条件")

        -- #endregion Save Check

        -- #region Dash Check
        menu_obj.logic_menu:menu("dash_check", "跳跃检查")

        local idiot = {
            ["Janna"] = true,
            ["Sona"] = true,
            ["Lux"] = true,
            ["Nami"] = true,
            ["Morgana"] = true,
            ["Yuumi"] = true,
            ["Soraka"] = true
        }

        menu_obj.logic_menu.dash_check:header("header_1", "不要靠近敌人x距离 ( 0 = 关闭 )")
        for i = 0, objManager.enemies_n - 1 do
            local enemy = objManager.enemies[i]
            if not menu_obj.logic_menu.dash_check[enemy.charName] then
                local default = idiot[enemy.charName] and 0 or 300
                menu_obj.logic_menu.dash_check:slider(enemy.charName, enemy.charName, default, 0, 500, 1)
            end
        end

        menu_obj.logic_menu.dash_check:header("header_2", "无视")
        menu_obj.logic_menu.dash_check:slider("ignore_hp", " ^- 如果我的生命 >= x%", 50, 0, 100, 1)
        menu_obj.logic_menu.dash_check:slider("ignore_dps", " ^- 如果可以击杀 (DPS)", 2, 1, 5, 1)
        menu_obj.logic_menu.dash_check:header("end", "")
        -- #endregion Dash Check

        -- #region Automatic
        menu_obj.logic_menu:menu("automatic_menu", "自动")

        -- Killsteal
        menu_obj.logic_menu.automatic_menu:header("header_killsteal", "捡人头")
        menu_obj.logic_menu.automatic_menu:boolean("ks_turret", "不要在塔下使用", false)
        menu_obj.logic_menu.automatic_menu:boolean("ks_grass", "不要在草丛里使用", false)
        menu_obj.logic_menu.automatic_menu:boolean("ks_recall", "不要在回城时使用", false)

        -- Other
        menu_obj.logic_menu.automatic_menu:header("header_other", "其他")
        menu_obj.logic_menu.automatic_menu:boolean("turret", "不要在塔下使用", true)
        menu_obj.logic_menu.automatic_menu:boolean("grass", "不要在草丛里使用", true)
        menu_obj.logic_menu.automatic_menu:boolean("recall", "不要在回城时使用", true)
        menu_obj.logic_menu.automatic_menu:header("1", "")
        -- #endregion Automatic

        menu_obj.logic_menu:button("reset_menu", "重置菜单", "重置它!",
            function() utils:reset_menu_utils(menu_obj) end)
    end
end

function utils:menu_common(clr_p, clr_q, clr_w, clr_e, clr_r)
    if hanbot.language == 2 then
        local menuobj = menu("Klee_" .. my_name .. "_common", "Klee: common")

        local icon_klee = graphics.sprite('Resource/klee.png')
        if icon_klee
        then
            menuobj:set('icon', icon_klee)
        end

        menuobj:menu("drawdd_menu", "Draw damage")
        -- #region draw_damage
        menuobj.drawdd_menu:header("header_1", "Draw damage")
        menuobj.drawdd_menu:dropdown("dmg_style", "Color style", 1, { "Default", "Multi-color" })
        menuobj.drawdd_menu:color("clr_dmg", "Color", 255, 182, 193, 150)
        menuobj.drawdd_menu:color("clr_lt", "Color killable", 90, 255, 150, 150)
        menuobj.drawdd_menu:color("clr_aa", "AA color", 52, 73, 94, 150)
        menuobj.drawdd_menu:color("clr_p", "P color", 162, 155, 254, 150)
        menuobj.drawdd_menu:color("clr_q", "Q color", 236, 240, 241, 150)
        menuobj.drawdd_menu:color("clr_w", "W color", 26, 188, 156, 150)
        menuobj.drawdd_menu:color("clr_e", "E color", 253, 203, 110, 150)
        menuobj.drawdd_menu:color("clr_r", "R color", 162, 155, 254, 150)

        menuobj.drawdd_menu:header("header_end", "")

        local function hide_dd_menu()
            local menu_obj = menuobj.drawdd_menu

            --color total damage
            menu_obj.clr_dmg:set('visible', menu_obj.dmg_style:get() == 1)
            --aa
            menu_obj.clr_aa:set('visible', menu_obj.dmg_style:get() == 2) --and menu_obj.aa:get( )
            --p
            menu_obj.clr_p:set('visible', menu_obj.dmg_style:get() == 2)  --and menu_obj.p:get( )
            --q
            menu_obj.clr_q:set('visible', menu_obj.dmg_style:get() == 2)  --and menu_obj.q:get( )
            --w
            menu_obj.clr_w:set('visible', menu_obj.dmg_style:get() == 2)  --and menu_obj.w:get( )
            --e
            menu_obj.clr_e:set('visible', menu_obj.dmg_style:get() == 2)  --and menu_obj.e:get( )
            --r
            menu_obj.clr_r:set('visible', menu_obj.dmg_style:get() == 2)  --and menu_obj.r:get( )
        end
        hide_dd_menu()
        menuobj.drawdd_menu.dmg_style:set('callback', hide_dd_menu)
        -- #endregion draw_damage

        menuobj:menu("drawdr_menu", "Draw ranges")
        -- #region draw_range
        menuobj.drawdr_menu:header("drawdr_header", "Draw range")

        --menuobj.drawdr_menu:header("header_p", "P")
        menuobj.drawdr_menu:color("clr_p", "P color", clr_p and clr_p[1] ~= nil and clr_p[1] or 255,
            clr_p and clr_p[2] ~= nil and clr_p[2] or 255, clr_p and clr_p[3] ~= nil and clr_p[3] or 255,
            clr_p and clr_p[4] ~= nil and clr_p[4] or 255)

        --menuobj.drawdr_menu:header("header_q", "Q")
        menuobj.drawdr_menu:color("clr_q", "Q color", clr_q and clr_q[1] ~= nil and clr_q[1] or 255,
            clr_q and clr_q[2] ~= nil and clr_q[2] or 255, clr_q and clr_q[3] ~= nil and clr_q[3] or 255,
            clr_q and clr_q[4] ~= nil and clr_q[4] or 255)

        --menuobj.drawdr_menu:header("header_w", "W")
        menuobj.drawdr_menu:color("clr_w", "W color", clr_w and clr_w[1] ~= nil and clr_w[1] or 255,
            clr_w and clr_w[2] ~= nil and clr_w[2] or 255, clr_w and clr_w[3] ~= nil and clr_w[3] or 255,
            clr_w and clr_w[4] ~= nil and clr_w[4] or 255)

        --menuobj.drawdr_menu:header("header_e", "E")
        menuobj.drawdr_menu:color("clr_e", "E color", clr_e and clr_e[1] ~= nil and clr_e[1] or 255,
            clr_e and clr_e[2] ~= nil and clr_e[2] or 255, clr_e and clr_e[3] ~= nil and clr_e[3] or 255,
            clr_e and clr_e[4] ~= nil and clr_e[4] or 255)

        --menuobj.drawdr_menu:header("header_r", "R")
        menuobj.drawdr_menu:color("clr_r", "R color", clr_r and clr_r[1] ~= nil and clr_r[1] or 255,
            clr_r and clr_r[2] ~= nil and clr_r[2] or 255, clr_r and clr_r[3] ~= nil and clr_r[3] or 255,
            clr_r and clr_r[4] ~= nil and clr_r[4] or 255)

        menuobj.drawdr_menu:header("header_end", "")
        -- #endregion draw_range

        menuobj:menu("draw_state_menu", "Draw state")
        -- #region draw_state
        menuobj.draw_state_menu:header("drawstate_header", "Draw state")
        menuobj.draw_state_menu:dropdown("state_style", "State style", 1, { "All", "Only enable" })
        menuobj.draw_state_menu:slider("text_size", "Text size", 30, 20, 40, 1)
        menuobj.draw_state_menu:color("text_color", "Text color", 255, 255, 255, 255)

        menuobj.draw_state_menu:header("header_end", "")
        -- #endregion draw_state

        menuobj:menu("hidden_menu", "Hide menu")
        -- #region hidden_menu
        menuobj.hidden_menu:header("header_1", "Hide menu")
        menuobj.hidden_menu:boolean("ts", "Hide target selector", true)
        menuobj.hidden_menu.ts:set('callback', function(old, new)
            if new then
                core_ts.menu.visible = false
            else
                core_ts.menu.visible = true
            end
        end)
        core_ts.menu.visible = not menuobj.hidden_menu.ts:get()
        menuobj.hidden_menu:header("header_end", "")
        -- #endregion

        self.menuc = menuobj

        return menuobj
    elseif hanbot.language == 1 then
        local menuobj = menu("Klee_" .. my_name .. "_common", "Klee: 其他设置")

        local icon_klee = graphics.sprite('Resource/klee.png')
        if icon_klee
        then
            menuobj:set('icon', icon_klee)
        end

        menuobj:menu("drawdd_menu", "绘制伤害")
        -- #region draw_damage
        menuobj.drawdd_menu:header("header_1", "绘制伤害")
        menuobj.drawdd_menu:dropdown("dmg_style", "颜色风格", 1, { "预设", "多个颜色" })
        menuobj.drawdd_menu:color("clr_dmg", "颜色", 255, 182, 193, 150)
        menuobj.drawdd_menu:color("clr_lt", "可击杀颜色", 90, 255, 150, 150)
        menuobj.drawdd_menu:color("clr_aa", "普攻颜色", 52, 73, 94, 150)
        menuobj.drawdd_menu:color("clr_p", "被动颜色", 162, 155, 254, 150)
        menuobj.drawdd_menu:color("clr_q", "Q颜色", 236, 240, 241, 150)
        menuobj.drawdd_menu:color("clr_w", "W颜色", 26, 188, 156, 150)
        menuobj.drawdd_menu:color("clr_e", "E颜色", 253, 203, 110, 150)
        menuobj.drawdd_menu:color("clr_r", "R颜色", 162, 155, 254, 150)

        menuobj.drawdd_menu:header("header_end", "")

        local function hide_dd_menu()
            local menu_obj = menuobj.drawdd_menu

            --color total damage
            menu_obj.clr_dmg:set('visible', menu_obj.dmg_style:get() == 1)
            --aa
            menu_obj.clr_aa:set('visible', menu_obj.dmg_style:get() == 2) --and menu_obj.aa:get( )
            --p
            menu_obj.clr_p:set('visible', menu_obj.dmg_style:get() == 2)  --and menu_obj.p:get( )
            --q
            menu_obj.clr_q:set('visible', menu_obj.dmg_style:get() == 2)  --and menu_obj.q:get( )
            --w
            menu_obj.clr_w:set('visible', menu_obj.dmg_style:get() == 2)  --and menu_obj.w:get( )
            --e
            menu_obj.clr_e:set('visible', menu_obj.dmg_style:get() == 2)  --and menu_obj.e:get( )
            --r
            menu_obj.clr_r:set('visible', menu_obj.dmg_style:get() == 2)  --and menu_obj.r:get( )
        end
        hide_dd_menu()
        menuobj.drawdd_menu.dmg_style:set('callback', hide_dd_menu)
        -- #endregion draw_damage

        menuobj:menu("drawdr_menu", "绘制范围")
        -- #region draw_range
        menuobj.drawdr_menu:header("drawdr_header", "绘制范围")

        --menuobj.drawdr_menu:header("header_p", "P")
        menuobj.drawdr_menu:color("clr_p", "被动颜色", clr_p and clr_p[1] ~= nil and clr_p[1] or 255,
            clr_p and clr_p[2] ~= nil and clr_p[2] or 255, clr_p and clr_p[3] ~= nil and clr_p[3] or 255,
            clr_p and clr_p[4] ~= nil and clr_p[4] or 255)

        --menuobj.drawdr_menu:header("header_q", "Q")
        menuobj.drawdr_menu:color("clr_q", "Q颜色", clr_q and clr_q[1] ~= nil and clr_q[1] or 255,
            clr_q and clr_q[2] ~= nil and clr_q[2] or 255, clr_q and clr_q[3] ~= nil and clr_q[3] or 255,
            clr_q and clr_q[4] ~= nil and clr_q[4] or 255)

        --menuobj.drawdr_menu:header("header_w", "W")
        menuobj.drawdr_menu:color("clr_w", "W颜色", clr_w and clr_w[1] ~= nil and clr_w[1] or 255,
            clr_w and clr_w[2] ~= nil and clr_w[2] or 255, clr_w and clr_w[3] ~= nil and clr_w[3] or 255,
            clr_w and clr_w[4] ~= nil and clr_w[4] or 255)

        --menuobj.drawdr_menu:header("header_e", "E")
        menuobj.drawdr_menu:color("clr_e", "E颜色", clr_e and clr_e[1] ~= nil and clr_e[1] or 255,
            clr_e and clr_e[2] ~= nil and clr_e[2] or 255, clr_e and clr_e[3] ~= nil and clr_e[3] or 255,
            clr_e and clr_e[4] ~= nil and clr_e[4] or 255)

        --menuobj.drawdr_menu:header("header_r", "R")
        menuobj.drawdr_menu:color("clr_r", "R颜色", clr_r and clr_r[1] ~= nil and clr_r[1] or 255,
            clr_r and clr_r[2] ~= nil and clr_r[2] or 255, clr_r and clr_r[3] ~= nil and clr_r[3] or 255,
            clr_r and clr_r[4] ~= nil and clr_r[4] or 255)
        menuobj.drawdr_menu:header("header_end", "")
        -- #endregion draw_range

        menuobj:menu("draw_state_menu", "绘制状态")
        -- #region draw_state
        menuobj.draw_state_menu:header("drawstate_header", "绘制状态")
        menuobj.draw_state_menu:dropdown("state_style", "状态风格", 1, { "全部", "只有开启时" })
        menuobj.draw_state_menu:slider("text_size", "文字大小", 30, 20, 40, 1)
        menuobj.draw_state_menu:color("text_color", "文字颜色", 255, 255, 255, 255)

        menuobj.draw_state_menu:header("header_end", "")
        -- #endregion draw_state

        menuobj:menu("hidden_menu", "隐藏菜单")
        -- #region hidden_menu
        menuobj.hidden_menu:header("header_1", "隐藏菜单")
        menuobj.hidden_menu:boolean("ts", "隐藏目标选择器", true)
        menuobj.hidden_menu.ts:set('callback', function(old, new)
            if new then
                core_ts.menu.visible = false
            else
                core_ts.menu.visible = true
            end
        end)
        core_ts.menu.visible = not menuobj.hidden_menu.ts:get()
        menuobj.hidden_menu:header("header_end", "")
        -- #endregion

        self.menuc = menuobj

        return menuobj
    end
end

--utils:checkbox("menu1", "menu2", "menu3", target)
function utils:checkbox(menu, target)
    if not menu then return false end

    local menu_check = menu[target.charName]
    if not menu_check then return false end

    return menu_check:get()
end

function utils:create_whitelists(pmenu, b_enemies, b_ignore_self)
    local allies = b_enemies and self:get_enemies() or self:get_allies(b_ignore_self)
    for i = 1, #allies
    do
        local obj = allies[i]
        if obj
        then
            local key = obj.charName:lower()
            if not pmenu[key]
            then
                pmenu:boolean(key, obj.charName, true)
                pmenu[key]:set('icon', obj.iconSquare)
            end
        end
    end
end

function utils:create_whitelists_interrupter(pmenu)
    local enemy = self:get_enemies()
    for i = 1, #enemy
    do
        local obj = enemy[i]
        if obj
        then
            local name = obj.charName
            local hero_data = interrupter[name]
            if hero_data
            then
                pmenu:header("header_" .. name:lower(), name)
                for _, skill in ipairs(hero_data)
                do
                    pmenu:boolean(name .. skill.slot, name .. " " .. skill.Spell, skill.menu)
                    pmenu[name .. skill.slot]:set('icon', obj.iconSquare)
                end
            end
        end
    end
end

-- #endregion menu

-- #region poly

function utils:is_2d(pos)
    return not pos.z and true or false
end

function utils:is_3d(pos)
    return pos.z and true or false
end

function utils:to_3d(pos)
    return utils:is_3d(pos) and pos or vec3(pos.x, 0, pos.y)
end

function utils:to_2d(pos)
    return utils:is_2d(pos) and pos or vec2(pos.x, pos.z)
end

function utils:is_danger_2d_pos(pos)
    local value = false
    if not evade then return false end

    for i = evade.core.skillshots.n, 1, -1 do
        local spell = evade.core.skillshots[i]
        if pos and spell:contains(pos) then
            value = true
        end
    end
    return value
end

function utils:clamp(v, min, max)
    return math.min(max, math.max(v, min))
end

function utils:circle_poly(pos, radius, offset)
    local angleIncrement = 2 * math.pi / offset
    local polygonPoints = polygon()
    for i = 1, offset do
        local angle = i * angleIncrement
        local x = pos.x + radius * math.cos(angle)
        local z = pos.z + radius * math.sin(angle)
        polygonPoints:Add(vec3(x, pos.y, z))
    end
    return polygonPoints
end

function utils:cone_poly(from, to, radius, angle)
    local dir           = { x = to.x - from.x, z = to.z - from.z }
    local dir_length    = math.sqrt(dir.x * dir.x + dir.z * dir.z)
    dir.x               = dir.x / dir_length
    dir.z               = dir.z / dir_length

    local dir_angle     = math.atan2(dir.z, dir.x)
    local polygonPoints = polygon()

    for point = 0, angle, 20 do
        local temp   = math.rad(point)
        local offset = dir_angle + math.rad(-angle / 2)
        local x      = radius * math.cos(temp + offset) + from.x
        local z      = radius * math.sin(temp + offset) + from.z
        polygonPoints:Add(vec3(x, from.y, z))
    end
    polygonPoints:Add(vec3(from.x, from.y, from.z))
    return polygonPoints
end

function utils:rectangle_poly(from, to, width)
    local dir = (to - from):norm()
    local perp = dir:perp1()
    local polygonPoints = polygon({})
    local corner1 = from + perp * width
    local corner2 = from - perp * width
    local corner3 = to - perp * width
    local corner4 = to + perp * width
    polygonPoints:add(vec2(corner1.x, corner1.z))
    polygonPoints:add(vec2(corner2.x, corner2.z))
    polygonPoints:add(vec2(corner3.x, corner3.z))
    polygonPoints:add(vec2(corner4.x, corner4.z))

    return polygonPoints
end

function utils:triangles(from, to, length)
    local polygonPoints = polygon()
    local dir_left      = (to - from):norm():perp1()
    local dir_right     = (to - from):norm():perp2()
    local left          = to + dir_left * length
    local right         = to + dir_right * length
    polygonPoints:Add(left)
    polygonPoints:Add(right)
    polygonPoints:Add(vec3(from.x, from.y, from.z))

    return polygonPoints
end

-- #endregion poly

-- #region poly_2d_more_fps_A_A
function utils:triangles_2d(from, to, length)
    local polygonPoints               = {}
    local dir_left                    = (to - from):norm():perp1()
    local dir_right                   = (to - from):norm():perp2()
    local left                        = to + dir_left * length
    local right                       = to + dir_right * length

    polygonPoints[#polygonPoints + 1] = vec2(left.x, left.y)
    polygonPoints[#polygonPoints + 1] = vec2(right.x, right.y)
    polygonPoints[#polygonPoints + 1] = vec2(from.x, from.y)

    return polygonPoints
end

function utils:circle_2d(pos, radius, offset)
    local angleIncrement = 2 * math.pi / offset
    local polygonPoints = {}
    for i = 1, offset do
        local angle = i * angleIncrement
        local x = pos.x + radius * math.cos(angle)
        local y = pos.y + radius * math.sin(angle)
        polygonPoints[#polygonPoints + 1] = vec2(x, y)
    end
    return polygonPoints
end

function utils:rectangle_2d(from, to, width)
    local dir = (to - from):norm()
    local perp = dir:perp1()
    local polygonPoints = {}
    local corner1 = from + perp * width
    local corner2 = from - perp * width
    local corner3 = to - perp * width
    local corner4 = to + perp * width
    polygonPoints[#polygonPoints + 1] = corner1
    polygonPoints[#polygonPoints + 1] = corner2
    polygonPoints[#polygonPoints + 1] = corner3
    polygonPoints[#polygonPoints + 1] = corner4

    return polygonPoints
end

function utils:contains_2d(pos, poly)
    local crossings = 0
    local n = #poly
    for i = 1, n do
        local x1, y1 = poly[i].x, poly[i].y
        local x2, y2 = poly[(i % n) + 1].x, poly[(i % n) + 1].y
        if ((y1 > pos.y) ~= (y2 > pos.y)) and
            (pos.x < (x2 - x1) * (pos.y - y1) / (y2 - y1) + x1) then
            crossings = crossings + 1
        end
    end
    return (crossings % 2) == 1
end

function utils:draw_2d(poly, y, color)
    local n = #poly
    for i = 1, n do
        local v1 = vec3(poly[i].x, y, poly[i].y)
        local v2 = vec3(poly[(i % n) + 1].x, y, poly[(i % n) + 1].y)
        if color then
            graphics.draw_line(v1, v2, 1, color)
        else
            graphics.draw_line(v1, v2, 1, 0xFFFFFFFF)
        end
    end
    local v_start = vec3(poly[1].x, y, poly[1].y)
    local v_end = vec3(poly[n].x, y, poly[n].y)
    if color then
        graphics.draw_line(v_start, v_end, 1, color)
    else
        graphics.draw_line(v_start, v_end, 1, 0xFFFFFFFF)
    end
end

-- #endregion poly_2d_more_fps_A_A

function utils:save_check(pos, Menu)
    --local Menu = module.load(header.id, "Champion/" .. player.charName) -- .. "/menu"
    --local Menu = require("pro_aio.Champion." .. player.charName .. ".Menu")

    if not Menu then return true end

    local enemy = {}
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if utils:is_valid(obj) then
            enemy[#enemy + 1] = obj
        end
    end

    table.sort(enemy, function(a, b)
        return a.pos:dist(myhero.pos) < b.pos:dist(myhero.pos)
    end)

    local solo = utils:count_ally_hero(pos, 1000) == 0 and #enemy > 0 and
        utils:count_enemy_hero(enemy[1].pos, 1000) == 1

    local ally_more = #enemy > 0 and
        pos:dist(enemy[1].pos) <= Menu.logic_menu.save_check.m_enemy_r:get() and
        utils:count_ally_hero(pos, Menu.logic_menu.save_check.m_ally_r:get()) >= utils:count_enemy_hero(pos, 1000)

    local enemy_more = #enemy > 0 and
        pos:dist(enemy[1].pos) <= Menu.logic_menu.save_check.l_enemy_r:get() and
        utils:count_ally_hero(pos, Menu.logic_menu.save_check.l_ally_r:get()) < utils:count_enemy_hero(pos, 1000)

    if not solo and not ally_more and not enemy_more then
        return true
    end

    if solo then
        if Menu.logic_menu.save_check.s_ignore:get() then
            return true
        elseif utils:get_real_hp_pre(myhero) <= Menu.logic_menu.save_check.s_my_hp:get() and
            utils:get_real_hp_pre(enemy[1]) >= Menu.logic_menu.save_check.s_t_hp:get() and
            pos:dist(enemy[1].pos) <= Menu.logic_menu.save_check.s_r:get() then
            return false
        else
            return true
        end
    elseif ally_more then
        if Menu.logic_menu.save_check.m_ignore:get() then
            return true
        elseif utils:get_real_hp_pre(myhero) <= Menu.logic_menu.save_check.m_my_hp:get() and
            utils:count_enemy_hero(pos, Menu.logic_menu.save_check.m_enemy_r:get()) >= Menu.logic_menu.save_check.m_enemy:get() then
            return false
        else
            return true
        end
    elseif enemy_more then
        if Menu.logic_menu.save_check.l_ignore:get() then
            return true
        elseif utils:get_real_hp_pre(myhero) <= Menu.logic_menu.save_check.l_my_hp:get() and
            utils:count_enemy_hero(pos, Menu.logic_menu.save_check.l_enemy_r:get()) >= Menu.logic_menu.save_check.l_enemy:get() then
            return false
        else
            return true
        end
    end


    -- return utils:use_automatic(Menu:Get("logic.automatic.ks_turret"), Menu:Get("logic.automatic.ks_grass"),
    --     Menu:Get("logic.automatic.ks_recall"))
end

function utils:dash_check(pos, dps)
    local Menu = module.load(header.id, "Champion/" .. player.charName .. "/menu")
    if not Menu then return true end


    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local menu_c = Menu.logic_menu.dash_check[enemy.charName]:get()
        local hp_c = Menu.logic_menu.dash_check.ignore_hp:get() <= utils:get_real_hp_pre(player) and
            Menu.logic_menu.dash_check.ignore_dps:get() * dps > utils:get_real_hp(enemy, true)

        if pos:dist(enemy.pos) < menu_c and not hp_c then
            return false
        end
    end
    return true
end

function utils:use_automatic(turret_m, grass_m, recall_m)
    local combo = orb.menu.combat.key:get()
    --navmesh.isGrass
    local turret = utils:in_enemy_turret(myhero.pos) and not combo and turret_m
    local grass = navmesh.isGrass(myhero.pos) and not combo and grass_m
    local recall = myhero.isRecalling and recall_m
    if grass or turret or recall then
        return false
    else
        return true
    end
end

function utils:get_best_lc_pos(type, spell_pred, minion, jungle, damage)
    --[[
        delay
        speed
        radius for circle
        width for line
        range
        boundingRadiusMod
        angle
        aoe
        collision
        source
    ]]
    local fromPos = player.pos
    local fromPos2D = fromPos:to2D()
    local spellPredRange = spell_pred.range
    local spellPredWidth = spell_pred.width ~= nil and spell_pred.width or spell_pred.radius

    local list = jungle and objManager.minions[TEAM_NEUTRAL] or objManager.minions["farm"]
    local validMinions = {}

    for i = 0, #list - 1 do
        local obj = list[i]
        if obj and (jungle and utils:is_valid(obj) or utils:is_valid_minion(obj)) then
            local objHitTime = spell_pred.delay + fromPos:dist(obj.pos) / spell_pred.speed
            local objPredPos = utils:check_2Dpath(obj, objHitTime)
            local inRange = player.pos:dist(objPredPos:to3D(obj.y)) < spell_pred.range
            if inRange and (damage > orb.farm.predict_hp(obj, objHitTime + 0.2) or damage == 0) then
                table.insert(validMinions, {
                    obj = obj,
                    objPredPos = objPredPos
                })
            end
        end
    end

    if #validMinions == 0 then
        return vec3(0, 0, 0)
    end

    local maxCount = 0
    local bestPos = vec3(0, 0, 0)
    for _, data in ipairs(validMinions) do
        local obj = data.obj
        local objPredPos = data.objPredPos

        local poly
        if type == "line" then
            local objTo2D = fromPos2D + (objPredPos - fromPos2D):norm() * spellPredRange
            poly = utils:rectangle_2d(fromPos2D, objTo2D, spellPredWidth + obj.boundingRadius * 0.5)
        elseif type == "circle" then
            poly = utils:circle_poly(objPredPos, spellPredWidth, 10)
        else
            return vec3(0, 0, 0)
        end

        local currentCount = 0
        for _, data2 in ipairs(validMinions) do
            local objPredPos = data2.objPredPos
            if utils:contains_2d(objPredPos, poly) then
                currentCount = currentCount + 1
            end
        end
        if currentCount >= maxCount then
            maxCount = currentCount
            bestPos = objPredPos:to3D(obj.y)
        end
    end


    if maxCount >= minion then
        return bestPos
    end
    return vec3(0, 0, 0)
end

-- lune version
function utils:get_best_lc_pos2(type, spell_pred, minion, jungle, damage)
    -- delay
    -- speed
    -- radius for circle
    -- width for line
    -- range
    -- boundingRadiusMod
    -- angle
    -- aoe
    -- collision
    -- source

    local fromPos = player.pos
    local fromPos2D = fromPos:to2D()
    local spellPredRange = spell_pred.range
    local spellPredWidth = spell_pred.width ~= nil and spell_pred.width or spell_pred.radius * 2

    local list = jungle and objManager.minions[TEAM_NEUTRAL] or objManager.minions["farm"]
    local validMinions = {}

    for i = 0, #list - 1 do
        local obj = list[i]
        if obj and (jungle and utils:is_valid(obj) or utils:is_valid_minion(obj)) then
            local objHitTime = spell_pred.delay + fromPos:dist(obj.pos) / spell_pred.speed
            local objPredPos = utils:check_2Dpath(obj, objHitTime)
            local inRange = player.pos:dist(objPredPos:to3D(obj.y)) < spell_pred.range
            if inRange and (damage > orb.farm.predict_hp(obj, objHitTime + 0.2) or damage == 0) then
                table.insert(validMinions, {
                    obj = obj,
                    objPredPos = objPredPos
                })
            end
        end
    end

    if #validMinions == 0 then return vec3(0, 0, 0) end

    if type == "line" then
        local maxCount = 0
        local maxHealth = 0
        local bestPos = vec3(0, 0, 0)
        local bestMinions = {}
        for _, data in ipairs(validMinions) do
            local obj = data.obj
            local objPredPos = data.objPredPos
            local objTo2D = fromPos2D + (objPredPos - fromPos2D):norm() * spellPredRange
            local poly = utils:rectangle_2d(fromPos2D, objTo2D, spellPredWidth + obj.boundingRadius * 0.5)

            local currentMinions = {}
            local currentMaxHealth = 0
            local currentCount = 0

            for _, data2 in ipairs(validMinions) do
                local obj2 = data2.obj
                if utils:contains_2d(data2.objPredPos, poly) then
                    currentCount = currentCount + 1
                    table.insert(currentMinions, obj2)
                    currentMaxHealth = currentMaxHealth +
                        ((self:is_epic_monster(obj2) or self:is_crab(obj2)) and 99900 or obj2.health)
                end
            end
            if currentCount >= maxCount then
                maxCount = currentCount
                bestPos = objPredPos:to3D(obj.y)
                bestMinions = currentMinions
                maxHealth = currentMaxHealth
            end
        end
        if maxCount >= minion then
            table.sort(bestMinions, function(v1, v2)
                return v1.pos:dist(player.pos) < v2.pos:dist(player.pos)
            end)

            return bestPos, bestMinions, maxHealth
        end
    elseif type == "circle"
    then
        --lol wtf was it before

        local maxCount = 0
        local bestPos = vec3(0, 0, 0)
        local bestTbl = {}
        local bestHealth = 0

        for _, data in ipairs(validMinions)
        do
            local objPredPos = data.objPredPos:to3D(data.obj.y)
            local currentCount = 0
            local currentHealth = 0
            local currentTbl = {}

            for _, data2 in ipairs(validMinions)
            do
                local objPredPos2 = data2.objPredPos:to3D(data2.obj.y)
                if objPredPos:dist(objPredPos2) <= spellPredWidth / 2
                then
                    currentCount = currentCount + 1
                    currentHealth = currentHealth + data2.obj.health
                    table.insert(currentTbl, data2.obj)
                end
            end

            if currentCount > maxCount
            then
                maxCount = currentCount
                bestPos = objPredPos
                bestHealth = currentHealth
                bestTbl = currentTbl
            end
        end

        if maxCount >= minion
        then
            return bestPos, bestTbl, bestHealth
        end
    else
        return vec3(0, 0, 0), {}, 0
    end
end

--Maybe bad
--  now shouldn't be bad
function utils:get_list(list_name)
    local list = {}

    local Obj = objManager.minions[list_name]
    local Obj_size = objManager.minions.size[list_name]

    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if utils:is_valid(obj)
        then
            table.insert(list, obj)
        end
    end

    return { unpack(list) }
end

function utils:get_allies(b_ignore_self)
    local list = {}

    for i = 0, objManager.allies_n - 1
    do
        local obj = objManager.allies[i]
        if obj and ((b_ignore_self ~= nil and b_ignore_self == false) or obj.networkID ~= player.networkID)
        then
            table.insert(list, obj)
        end
    end

    return { unpack(list) }
end

function utils:get_enemies()
    local list = {}

    for i = 0, objManager.enemies_n - 1
    do
        local obj = objManager.enemies[i]
        if obj
        then
            table.insert(list, obj)
        end
    end

    return { unpack(list) }
end

--You need to test the fps with it
--  tested on laneclear, jungleclear - fine
function utils:remove_if(t, condition)
    local i = 1
    while i <= #t
    do
        if condition(t[i])
        then
            table.remove(t, i)
        else
            i = i + 1
        end
    end
end

function utils:find_if(t, condition)
    for i = 1, #t
    do
        if (condition(t[i]))
        then
            return t[i]
        end
    end

    return nil
end

utils.ALT_GRADIENT_DARK = graphics.argb(255, 30, 39, 46)
utils.ALT_GRADIENT_LIGHT = graphics.argb(255, 223, 249, 251)
function utils:get_alt_gradient(color)
    local r = self:bit_rshift(self:bit_and(color, 0xFF0000), 16)
    local g = self:bit_rshift(self:bit_and(color, 0x00FF00), 8)
    local b = self:bit_and(color, 0x0000FF)

    local luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;

    return luminance < 0.5 and utils.ALT_GRADIENT_LIGHT or utils.ALT_GRADIENT_DARK
end

utils.circles = {}

function utils:get_dx11_shader_circle()
    local effect_description = [[
    cbuffer cbPerFrame {
        float4x4 Transform;
        float Is3D;
        float2 pos;
        float radius;

        float4 color;
        float4 color2;

        float lineWidth;
        float GlowWidth;
        float GlowFactor;

        float timer;
    };

    struct VS_INPUT
    {
        float4 Pos : POSITION;
        float4 Color : COLOR;
    };

    struct VS_OUTPUT
    {
        float4 Position : SV_POSITION;
        float4 Color : COLOR;
        float4 InputPosition : POSITION;
    };

    VS_OUTPUT VS(VS_INPUT input)
    {
        VS_OUTPUT output;
        output.Position = mul(input.Pos, Transform);
        output.Color = input.Color;
        output.InputPosition = input.Pos;  // as backup

        return output;
    }

    float4 PS(VS_OUTPUT input) : SV_TARGET
    {
        float4 output = (float4)0;
        float4 v = input.InputPosition;

        float dist = distance(Is3D ? v.xz : v.xy, pos);

        float innerRadius = radius - lineWidth / 2;
        float outerRadius = radius + lineWidth / 2;

        if (dist < innerRadius || dist > outerRadius + GlowWidth)
            discard;

        float edgeDist = abs(dist - radius);

        float innerIntensity = 1.0f - saturate(edgeDist / (lineWidth / 2));
        float outerIntensity = pow(1.0f - saturate(edgeDist / GlowWidth), GlowFactor);
        float intensity = lerp(innerIntensity, outerIntensity, saturate((dist - innerRadius) / GlowWidth));

        float2 dir = normalize(input.Position.xy - v.xy);
        float angle = atan2(dir.y, dir.x) * (1.0 / (2.0 * 3.14159)) + 0.5;

        float gradient = abs(sin((angle + timer) * 3.14159));
        float4 finalColor = lerp(color, color2, gradient * 0.9);
        finalColor.a *= intensity;

        return finalColor;
    }

    DepthStencilState DisableDepth
    {
        DepthEnable = FALSE;
        DepthWriteMask = ALL;
        DepthFunc = LESS_EQUAL;
    };

    BlendState MyBlendState
    {
        BlendEnable[0] = TRUE;
        SrcBlend[0] = SRC_ALPHA;
        DestBlend[0] = INV_SRC_ALPHA;
        BlendOp[0] = ADD;
        SrcBlendAlpha[0] = ONE;
        DestBlendAlpha[0] = ZERO;
        BlendOpAlpha[0] = ADD;
        RenderTargetWriteMask[0] = 0x0F;
    };

    technique11 Movement
    {
        pass P0 {
            SetVertexShader(CompileShader(vs_5_0, VS()));
            SetGeometryShader(NULL);
            SetPixelShader(CompileShader(ps_5_0, PS()));

            SetDepthStencilState(DisableDepth, 0);
            SetBlendState(MyBlendState, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
        }
    }
]]

    return effect_description
end

function utils:draw_circle(name, _pos_or_obj, radius, color1, color2, _alpha)
    if not self.circles[name]
    then
        self.circles[name] = shadereffect.construct(utils:get_dx11_shader_circle(), true)
    end

    if not radius then return end

    local color2 = color2 or color1 --utils:get_alt_gradient( color1 )

    local pos = _pos_or_obj.x and _pos_or_obj or _pos_or_obj.pos

    if _alpha ~= nil
    then
        color1 = self:set_alpha(color1, _alpha)
        color2 = self:set_alpha(color2, _alpha)
    end

    shadereffect.begin(self.circles[name], pos.y, true)
    shadereffect.set_float(self.circles[name], 'Is3D', 1)
    shadereffect.set_float(self.circles[name], 'radius', radius)
    shadereffect.set_float(self.circles[name], 'lineWidth', 7.0)
    shadereffect.set_float(self.circles[name], 'GlowWidth', 45.0)
    shadereffect.set_float(self.circles[name], 'GlowFactor', 5) --5

    shadereffect.set_vec2(self.circles[name], 'pos', vec2(pos.x, pos.z))
    shadereffect.set_color(self.circles[name], 'color', color1)
    shadereffect.set_color(self.circles[name], 'color2', color2)

    shadereffect.set_float(self.circles[name], 'timer', game.time * (3 / 10))

    if not _pos_or_obj.x
    then
        shadereffect:attach(_pos_or_obj)
    end

    shadereffect.draw(self.circles[name])
end

utils.rounded_rectangles = {}

function utils:get_dx11_shader_rounded_rect()
    local effect_description = [[
        cbuffer cbPerFrame {
            float4x4 Transform;
            float2 pos;
            float2 size;  // Rectangle size (width and height)
            float radius;
            float4 color;
        };

        struct VS_INPUT
        {
            float4 Pos : POSITION;
            float4 Color : COLOR;
        };

        struct VS_OUTPUT
        {
            float4 Position : SV_POSITION;
            float4 Color : COLOR;
        };

        VS_OUTPUT VS(VS_INPUT input)
        {
            VS_OUTPUT output;
            output.Position = mul(input.Pos, Transform);
            output.Color = input.Color;

            return output;
        }

        float4 PS(VS_OUTPUT input) : SV_TARGET
        {
            float4 output = color;  // Set the output color to the specified color
            float2 v = input.Position.xy;

            // Calculate distance from the rounded rectangle edges
            float2 halfSize = size * 0.5;
            float2 d = abs(v - pos) - halfSize + float2(radius, radius);
            float dist = length(max(d, 0.0));

            // Set alpha to 0.0 outside the rounded rectangle
            if (dist > radius)
            {
                output.a = 0.0;
            }

            return output;
        }

        DepthStencilState DisableDepth
        {
            DepthEnable = FALSE;
            DepthWriteMask = ALL;
            DepthFunc = LESS_EQUAL;
        };

        BlendState MyBlendState
        {
            BlendEnable[0] = TRUE;
            SrcBlend[0] = SRC_ALPHA;
            DestBlend[0] = INV_SRC_ALPHA;
            BlendOp[0] = ADD;
            SrcBlendAlpha[0] = ONE;
            DestBlendAlpha[0] = ZERO;
            BlendOpAlpha[0] = ADD;
            RenderTargetWriteMask[0] = 0x0F;
        };

        technique11 Movement
        {
            pass P0 {
                SetVertexShader(CompileShader(vs_5_0, VS()));
                SetGeometryShader(NULL);
                SetPixelShader(CompileShader(ps_5_0, PS()));

                SetDepthStencilState(DisableDepth, 0);
                SetBlendState(MyBlendState, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
            }
        }
    ]]

    return effect_description
end

function utils:draw_rounded_rect(name, v_pos, v_size, radius, clr)
    if not self.rounded_rectangles[name] then
        self.rounded_rectangles[name] = shadereffect.construct(self:get_dx11_shader_rounded_rect(), false)
    end

    shadereffect.begin(self.rounded_rectangles[name], 0, false)
    shadereffect.set_vec2(self.rounded_rectangles[name], 'pos', v_pos + v_size / 2)
    shadereffect.set_vec2(self.rounded_rectangles[name], 'size', v_size)
    shadereffect.set_float(self.rounded_rectangles[name], 'radius', radius)
    shadereffect.set_color(self.rounded_rectangles[name], 'color', clr)
    shadereffect.draw(self.rounded_rectangles[name])
end

function utils:tick()
    self.flash_ready = self.flash_slot ~= -1 and player:spellSlot(self.flash_slot).state == 0 and
        player:spellSlot(self.flash_slot).hash == game.spellhash("SummonerFlash")

    self.time_until_next_aa = math.max(0, self.next_aa_t - game.time)
    utils.orb_t = orb.combat.target
    if game.time > self.last_aa_target_t and self.last_aa_target then
        self.last_aa_target = nil
    end
    self.selector_t = game.selectedTarget

    if game.time > start_time + 1 and print_check == false then
        print_check = true
        chat.clear()
        chat.add('  Telegram: ', { color = '#81ecec', bold = true })
        chat.add('KleeAIO', { color = '#ffffff', bold = true })
        chat.print()

        chat.clear()
        chat.add('  Discord: ', { color = '#a29bfe', bold = true })
        chat.add('klee_aio', { color = '#ffffff', bold = true })
        chat.print()

        chat.clear()
        chat.add('  Discord: ', { color = '#a29bfe', bold = true })
        chat.add('loveltrs', { color = '#ffffff', bold = true })
        chat.print()

        chat.clear()
        chat.add('  QQ: ', { color = '#ffeaa7', bold = true })
        chat.add('362547971', { color = '#ffffff', bold = true })
        chat.print()
        chat.clear()
    end
end

function utils:slow_tick()

end

utils.TICK = 1 / 30
function utils:process_spell(spell)
    if not spell or player.isDead then return end

    if spell.owner and spell.owner == player and spell.isBasicAttack then
        self.last_aa_target = spell.target
        self.last_aa_target_t = game.time + 2

        self.before_aa_t = game.time + 0.04
        self.next_aa_t = game.time + player:attackDelay() - network.latency

        self.last_aa_time = game.time - network.latency
        self.last_aa_time_end_cast = game.time - network.latency + player:attackCastDelay(64)
        self.last_aa_time_end = game.time - network.latency + player:attackDelay()
    end
    --spell.target
end

function utils:in_attack(fl_extra_windup)
    return game.time <= self.last_aa_time_end_cast + (fl_extra_windup ~= nil and fl_extra_windup or 0) --or utils.TICK
end

function utils:should_reset_aa(fl_extra_windup, fl_min_remaining_t)
    if game.time >= self.last_aa_time_end
    then
        return false
    end

    return self.last_aa_time_end - game.time >= (fl_min_remaining_t ~= nil and fl_min_remaining_t or 0)
end

local tbl_lasthitted = {}
function utils:issue_order(args)
    if (args.order == 3 or args.order == 5) and args.target and args.target.isLaneMinion
    then
        local hit_time = player:attackCastDelay(64)
        if player.isRanged then
            hit_time = hit_time +
                math.max(player.pos:dist(args.target.pos) - args.target.boundingRadius, 0) /
                orb.utility.get_missile_speed(player)
        end
        local health = orb.farm.predict_hp(args.target, hit_time + 0.05)
        if health - damage.calc_aa_damage(player, args.target, false) * 1.15 <= 0
        then
            tbl_lasthitted[args.target.networkID] = { time = game.time, lethal = true }
            --print( "lasthitted: t: ["..tostring( hit_time ).."] hp: ["..tostring( health ).."]" )
        end
    end
end

function utils:is_minion_lasthitted(obj)
    if tbl_lasthitted[obj]
    then
        return game.time - tbl_lasthitted[obj].time <= 5 and tbl_lasthitted[obj].lethal
    end
    return false
end

function utils:on_draw()

end

function utils:init()
    --dmg_lib:load( )
    self:load()
    ts:load(utils)
    self.ts = ts

    local tick_function = self.on_slow_tick(5, function() self:slow_tick() end)
    cb.add(cb.tick, tick_function)

    cb.add(cb.tick, function() self:tick() end)
    cb.add(cb.spell, function(...) self:process_spell(...) end)
    cb.add(cb.issue_order, function(...) self:issue_order(...) end)

    --#region sums
    for i = 4, 5
    do
        if player:spellSlot(i).hash == game.spellhash("SummonerFlash") or
            player:spellSlot(i).hash == game.spellhash("SummonerFlashPerksHextechFlashtraptionV2")
        then
            self.flash_slot = i
        end
    end
    --#endregion

    local function after_attack()
        self.after_aa_t = game.time + 0.04
        orb.combat.set_invoke_after_attack(false)
    end
    orb.combat.register_f_after_attack(after_attack)

    start_time = game.time + 1

    local Obj2 = objManager
    local Obj2_size = objManager.maxObjects
    for i = 0, Obj2_size - 1 do
        local obj = Obj2.get(i)
        if obj then
            if obj.name == "Turret_ChaosTurretShrine_A" then
                if player.team == 200 then
                    self.ally_nexus_obelisk = vec3(obj.pos.x, 95, obj.pos.z)
                else
                    self.enemy_nexus_obelisk = vec3(obj.pos.x, 95, obj.pos.z)
                end
            elseif obj.name == "Turret_OrderTurretShrine_A" then
                if player.team == 200 then
                    self.enemy_nexus_obelisk = vec3(obj.pos.x, 95, obj.pos.z + 50)
                else
                    self.ally_nexus_obelisk = vec3(obj.pos.x, 95, obj.pos.z + 50)
                end
            end
        end
    end
end

local show_time = 10
local function on_draw_sprite()
    if game.time < start_time + show_time then
        -- 5 ~ 0
        local time = start_time + show_time - game.time
        local alpha = time > 2 and 255 or time / 2 * 255
        local color = utils:set_alpha(0xFFFFFFFF, alpha)
        local klee_pic = graphics.sprite('Resource/klee_pic.png')
        local update_pic = hanbot.language == 2 and graphics.sprite('Resource/update_en.png') or graphics.sprite('Resource/update_cn.png')
        graphics.draw_sprite(klee_pic, vec2(1400, 100), 0.6, color)
        graphics.draw_sprite(update_pic, vec2(1300, 350), 0.97, color)
    end
end

cb.add(cb.sprite, on_draw_sprite)

utils:init()
return utils
