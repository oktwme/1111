---@type utils
local utils = module.load(header.id, "Help/utils")
local my_name = player.charName

local mymenu
if hanbot.language == 2 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name)
    mymenu:header(my_name, "Klee: " .. my_name)
    mymenu:set('icon', player.iconSquare)

    utils:menu_utils(mymenu)

    mymenu:menu("combo", "Combo")
    -- #region combo
    mymenu.combo:header("header_1", "Q")
    mymenu.combo:boolean("q", "Use Q", true)

    mymenu.combo:header("header_2", "W")
    mymenu.combo:boolean("w", "Use W", true)

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "Use E", true)

    mymenu.combo:header("header_4", "R")
    mymenu.combo:boolean("r", "Use R", true)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "Harass")
    -- #region harass
    mymenu.harass:header("header_1", "Q")
    mymenu.harass:boolean("q", "Use Q", true)

    mymenu.harass:header("header_2", "W")
    mymenu.harass:boolean("w", "Use W", true)

    mymenu.harass:header("header_3", "E")
    mymenu.harass:boolean("e", "Use E", true)

    mymenu.harass:header("header_4", "R")
    mymenu.harass:boolean("r", "Use R", true)

    mymenu.harass:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "Automatic")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "Killsteal", true)
    mymenu.auto:header("header_2", "W")
    mymenu.auto:boolean("w_ks", "Killsteal", true)
    mymenu.auto:header("header_3", "E")
    mymenu.auto:boolean("e_ks", "Killsteal", true)
    mymenu.auto:header("header_4", "R")
    mymenu.auto:boolean("r_ks", "Killsteal", true)
    mymenu.auto:header("header_5", "")
    -- #endregion

    mymenu:menu("lc", "Laneclear")
    -- #region laneclear
    mymenu.lc:header("header_1", "Laneclear")
    mymenu.lc:boolean("q_lc", "Laneclear Q", true)
    mymenu.lc:boolean("w_lc", "Laneclear W", true)
    mymenu.lc:boolean("e_lc", "Laneclear E", true)
    mymenu.lc:boolean("r_lc", "Laneclear R", true)
    mymenu.lc:header("header_2", "Jungle clear")
    mymenu.lc:boolean("q_jg", "Jungle Q", true)
    mymenu.lc:boolean("w_jg", "Jungle W", true)
    mymenu.lc:boolean("e_jg", "Jungle E", true)
    mymenu.lc:boolean("r_jg", "Jungle R", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("hc", "Hitchance")
    -- #region hitchance
    mymenu.hc:header("header_1", "Q")
    mymenu.hc:slider("q_range", "Range %", 100, 70, 100, 1)
    mymenu.hc:header("header_2", "W")
    mymenu.hc:slider("w_range", "Range %", 100, 70, 100, 1)
    mymenu.hc:header("header_3", "E")
    mymenu.hc:slider("e_range", "Range %", 100, 70, 100, 1)
    mymenu.hc:header("header_4", "R")
    mymenu.hc:slider("r_range", "Range %", 100, 70, 100, 1)
    mymenu.hc:header("header_5", "")
    --mymenu.hc:dropdown("w_hc", "Hitchance", 4, { "Low", "Mid", "High", "Very high" })
    -- #endregion

    mymenu:menu("dr", "Drawings")
    -- #region Drawings
    mymenu.dr:header("range", "Range")
    mymenu.dr:boolean("Q", "Draw Q", true)
    mymenu.dr:boolean("W", "Draw W", true)
    mymenu.dr:boolean("E", "Draw E", true)
    mymenu.dr:boolean("R", "Draw R", true)

    mymenu.dr:header("damage", "Damage")
    mymenu.dr:boolean("q_damage", "Draw Q", true)
    mymenu.dr:boolean("w_damage", "Draw W", true)
    mymenu.dr:boolean("e_damage", "Draw E", true)
    mymenu.dr:boolean("r_damage", "Draw R", true)
    mymenu.dr:slider("aa_damage", "Draw AA", 1, 0, 5, 1)

    mymenu.dr:header("state", "State")
    mymenu.dr:boolean("sf", "SpellFarm", true)
    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "Key")
    mymenu:keybind("sf", "SpellFarm", nil, 'MMB')
    mymenu:keybind("semi_w", "Semi W", 'T', nil)
    mymenu:header("header_end", "")
