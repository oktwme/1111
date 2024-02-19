local KSante = {}

---@type utils
local utils = module.load(header.id, "Help/utils")
local my_name = player.charName

local mymenu
if hanbot.language == 2 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name .. " - Premium")
    mymenu:header(my_name, "Klee: " .. my_name .. " - Premium")

    mymenu:set("icon", player.iconSquare)

    utils:menu_utils(mymenu)

    mymenu:header("2", "Key")
    mymenu:keybind("semi_q", "Semi Q", 'Space', nil)

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

    mymenu:header("2", "¿ì½Ý¼ü")
    mymenu:keybind("semi_q", "Semi Q", 'Space', nil)

    mymenu:header("header_end", "")
end
local common = utils:menu_common()


local dmg_lib = module.load(header.id, "Help/dmg_lib")
local orb = module.internal('orb')
local pred = module.internal('pred')
local damagelib = module.internal('damagelib')
local ts = module.internal('TS')
local evade = module.seek('evade')

function KSante:load()
    self.is_laneclear = false

    self.Q123 = 0
    self.last_q_t = 0
    self.q_range = 0
    self.q_ready = false
    self.q_level = 0
    self.q_pred = {
        delay = 0.45,
        speed = 2000,
        width = 140,
        boundingRadiusMod = 1,
        range = self.q_range,
        collision = {
            minion = false,
            wall = false,
            hero = false,
        },
    }
end

function KSante:spell_check()
    if utils:has_buff(player, "KSanteQ3") then
        self.Q123 = 3
        self.q_pred.speed = 1600
        self.q_pred.width = 140
        self.q_range = 800
        self.q_pred.range = self.q_range
    else
        self.Q123 = 1
        self.q_pred.speed = math.huge
        self.q_pred.width = 150
        self.q_range = 465
        self.q_pred.range = self.q_range
    end
    self.q_pred.delay = 0

    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0
end

-- ///////////////////////////////////////////////////////////////////////////////////////////


local semi_q_loop = 0
function KSante:Semi_Q()
    if not self.q_ready or not mymenu.semi_q:get() then return end
    if semi_q_loop > game.time then return end

    local target = utils:get_target(self.q_range, "AD")
    if target then
        local seg = pred.linear.get_prediction(self.q_pred, target)
        if not seg then return end
        
        local cast_pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)

        player:castSpell('pos', _Q, cast_pos)
        semi_q_loop = game.time + 0.1
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function KSante:tick()
    if player.isDead then return end
    if player.activeSpell then return end

    self:Semi_Q()
    KSante:spell_check()
    -- print(orb.core.next_attack)
    -- print(orb.core.time_to_next_attack())
    -- print(orb.core.is_winding_up_attack())
end

function KSante:process_spell(spell)
    if not spell or player.isDead then return end

    if spell and spell.owner and spell.owner == player and spell.name then
        if (spell.name == "KSanteQ" or spell.name == "KSanteQ3") then
            self.q_pred.delay = spell.windUpTime
        end
        if spell.name == "KSanteEAllyDash" then
            orb.core.reset()
        end
    end
end

function KSante:init()
    self:load()

    cb.add(cb.tick, function() self:tick() end)
    cb.add(cb.spell, function(...) self:process_spell(...) end)
end

local function on_draw()
    graphics.draw_circle(player.pos, KSante.q_range, 2, 0xffffffff, 30)
end

cb.add(cb.draw, on_draw)

return KSante:init()
