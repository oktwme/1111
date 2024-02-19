local utils = module.load(header.id, "Help/utils")

local my_name = "Viktor"

local dmg_lib = module.load(header.id, "Help/dmg_lib")
local spell_data = module.load(header.id, "Help/spell_database")
local damagelib = module.internal('damagelib')
local orb = module.internal('orb')
local pred = module.internal('pred')
local evade = module.seek('evade')

local mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name)
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
mymenu.combo_menu:boolean("qe", "Smooth Q->E", true)

mymenu.combo_menu:header("e_header", "E")
mymenu.combo_menu:boolean("e", "Use E", true)

mymenu.combo_menu:header("w_header", "W")

mymenu.combo_menu:header("r_header", "R")
--#endregion

--#region harass_menu
mymenu.harass_menu:header("q_header", "Q")
mymenu.harass_menu:boolean("q", "Use Q", true)
mymenu.harass_menu:boolean("qe", "Smooth Q->E", true)

mymenu.harass_menu:header("e_header", "E")
mymenu.harass_menu:boolean("e", "Use E", true)
--#endregion

--#region draw_menu
mymenu.draw_menu:header("draw_ranges_header", "Ranges")
mymenu.draw_menu:boolean("q_range", "Q range", true)
mymenu.draw_menu:boolean("w_range", "W range", false)
mymenu.draw_menu:boolean("e_range", "E range", true)
mymenu.draw_menu:boolean("r_range", "R range", false)

mymenu.draw_menu:header("draw_damage_header", "Damage")
mymenu.draw_menu:boolean("q_damage", "Draw Q", true)
mymenu.draw_menu:boolean("e_damage", "Draw E", true)
mymenu.draw_menu:boolean("r_damage", "Draw R", true)
mymenu.draw_menu:slider("aa_damage", "Draw AA", 1, 0, 5, 1)

mymenu.draw_menu:header("state", "State")
mymenu.draw_menu:boolean("sf", "SpellFarm", true)

mymenu.draw_menu:header("end_header", "")
--#endregion

--#region keys
mymenu:header("kys_header", "Keys")
mymenu:keybind("sf", "SpellFarm", nil, 'MMB')
mymenu:keybind("auto_e", "Auto E", nil, '0')
--#endregion

utils:menu_common(nil, { 255, 234, 167 }, nil, { 250, 177, 160 }, { 181, 52, 113 })

local Viktor = 
{ 
    e = 
    {
        pred = function( e_range )
            return {
                delay = 0.0,
                speed = 1050,
                width = 180,
                range = e_range,
                boundingRadiusMod = 0.0,
                collision = 
                {
                  wall = true,
                },
              }
        end 
    }
}

function Viktor:update_states()
    self.is_combo = orb.menu.combat.key:get()
    self.is_mixed = orb.menu.hybrid.key:get()
    self.is_laneclear = orb.menu.lane_clear.key:get() and mymenu.sf:get()
    self.is_fastclear = self.is_laneclear and orb.menu.lane_clear.panic_key:get()
    self.is_lasthit = self.is_laneclear or orb.menu.last_hit.key:get()
    self.is_flee = orb.menu.flee and orb.menu.flee.key and orb.menu.flee.key:get()

    self.is_under_turret = utils:in_enemy_turret(player.pos)

    --q
    self.q_range = 600
    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0

    --w
    self.w_range = 800
    self.w_level = player:spellSlot(1).level
    self.w_ready = self.w_level > 0 and player:spellSlot(1).state == 0

    --e
    self.e_range = 525
    self.e2_range = 700
    self.e_level = player:spellSlot(2).level
    self.e_ready = self.e_level > 0 and player:spellSlot(2).state == 0

    --r
    self.r_range = 700
    self.r_level = player:spellSlot(3).level
    self.r_ready = self.r_level > 0 and player:spellSlot(3).state == 0

    if not self.q_evolved or not self.w_evolved or not self.e_evolved
    then
        local buffs = player.buff
        for _, buff in pairs(buffs)
        do
            if buff.valid
            then
                local buff_name = buff.name:lower( )
                local viktor = string.find(buff_name, "viktor")
                local aug = string.find(buff_name, "aug")
                if viktor and aug
                then
                    buff_name = string.gsub(buff_name, "viktor", "")
                    buff_name = string.gsub(buff_name, "aug", "")

                    self.q_evolved = string.find(buff_name, "q")
                    self.w_evolved = string.find(buff_name, "w")
                    self.e_evolved = string.find(buff_name, "e")
                end
            end
        end

        if player.evolvePoints > 0
        then
            
        end
    end
end

function Viktor:q_collision( target )
    local pred_input = 
    {
        delay = 0.25,
        speed = 2000,
        width = 140,
        range = 1150,
        boundingRadiusModSource = 0,
        boundingRadiusModTarget = 1,
        collision = 
        {
          wall = true,
        },
    }

    local seg = pred.linear.get_prediction( pred_input, target )
    if not seg then return true end

    return pred.collision.get_prediction( pred_input, seg, target )
end

function Viktor:e_collision( from, seg, target )
    local seg2 = seg
    seg2.startPos = from.z and from:to2D( ) or from
    return pred.collision.get_prediction( self.e.pred( self.e2_range ), seg2, target )
end