elseif hanbot.language == 1 then
    mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name)
    mymenu:header(my_name, "Klee: " .. my_name)
    mymenu:set('icon', player.iconSquare)

    utils:menu_utils(mymenu)

    mymenu:menu("combo", "连招")
    -- #region combo
    mymenu.combo:header("header_1", "Q")
    mymenu.combo:boolean("q", "使用Q", true)

    mymenu.combo:header("header_2", "W")
    mymenu.combo:boolean("w", "使用W", true)

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "使用E", true)

    mymenu.combo:header("header_4", "R")
    mymenu.combo:boolean("r", "使用R", true)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "骚扰")
    -- #region harass
    mymenu.harass:header("header_1", "Q")
    mymenu.harass:boolean("q", "使用Q", true)

    mymenu.harass:header("header_2", "W")
    mymenu.harass:boolean("w", "使用W", true)

    mymenu.harass:header("header_3", "E")
    mymenu.harass:boolean("e", "使用E", true)

    mymenu.harass:header("header_4", "R")
    mymenu.harass:boolean("r", "使用R", true)

    mymenu.harass:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "自动")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "捡人头", true)
    mymenu.auto:header("header_2", "W")
    mymenu.auto:boolean("w_ks", "捡人头", true)
    mymenu.auto:header("header_3", "E")
    mymenu.auto:boolean("e_ks", "捡人头", true)
    mymenu.auto:header("header_4", "R")
    mymenu.auto:boolean("r_ks", "捡人头", true)
    mymenu.auto:header("header_5", "")
    -- #endregion

    mymenu:menu("lc", "清线")
    -- #region laneclear
    mymenu.lc:header("header_1", "清兵")
    mymenu.lc:boolean("q_lc", "清兵Q", true)
    mymenu.lc:boolean("w_lc", "清兵W", true)
    mymenu.lc:boolean("e_lc", "清兵E", true)
    mymenu.lc:boolean("r_lc", "清兵R", true)
    mymenu.lc:header("header_2", "清野")
    mymenu.lc:boolean("q_jg", "清野Q", true)
    mymenu.lc:boolean("w_jg", "清野W", true)
    mymenu.lc:boolean("e_jg", "清野E", true)
    mymenu.lc:boolean("r_jg", "清野R", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("hc", "命中率")
    -- #region hitchance
    mymenu.hc:header("header_1", "Q")
    mymenu.hc:slider("q_range", "范围%", 100, 70, 100, 1)
    mymenu.hc:header("header_2", "W")
    mymenu.hc:slider("w_range", "范围%", 100, 70, 100, 1)
    mymenu.hc:header("header_3", "E")
    mymenu.hc:slider("e_range", "范围%", 100, 70, 100, 1)
    mymenu.hc:header("header_4", "R")
    mymenu.hc:slider("r_range", "范围%", 100, 70, 100, 1)
    mymenu.hc:header("header_5", "")
    --mymenu.hc:dropdown("w_hc", "Hitchance", 4, { "Low", "Mid", "High", "Very high" })
    -- #endregion

    mymenu:menu("dr", "绘制")
    -- #region Drawings
    mymenu.dr:header("range", "范围")
    mymenu.dr:boolean("Q", "绘制Q", true)
    mymenu.dr:boolean("W", "绘制W", true)
    mymenu.dr:boolean("E", "绘制E", true)
    mymenu.dr:boolean("R", "绘制R", true)

    mymenu.dr:header("damage", "伤害")
    mymenu.dr:boolean("q_damage", "绘制Q", true)
    mymenu.dr:boolean("w_damage", "绘制W", true)
    mymenu.dr:boolean("e_damage", "绘制E", true)
    mymenu.dr:boolean("r_damage", "绘制R", true)
    mymenu.dr:slider("aa_damage", "绘制普攻", 1, 0, 5, 1)
    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "快捷键")
    mymenu:keybind("sf", "发育", nil, 'MMB')
    mymenu:keybind("semi_w", "半手动W", 'T', nil)
    mymenu:header("header_end", "")
end


--mymenu = menu("Klee_" .. my_name, "Klee: " .. my_name .. " ( Klee )")

--local test = chat.print(my_name .. "A")
--q_menu.combo:set("texture", player.circleSprite)
--q_menu.combo:set("visible", true)
return mymenu
