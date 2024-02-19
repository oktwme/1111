--Akali Rell MonkeyKing Yone leesin
local Antigapcloser = {}

---@type utils
local utils = module.load(header.id, "Help/utils")
local myhero = player

local orb = module.internal("orb")
local pred = module.internal("pred")
local damage = module.internal("damage")
local ts = module.internal("ts")
local evade = module.internal("evade")

function Antigapcloser:tick()
    for i = #self.dash_data, 1, -1 do
        local dash_list = self.dash_data[i]
        local check_1 = dash_list.end_t ~= 0 and dash_list.end_t + 0.3 < game.time
        local check_2 = game.time - dash_list.start_t > 1
        if check_1 or check_2 then
            table.remove(self.dash_data, i)
        end
    end


    -- for i = #self.dash_data, 1, -1 do
    --     if self.dash_data[i].check == true then --and self.dash_data[i].gapcloser == true
    --         if self.dash_data[i].gapcloser == true then
    --             chat.print(self.dash_data[i].sender.charName .. ". gapcloser")
    --         else
    --             chat.print(self.dash_data[i].sender.charName .. ". not gapcloser")
    --         end
    --     end
    -- end
end

function Antigapcloser:process_spell(spell)
    if not spell or player.isDead then return end

    if not spell.owner or not spell.owner.team == TEAM_ENEMY then return end

    for _, champion_data in pairs(self.gapcloser_spell) do
        for _, spells in ipairs(champion_data) do
            if spell.name == spells.spell_name then
                table.insert(self.dash_data, {
                    check = false,
                    spell_name = spell.name,
                    sender = spell.owner,
                    start_t = game.time,
                    end_t = 0,
                    start_pos = vec3(0, 0, 0),
                    end_pos = vec3(0, 0, 0),
                    gapcloser = false,
                    targeted = spells.targeted
                })
            end
        end
    end
end

-- function Antigapcloser:before_aa(spell)
--     if not spell or myhero.isDead  then return end

--     if not spell.owner or not spell.owner.isEnemy then return end

--     for _, champion_data in pairs(self.gapcloser_spell) do
--         for _, spells in ipairs(champion_data) do
--             if spell.name == spells.spell_name then
--                 table.insert(self.dash_data, {
--                     check = false,
--                     spell_name = spell.name,
--                     sender = spell.owner,
--                     start_t = game.time,
--                     end_t = 0,
--                     start_pos = vec3(0, 0, 0),
--                     end_pos = vec3(0, 0, 0),
--                     gapcloser = false,
--                     targeted = spells.targeted
--                 })
--             end
--         end
--     end
-- end

function Antigapcloser:path(target)
    if not target or myhero.isDead then return end
    local path = target.path
    
    if not path or not path.isDashing or target.team ~= TEAM_ENEMY then return end
    
    for i = #self.dash_data, 1, -1 do
        if self.dash_data[i].sender and self.dash_data[i].sender == target and self.dash_data[i].end_t == 0 then
            local is_gapcloser = myhero.pos:dist(path.startPoint) > myhero.pos:dist(path.endPos) and
            utils:face(target, myhero.pos)

            self.dash_data[i].check = true
            self.dash_data[i].end_t = path.startPoint:dist(path.endPoint) / path.dashSpeed + game.time
            self.dash_data[i].start_pos = path.startPoint
            self.dash_data[i].end_pos = path.endPos
            self.dash_data[i].gapcloser = is_gapcloser
            
        end
    end

    -- for _, dash_list in pairs(self.dash_data) do

    --     if dash_list.sender and dash_list.sender == target then
    --         chat.print(target.charName)
    --     end
    -- end
end

function Antigapcloser:on_draw()
end