Viktor.q_time = -20
function Viktor:logic_q( )
    if not self.q_ready then return end 

    if ( self.is_combo and mymenu.combo_menu.q:get( ) ) or ( self.is_mixed and mymenu.harass_menu.q:get( ) and not self.is_under_turret )
    then
        local target = utils:get_target( self.q_range, "AP", true )
        if target and ( not utils:in_attack( ) or not utils:has_special_aa( player ) ) and not self:q_collision( target )
        then
            player:castSpell( 'obj', 0, target )
            Viktor.q_time = game.time
            return
        end
    end
end

function Viktor:logic_e( )
    if not self.e_ready then return end

    local can_smooth_eq = ( ( not utils:has_buff( player, "ViktorPowerTransferReturn" ) or not utils.orb_t or ( utils.orb_t and utils.orb_t.type ~= TYPE_HERO ) ) and game.time - self.q_time >= 0.2 )

    if ( self.is_combo and mymenu.combo_menu.e:get( ) and ( can_smooth_eq or not mymenu.combo_menu.qe:get( ) ) ) or
        ( self.is_mixed and not self.is_under_turret and mymenu.harass_menu.e:get( ) and ( can_smooth_eq or not mymenu.harass_menu.qe:get( ) ) ) or 
        ( not self.is_under_turret and mymenu.auto_e:get( ) )
    then
        local target = utils:get_target( self.e_range + self.e2_range, "AP", false )
        if target
        then
            --short_e
            if target.pos:dist( player.pos ) <= self.e_range
            then
                local seg_aoe = nil
                local target_aoe = utils:get_target( self.e_range + self.e2_range, "AP", false, nil, function( v )
                    if v.networkID == target.networkID
                    then
                        return true
                    end
                    
                    if v.pos:dist( target.pos ) >= self.e2_range
                    then
                        return true
                    end

                    local seg = pred.linear.get_prediction( self.e.pred( self.e2_range ), v, target.pos )
                    if not seg or seg.endPos:dist( target.pos ) > self.e2_range + target.boundingRadius
                    then
                        return true
                    end

                    if self:e_collision( target.pos, seg, v )
                    then
                        return true
                    end

                    seg_aoe = seg

                    return false
                end )

                if target_aoe and seg_aoe
                then
                    player:castSpell('line', 2, target.pos, vec3(seg_aoe.endPos.x, target.pos.y, seg_aoe.endPos.y) )
                    return
                else
                    local pred_input = self.e.pred( self.e2_range )
                    pred_input.delay = ( pred_input.range / 2 ) / pred_input.speed
                    pred_input.speed = math.huge

                    local seg = pred.linear.get_prediction( pred_input, target, target.pos )
                    if seg and seg.endPos:dist( target.pos ) < self.e2_range + target.boundingRadius and not self:e_collision( target.pos, seg, target )
                    then
                        player:castSpell('line', 2, target.pos, vec3(seg.endPos.x, target.pos.y, seg.endPos.y) )
                        return
                    end
                end
            else
            --long_e
                local v_start = utils:extend_vec( player.pos, target.pos, self.e_range )
                local seg = pred.linear.get_prediction( self.e.pred( self.e2_range ), target, v_start )
                if seg and seg.endPos:dist( target.pos ) < self.e2_range + target.boundingRadius and not self:e_collision( v_start, seg, target )
                then
                    player:castSpell('line', 2, v_start, vec3(seg.endPos.x, target.pos.y, seg.endPos.y) )
                    return
                end
            end
        end
    end
end

function Viktor:on_tick( )
    if not player or player.isDead or player.isRecalling
    then
        return
    end

    self:update_states()

    --
    --  Logic
    --
    self:logic_q( )
    self:logic_e( )
end

function Viktor:on_draw( )
    if not player or player.isDead then return end

    if keyboard.isKeyDown(0x09) then return end

    if mymenu.draw_menu.q_range:get() and self.q_range and self.q_level > 0
    then
        utils:draw_circle("q_range", player.pos, self.q_range + player.boundingRadius, utils.menuc.drawdr_menu.clr_q:get(), nil,
            self.q_ready and 255 or 50)
    end

    if mymenu.draw_menu.w_range:get() and self.w_range and self.q_level > 0
    then
        utils:draw_circle("w_range", player.pos, self.w_range, utils.menuc.drawdr_menu.clr_w:get(), nil,
            self.w_ready and 255 or 50)
    end

    if mymenu.draw_menu.e_range:get() and self.e_range and self.e_level > 0
    then
        utils:draw_circle("e_range", player.pos, self.e_range + self.e2_range, utils.menuc.drawdr_menu.clr_e:get(), nil,
            self.e_ready and 255 or 50)
    end

    if mymenu.draw_menu.r_range:get() and self.r_range and self.r_level > 0
    then
        utils:draw_circle("r_range", player.pos, self.r_range, utils.menuc.drawdr_menu.clr_r:get(), nil,
            self.r_ready and 255 or 50)
    end
end

local function viktor_on_tick()
    Viktor:on_tick()
end

local function viktor_on_draw()
    Viktor:on_draw()
end

function Viktor:bind_callbacks(b_remove)
    if not b_remove
    then
        if self.b_callbacks_registered
        then
            return
        end

        cb.add(cb.tick, viktor_on_tick)
        cb.add(cb.draw, viktor_on_draw)

        self.b_callbacks_registered = true
    elseif b_remove and b_remove == true
    then
        cb.remove(cb.tick, viktor_on_tick)
        cb.remove(cb.draw, viktor_on_draw)

        self.b_callbacks_registered = false
    end
end

function Viktor:init(b_callbacks)
    if b_callbacks
    then
        self:bind_callbacks()
    end
end

return Viktor:init(true)