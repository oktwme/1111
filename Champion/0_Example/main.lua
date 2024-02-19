local Example = {}

---@type utils
local utils = module.load(header.id, "Help/utils")
local dmg_lib = module.load(header.id, "Help/dmg_lib")
local mymenu = module.load(header.id, "Champion/" .. player.charName .. "/menu")

local common = utils:menu_common()

local orb = module.internal('orb')
local pred = module.internal('pred')
local damagelib = module.internal('damagelib')
local ts = module.internal('TS')
local evade = module.seek('evade')

function Example:load()
    self.is_combo = false
    self.is_mixed = false
    self.is_laneclear = false
    self.is_fastclear = false
    self.is_lasthit = false

    self.last_q_t = 0
    self.q_range = 0
    self.q_ready = false
    self.q_level = 0
    self.q_pred = {
        delay = 0.25,
        speed = 1200,
        width = 70,
        boundingRadiusMod = 1,
        range = 1100,
        collision = {
            minion = true,
            wall = true,
            hero = false,
        },
    }

    self.last_w_t = 0
    self.w_range = 0
    self.w_ready = false
    self.w_level = 0
    self.w_pred = {
        delay = 0.25,
        speed = 1200,
        width = 70,
        boundingRadiusMod = 1,
        range = 1100,
        collision = {
            minion = true,
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
        speed = 1200,
        width = 70,
        boundingRadiusMod = 1,
        range = 1100,
        collision = {
            minion = true,
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
        speed = 1200,
        width = 70,
        boundingRadiusMod = 1,
        range = 1100,
        collision = {
            minion = true,
            wall = true,
            hero = false,
        },
    }
end

function Example:spell_check()
    self.is_combo = orb.menu.combat.key:get()
    self.is_mixed = orb.menu.hybrid.key:get()
    self.is_laneclear = orb.menu.lane_clear.key:get() and mymenu.sf:get()
    --self.is_fastclear = orb.core.is_mode_active( OrbwalkingMode.LaneClear) and orb.farm.is_spell_clear_active() and orb.farm.is_fast_clear_enabled()
    self.is_lasthit = self.is_laneclear or orb.menu.last_hit.key:get()

    self.q_range = 1150 * mymenu.hc.q_range:get() / 100
    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0

    self.w_range = 1150 * mymenu.hc.w_range:get() / 100
    self.w_level = player:spellSlot(1).level
    self.w_ready = self.w_level > 0 and player:spellSlot(1).state == 0

    self.e_range = 1150 * mymenu.hc.e_range:get() / 100
    self.e_level = player:spellSlot(2).level
    self.e_ready = self.e_level > 0 and player:spellSlot(2).state == 0

    self.r_range = 1150 * mymenu.hc.r_range:get() / 100
    self.r_level = player:spellSlot(3).level
    self.r_ready = self.r_level > 0 and player:spellSlot(3).state == 0
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Example:Automatic()
    local can_ks = utils:use_automatic(mymenu.logic_menu.automatic_menu.ks_turret:get(),
        mymenu.logic_menu.automatic_menu.ks_grass:get(),
        mymenu.logic_menu.automatic_menu.ks_recall:get())
    local can_automatic = utils:use_automatic(mymenu.logic_menu.automatic_menu.turret:get(),
        mymenu.logic_menu.automatic_menu.grass:get(),
        mymenu.logic_menu.automatic_menu.recall:get())
end

function Example:Combo()
    if not self.is_combo then return end
end

function Example:Mixed()
    if not self.is_mixed then return end
end

function Example:Laneclear()
    if not self.is_laneclear then return end
end

function Example:FastLaneclear()
    if not self.is_fastclear then return end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Example:tick()
    if player.isDead then return end

    self:spell_check()

    self:Automatic()
    self:Combo()
    self:Mixed()
    self:Laneclear()
    self:FastLaneclear()

    -- print(orb.core.next_attack)
    -- print(orb.core.time_to_next_attack())
    -- print(orb.core.is_winding_up_attack())
end

function Example:slow_tick()
    if player.isDead then return end
end

function Example:process_spell(spell)
    if not spell or player.isDead then return end

    --print(spell.name)

    -- last_q_t
    -- last_w_t
    -- last_e_t
    -- last_r_t
end

function Example:finish_spell(spell)
    if not spell or player.isDead then return end
end

function Example:on_cast_spell(args)
    if not args or player.isDead then return end
    --print( args.spellSlot)
end

function Example:path(target)
    if not target or player.isDead then return end
end

local circle_q = graphics.create_effect(graphics.CIRCLE_GLOW)
local circle_w = graphics.create_effect(graphics.CIRCLE_GLOW)
local circle_r = graphics.create_effect(graphics.CIRCLE_GLOW)
function Example:new_draw()
    if player.isDead then return end

    if mymenu.dr.Q:get() then
        local color = self.q_ready and common.drawdr_menu.clr_q:get() or
            utils:set_alpha(common.drawdr_menu.clr_q:get(), 120)
        circle_q:update_circle(player.pos, self.q_range, 3, color)
    end
    if mymenu.dr.W:get() then
        local color = self.w_ready and common.drawdr_menu.clr_w:get() or
            utils:set_alpha(common.drawdr_menu.clr_w:get(), 120)
        circle_w:update_circle(player.pos, self.w_range, 3, color)
        minimap.draw_circle(player.pos, 3000, 1, color, 18)
    end
    if mymenu.dr.R:get() then
        local color = self.r_ready and common.drawdr_menu.clr_r:get() or
            utils:set_alpha(common.drawdr_menu.clr_r:get(), 120)
        circle_r:update_circle(player.pos, self.r_range, 3, color)
        minimap.draw_circle(player.pos, self.r_range, 1, color, 18)
    end

    local state_pos = player.pos + vec3(50, 0, -50)
    local p2d = graphics.world_to_screen(state_pos)
    local state_list = {
        { mymenu.sf:get() , mymenu.dr.sf:get(), "SpellFarm", "发育" }, --keyboard.isKeyDown(1)
    }
    for _, list in ipairs(state_list) do
        if list[2] == true and list[1] == true then
            local text = hanbot.language == 1 and list[4] or list[3]
            graphics.draw_text_2D(text, 30, p2d.x, p2d.y, 0XFFFFFFFF)
            p2d.y = p2d.y + 30
        end
    end
end

function Example:init()
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

return Example:init()