function Antigapcloser:init()
    self.gapcloser_spell = {
        ["Aatrox"] = {
            { spell_name = "AatroxE", slot = "E" },
        },
        ["Ahri"] = {
            { spell_name = "AhriR", slot = "R" },
        },
        ["Akali"] = {
            { spell_name = "AkaliE",  slot = "E" },
            { spell_name = "AkaliEb", slot = "E2" },
            { spell_name = "AkaliR",  slot = "R1", targeted = true },
            { spell_name = "AkaliRb", slot = "R2" },
        },
        ["Alistar"] = {
            { spell_name = "Headbutt", slot = "W", targeted = true, targeted_dis = 400 },
        },
        ["Caitlyn"] = {
            { spell_name = "CaitlynE", slot = "E" },
        },
        ["Camille"] = {
            { spell_name = "CamilleEDash2", slot = "E" },
        },
        ["Corki"] = {
            { spell_name = "CarpetBomb", slot = "W" },
        },
        ["Diana"] = {
            { spell_name = "DianaTeleport", slot = "E" },
        },
        ["Ekko"] = {
            { spell_name = "EkkoEAttack", slot = "E", targeted = true },
        },
        ["Fiora"] = {
            { spell_name = "FioraQ", slot = "Q" },
        },
        ["Fizz"] = {
            { spell_name = "FizzQ", slot = "Q", targeted = true, targeted_dis = 400 },
        },
        ["Galio"] = {
            { spell_name = "GalioE", slot = "E" },
        },
        ["Gnar"] = {
            { spell_name = "GnarE",    slot = "E" },
            { spell_name = "GnarBigE", slot = "E" },
        },
        ["Gragas"] = {
            { spell_name = "GragasE", slot = "E" },
        },
        ["Graves"] = {
            { spell_name = "GravesMove", slot = "E" },
        },
        ["Gwen"] = {
            { spell_name = "GwenE", slot = "E" },
        },
        ["Hecarim"] = {
            { spell_name = "HecarimRampAttack", slot = "E", targeted = true },
            { spell_name = "HecarimUlt",        slot = "R" },
        },
        ["Irelia"] = {
            { spell_name = "IreliaQ", slot = "Q", targeted = true, targeted_dis = 400 },
        },
        ["JarvanIV"] = {
            { spell_name = "JarvanIVDragonStrike", slot = "EQ" },
            { spell_name = "JarvanIVCataclysm",    slot = "R", targeted = true },
        },
        ["Jax"] = {
            { spell_name = "JaxLeapStrike", slot = "Q", targeted = true, targeted_dis = 200 },
        },
        ["Jayce"] = {
            { spell_name = "JayceToTheSkies", slot = "Q", targeted = true },
        },
        ["Kaisa"] = {
            { spell_name = "KaisaR", slot = "R" },
        },
        ["Kayn"] = {
            { spell_name = "KaynQ",        slot = "Q" },
            { spell_name = "KaynRJumpOut", slot = "R" },
        },
        ["Khazix"] = {
            { spell_name = "KhazixE",     slot = "E" },
            { spell_name = "KhazixELong", slot = "E" },
        },
        ["Kindred"] = {
            { spell_name = "KindredQ", slot = "Q" },
        },
        ["Kled"] = {
            { spell_name = "KledEDash", slot = "E" },
        },
        ["Leblanc"] = {
            { spell_name = "LeblancW",  slot = "W" },
            { spell_name = "LeblancRW", slot = "RW" },
        },
        ["LeeSin"] = {
            { spell_name = "BlindMonkQTwo", slot = "Q2", targeted = true, targeted_dis = 400 },
            { spell_name = "BlindMonkWOne", slot = "W" },
        },
        ["Leona"] = {
            { spell_name = "LeonaZenithBlade", slot = "E" },
        },
        ["Lillia"] = {
            { spell_name = "LilliaW", slot = "W" },
        },
        ["Lucian"] = {
            { spell_name = "LucianE", slot = "E" },
        },
        ["Malphite"] = {
            { spell_name = "UFSlash", slot = "R" },
        },
        ["Maokai"] = {
            { spell_name = "MaokaiW", slot = "W", targeted = true },
        },
        ["MonkeyKing"] = {
            { spell_name = "MonkeyKingNimbus", slot = "E", targeted = true },
        },
        ["Nidalee"] = {
            { spell_name = "Pounce", slot = "W" },
        },
        ["Ornn"] = {
            { spell_name = "OrnnE", slot = "E" },
        },
        ["Pantheon"] = {
            { spell_name = "PantheonW", slot = "W", targeted = true },
        },
        ["Poppy"] = {
            { spell_name = "PoppyE", slot = "E", targeted = true },
        },
        ["Pyke"] = {
            { spell_name = "PykeE", slot = "E" },
        },
        ["Qiyana"] = {
            { spell_name = "QiyanaE", slot = "E" },
        },
        ["Rakan"] = {
            { spell_name = "RakanW", slot = "W" },
        },
        ["Rammus"] = {
            { spell_name = "Tremors2", slot = "R" },
        },
        ["RekSai"] = {
            { spell_name = "RekSaiEBurrowed", slot = "E" },
        },
        ["Rell"] = {
            { spell_name = "RellW_Dismount", slot = "W" },
        },
        ["Renekton"] = {
            { spell_name = "RenektonSliceAndDice", slot = "E1" },
            { spell_name = "RenektonDice",         slot = "E2" },
        },
        ["Riven"] = {
            { spell_name = "RivenFeint", slot = "E" },
        },
        ["Samira"] = {
            { spell_name = "SamiraE", slot = "E", targeted = true, targeted_dis = 400 },
        },
        ["Sejuani"] = {
            { spell_name = "SejuaniQ", slot = "Q" },
        },
        ["Shen"] = {
            { spell_name = "ShenE", slot = "E" },
        },
        ["Shyvana"] = {
            { spell_name = "ShyvanaTransformLeap", slot = "R" },
        },
        ["Sylas"] = {
            { spell_name = "SylasW",  slot = "W", targeted = true },
            { spell_name = "SylasE2", slot = "E2" },
            { spell_name = "SylasE",  slot = "E" },
        },
        ["Talon"] = {
            { spell_name = "TalonQ", slot = "Q", targeted = true },
        },
        ["Tristana"] = {
            { spell_name = "TristanaW", slot = "W" },
        },
        ["Tryndamere"] = {
            { spell_name = "TryndamereE", slot = "E" },
        },
        ["Urgot"] = {
            { spell_name = "UrgotE", slot = "E" },
        },
        ["Vi"] = {
            { spell_name = "ViQ", slot = "Q" },
        },
        ["Viego"] = {
            { spell_name = "ViegoR", slot = "R" },
            { spell_name = "ViegoW", slot = "W" },
        },
        ["Volibear"] = {
            { spell_name = "VolibearR", slot = "R" },
        },
        ["XinZhao"] = {
            { spell_name = "XinZhaoEDash", slot = "E", targeted = true, targeted_dis = 250 },
        },
        ["Yasuo"] = {
            { spell_name = "YasuoEDash", slot = "E", targeted = true, targeted_dis = 300 },
        },
        ["Yone"] = {
            { spell_name = "YoneE", slot = "E" },
        },
        ["Zac"] = {
            { spell_name = "ZacE", slot = "E" },
        },
        ["Zed"] = {
            { spell_name = "ZedR", slot = "R" },
        },
        ["Zeri"] = {
            { spell_name = "ZeriE", slot = "E" },
        },
        ["Belveth"] = {
            { spell_name = "BelvethQ", slot = "Q" },
        },
        ["Nilah"] = {
            { spell_name = "NilahE", slot = "E", targeted = true, targeted_dis = 300 },
        },
    }

    self.dash_data = {
        check = false,
        spell_name = "",
        sender = nil,
        start_t = 0,
        end_t = 0,
        start_pos = vec3(0, 0, 0),
        end_pos = vec3(0, 0, 0),
        gapcloser = false,
        targeted = false
    }

    cb.add(cb.tick, function() self:tick() end)
    cb.add(cb.spell, function(...) self:process_spell(...) end)
    --cb.add(cb.auto_attack, function(spell) self:before_aa(spell) end)
    cb.add(cb.path, function(...) self:path(...) end)
    cb.add(cb.draw, function() self:on_draw() end)
end

Antigapcloser:init()
return Antigapcloser
