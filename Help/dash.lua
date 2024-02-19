local dash = {}

dash.info = {
    ["Aatrox"] = {
        { spell_name = "AatroxE", slot = 2, name = "E", menu = true },
    },
    ["Ahri"] = {
        { spell_name = "AhriR", slot = 3, name = "R1", menu = false },
        { spell_name = "AhriR", slot = 3, name = "R2", menu = false },
        { spell_name = "AhriR", slot = 3, name = "R3", menu = true },
    },
    ["Akali"] = {
        { spell_name = "AkaliE",  slot = 2, name = "E",  menu = false },
        { spell_name = "AkaliEb", slot = 2, name = "E2", menu = true },
        { spell_name = "AkaliR",  slot = 3, name = "R",  menu = false },
        { spell_name = "AkaliRb", slot = 3, name = "R2", menu = true },
    },
    ["Alistar"] = {
        { spell_name = "Headbutt", slot = 1, name = "W", menu = true },
    },
    ["Caitlyn"] = {
        { spell_name = "CaitlynE", slot = 2, name = "E", menu = true },
    },
    ["Camille"] = {
        { spell_name = "CamilleEDash2", slot = 2, name = "E2", menu = true },
    },
    ["Corki"] = {
        { spell_name = "CarpetBomb",     slot = 1, name = "W", menu = true },
        { spell_name = "CarpetBombMega", slot = 1, name = "W", menu = true },
    },
    ["Diana"] = {
        { spell_name = "DianaTeleport", slot = 2, name = "E", menu = false },
    },
    ["Ekko"] = {
        { spell_name = "EkkoEAttack", slot = 2, name = "E", menu = true },
    },
    ["Fiora"] = {
        { spell_name = "FioraQ", slot = 0, name = "Q", menu = true },
    },
    ["Fizz"] = {
        { spell_name = "FizzQ", slot = 0, name = "Q", menu = false },
        { spell_name = "FizzE", slot = 2, name = "E", menu = true },
    },
    ["Galio"] = {
        { spell_name = "GalioE", slot = 2, name = "E", menu = true },
    },
    ["Gnar"] = {
        { spell_name = "GnarE",    slot = 2, name = "E",     menu = true },
        { spell_name = "GnarBigE", slot = 2, name = "Big E", menu = false },
    },
    ["Gragas"] = {
        { spell_name = "GragasE", slot = 2, name = "E", menu = true },
    },
    ["Graves"] = {
        { spell_name = "GravesMove", slot = 2, name = "E", menu = true },
    },
    ["Gwen"] = {
        { spell_name = "GwenE", slot = 2, name = "E", menu = true },
    },
    ["Hecarim"] = {
        { spell_name = "HecarimRampAttack", slot = 2, name = "E", menu = false },
        { spell_name = "HecarimUlt",        slot = 3, name = "R", menu = true },
    },
    ["Irelia"] = {
        { spell_name = "IreliaQ", slot = 0, name = "Q", menu = false },
    },
    ["JarvanIV"] = {
        { spell_name = "JarvanIVDragonStrike", slot = 0, name = "EQ", menu = true },
        { spell_name = "JarvanIVCataclysm",    slot = 3, name = "R",  menu = false },
    },
    ["Jax"] = {
        { spell_name = "JaxLeapStrike", slot = 0, name = "Q", menu = true },
    },
    ["Jayce"] = {
        { spell_name = "JayceToTheSkies", slot = 0, name = "Q", menu = false },
    },
    ["Kaisa"] = {
        { spell_name = "KaisaR", slot = 3, name = "R", menu = true },
    },
    ["Kayn"] = {
        { spell_name = "KaynQ",        slot = 0, name = "Q", menu = false },
        { spell_name = "KaynRJumpOut", slot = 3, name = "R", menu = false },
    },
    ["Khazix"] = {
        { spell_name = "KhazixE",     slot = 2, name = "E", menu = true },
        { spell_name = "KhazixELong", slot = 2, name = "E", menu = true },
    },
    ["Kindred"] = {
        { spell_name = "KindredQ", slot = 0, name = "Q", menu = true },
    },
    ["Kled"] = {
        { spell_name = "KledEDash", slot = 2, name = "E", menu = true },
    },
    ["Leblanc"] = {
        { spell_name = "LeblancW",  slot = 1, name = "W",  menu = false },
        { spell_name = "LeblancRW", slot = 3, name = "RW", menu = false },
    },
    ["LeeSin"] = {
        { spell_name = "BlindMonkQTwo", slot = 0, name = "Q2", menu = false },
        { spell_name = "BlindMonkWOne", slot = 1, name = "W",  menu = true },
    },
    ["Leona"] = {
        { spell_name = "LeonaZenithBlade", slot = 2, name = "E", menu = false },
    },
    ["Lillia"] = {
        { spell_name = "LilliaW", slot = 1, name = "W", menu = false },
    },
    ["Lucian"] = {
        { spell_name = "LucianE", slot = 2, name = "E", menu = true },
    },
    ["Malphite"] = {
        { spell_name = "UFSlash", slot = 3, name = "R", menu = true },
    },
    ["Maokai"] = {
        { spell_name = "MaokaiW", slot = 1, name = "W", menu = false },
    },
    ["MonkeyKing"] = {
        { spell_name = "MonkeyKingNimbus", slot = 2, name = "E", menu = true },
        { spell_name = "MonkeyKingDecoy",  slot = 1, name = "W", menu = true },
    },
    ["Nidalee"] = {
        { spell_name = "Pounce", slot = 1, name = "W", menu = true },
    },
    ["Ornn"] = {
        { spell_name = "OrnnE", slot = 2, name = "E", menu = true },
    },
    ["Pantheon"] = {
        { spell_name = "PantheonW", slot = 1, name = "W", menu = true },
    },
    ["Poppy"] = {
        { spell_name = "PoppyE", slot = 2, name = "E", menu = true },
    },
    ["Pyke"] = {
        { spell_name = "PykeE", slot = 2, name = "E", menu = true },
    },
    ["Qiyana"] = {
        { spell_name = "QiyanaE", slot = 2, name = "E", menu = true },
    },
    ["Rakan"] = {
        { spell_name = "RakanW", slot = 1, name = "W", menu = true },
    },
    ["Rammus"] = {
        { spell_name = "Tremors2", slot = 3, name = "R", menu = true },
    },
    ["RekSai"] = {
        { spell_name = "RekSaiEBurrowed", slot = 2, name = "E", menu = true },
    },
    ["Rell"] = {
        { spell_name = "RellW_Dismount", slot = 1, name = "W", menu = true },
    },
    ["Renekton"] = {
        { spell_name = "RenektonSliceAndDice", slot = 2, name = "E1", menu = false },
        { spell_name = "RenektonDice",         slot = 2, name = "E2", menu = true },
    },
    ["Riven"] = {
        { spell_name = "RivenFeint", slot = 2, name = "E", menu = false },
    },
    ["Samira"] = {
        { spell_name = "SamiraE", slot = 2, name = "E", menu = true },
    },
    ["Sejuani"] = {
        { spell_name = "SejuaniQ", slot = 0, name = "Q", menu = true },
    },
    ["Shen"] = {
        { spell_name = "ShenE", slot = 2, name = "E", menu = true },
    },
    ["Shyvana"] = {
        { spell_name = "ShyvanaTransformLeap", slot = 3, name = "R", menu = false },
    },
    ["Sylas"] = {
        { spell_name = "SylasW",  slot = 1, name = "W",  menu = false },
        { spell_name = "SylasE2", slot = 2, name = "E2", menu = true },
        { spell_name = "SylasE",  slot = 2, name = "E",  menu = false },
    },
    ["Talon"] = {
        { spell_name = "TalonQ", slot = 0, name = "Q", menu = false },
    },
    ["Tristana"] = {
        { spell_name = "TristanaW", slot = 1, name = "W", menu = true },
    },
    ["Tryndamere"] = {
        { spell_name = "TryndamereE", slot = 2, name = "E", menu = true },
    },
    ["Urgot"] = {
        { spell_name = "UrgotE", slot = 2, name = "E", menu = true },
    },
    ["Vi"] = {
        { spell_name = "ViQ", slot = 0, name = "Q", menu = true },
    },
    ["Viego"] = {
        { spell_name = "ViegoR", slot = 3, name = "R", menu = false },
        { spell_name = "ViegoW", slot = 1, name = "W", menu = true },
    },
    ["Volibear"] = {
        { spell_name = "VolibearR", slot = 3, name = "R", menu = true },
    },
    ["XinZhao"] = {
        { spell_name = "XinZhaoEDash", slot = 2, name = "E", menu = false },
    },
    ["Yasuo"] = {
        { spell_name = "YasuoEDash", slot = 2, name = "E", menu = false },
    },
    ["Yone"] = {
        { spell_name = "YoneE", slot = 2, name = "E1", menu = false },
        { spell_name = "YoneE", slot = 2, name = "E2", menu = true },
    },
    ["Zac"] = {
        { spell_name = "ZacE", slot = 2, name = "E", menu = true },
    },
    ["Zed"] = {
        { spell_name = "ZedW",  slot = 1, name = "W",  menu = false },
        { spell_name = "ZedW2", slot = 1, name = "W2", menu = true },
    },
    ["Zeri"] = {
        { spell_name = "ZeriE", slot = 2, name = "E", menu = true },
    },
    ["Belveth"] = {
        { spell_name = "BelvethQ", slot = 0, name = "Q", menu = true },
    },
    ["Nilah"] = {
        { spell_name = "NilahE", slot = 2, name = "E", menu = true },
    },
}

function dash:create_menu(menu)
    if not menu then return end
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n

    menu:header("dash_header", "Dash")
    menu:boolean("flee", "Only enemy flee", true)
    menu:boolean("jump_wall", "Follow jump wall", true)

    menu:header("dash_list_header", "Dash to")
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local enemy_name = enemy.charName
        local dash_data = dash.info[enemy_name]
        if dash_data then
            for _, data in ipairs(dash_data) do
                menu:boolean(enemy_name .. data.name, enemy_name .. data.name, data.menu)
                menu[enemy_name .. data.name]:set("icon", enemy.iconSquare)
            end
        end
        if enemy_name == "Akali" then
            menu:boolean("akali_w", "If Akali don't have W", true)
            menu.akali_w:set("icon", enemy.iconSquare)
        end
    end
end

local function on_tick()
end

cb.add(cb.buff_gain, on_buff_gain)
cb.add(cb.buff_lose, on_buff_lose)
cb.add(cb.attack_cancel, on_cancel_attack)
cb.add(cb.create_missile, on_create_missile)
cb.add(cb.delete_missile, on_delete_missile)
cb.add(cb.tick, on_tick)
cb.add(cb.spell, on_process_spell)
cb.add(cb.draw, on_draw)

return dash
