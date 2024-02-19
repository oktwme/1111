local Kaisa = {}

--[[
    spell.data
    |-- menu
        |-- var
        |-- visible
        |-- parent
            |--
        |-- text
        |-- draw_enable
            |--
        |-- __type
        |-- selected
        |-- textSizes
            |--
        |-- danger_level
            |--
        |-- children
    |-- width
    |-- danger_level
    |-- add_bbox_width
    |-- menu_name
    |-- length
    |-- slot
    |-- speed
    |-- applies_on_hit
    |-- missile_names
        |-- {missile_names, ?}
    |-- spell_type
    |-- delay
    |-- collision
    |-- damage
    |-- update
    |-- fixed_range

]]

---@type utils
local utils = module.load(header.id, "Help/utils")
local dmg_lib = module.load(header.id, "Help/dmg_lib")


local orb = module.internal('orb')
local pred = module.internal('pred')
local damagelib = module.internal('damagelib')
local ts = module.internal('TS')
local evade = module.seek('evade')

local my_name = player.charName
local spell_data = module.load(header.id, "Help/spell_database")
local antigapcloser = module.load(header.id, "Help/anti_gapcloser")

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
    mymenu.combo:header("header_1", "Q")
    mymenu.combo:boolean("q", "Use Q", true)
    mymenu.combo:slider("q_c", " ^- Use Q <= x minions/monster", 2, 0, 6, 1)
    mymenu.combo:boolean("q_after_aa", " ^- Force Q after AA", true)
    mymenu.combo:boolean("q_cd", " ^- Navori Quickblades logic", true)

    mymenu.combo:header("header_2", "W")
    mymenu.combo:boolean("w", "Use W", true)
    mymenu.combo:boolean("w_after_aa", " ^- Force W after AA", true)
    mymenu.combo:boolean("w_p", " ^- Use W stack passive", true)
    mymenu.combo:boolean("w_sc", " ^- Save Check", false)
    mymenu.combo:slider("w_aa_block", " ^- Don't use W if target HP <= x AA", 0, 0, 5, 1)
    mymenu.combo:slider("w_as_block", " ^- Don't use W if AttackSpeed >= x/100", 250, 100, 300, 1)
    mymenu.combo:boolean("w_cd", " ^- Navori Quickblades logic", true)

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "Use E", true)
    mymenu.combo:boolean("e_general", " ^- General E", true)
    mymenu.combo:boolean("e_evolved", " ^- Evolved E", true)
    mymenu.combo:boolean("e_dont_waste", " ^- Avoid waste", true)
    mymenu.combo:boolean("e_cd", " ^- Navori Quickblades logic", true)

    local elements_q = { mymenu.combo.q_c, mymenu.combo.q_after_aa, mymenu.combo.q_cd }
    local elements_w = { mymenu.combo.w_after_aa, mymenu.combo.w_p, mymenu.combo.w_sc, mymenu.combo.w_aa_block,
        mymenu.combo.w_as_block, mymenu.combo.w_cd }
    local elements_e = { mymenu.combo.e_general, mymenu.combo.e_evolved, mymenu.combo.e_dont_waste, mymenu.combo.e_cd }
    utils:set_visible(elements_q, mymenu.combo.q:get())
    utils:set_visible(elements_w, mymenu.combo.w:get())
    utils:set_visible(elements_e, mymenu.combo.e:get())
    mymenu.combo.q:set('callback', function(old, new) utils:hide_menu(elements_q, true, old, new) end)
    mymenu.combo.w:set('callback', function(old, new) utils:hide_menu(elements_w, true, old, new) end)
    mymenu.combo.e:set('callback', function(old, new) utils:hide_menu(elements_e, true, old, new) end)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "Harass")
    -- #region harass
    mymenu.harass:header("header_1", "Q")
    mymenu.harass:slider("q", "Use Q if Mana >= x % ( 100 = Disable )", 0, 0, 100, 1)
    mymenu.harass:slider("q_c", " ^- Use Q <= x minions/monster", 2, 0, 6, 1)
    mymenu.harass:boolean("q_after_aa", " ^- Force Q after AA", true)

    mymenu.harass:header("header_2", "W")
    mymenu.harass:slider("w", "Use W if Mana >= x % ( 100 = Disable )", 0, 0, 100, 1)

    local elements_q = { mymenu.harass.q_c, mymenu.harass.q_after_aa }
    utils:set_visible(elements_q, mymenu.harass.q:get() < 100)
    mymenu.harass.q:set('callback',
        function(old, new) utils:hide_menu(elements_q, mymenu.harass.q:get() < 100, old, new) end)

    mymenu.harass:header("header_3", "")
    -- #endregion

    mymenu:menu("auto", "Automatic")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "Killsteal", true)
    mymenu.auto:boolean("q_alone", "Isolated", true)
    mymenu.auto:boolean("q_alone_no_q", " ^- Don't use if R", true)
    mymenu.auto:header("header_2", "W")
    mymenu.auto:boolean("w_ks", "Killsteal", true)
    mymenu.auto:boolean("w_cancel", "Try to cancel animation", true)

    mymenu.auto:header("header_3", "E dodge")
    local e_count = 0

    for i = 0, objManager.enemies_n - 1 do
        local champion = objManager.enemies[i]
        local hero_name = champion.charName
        local hero_data = spell_data[hero_name]
        if hero_data then
            for _, spell in ipairs(hero_data) do
                e_count = e_count + 1
                local skill_shot = spell.target
                if skill_shot == true then
                    local menu_tab = mymenu.auto["e_" .. hero_name]
                    if not menu_tab then
                        mymenu.auto:menu("e_" .. hero_name, hero_name)
                    end
                    mymenu.auto["e_" .. hero_name]:slider(spell.name,
                        hero_name .. " " .. spell.Spell .. " " .. "  Hp <= x", spell.menu, 0, 100, 1)
                end
            end
        end
    end
    if e_count == 0 then
        mymenu.auto:header("e_data", "No data")
    end

    mymenu.auto:header("header_4", "R dodge")
    local r_count = 0
    for i = 0, objManager.enemies_n - 1 do
        local champion = objManager.enemies[i]
        local hero_name = champion.charName
        local hero_data = spell_data[hero_name]
        if hero_data then
            for _, spell in ipairs(hero_data) do
                r_count = r_count + 1
                local skill_shot = spell.skillshot
                if skill_shot == true then
                    local menu_tab = mymenu.auto["r_" .. hero_name]
                    if not menu_tab then
                        mymenu.auto:menu("r_" .. hero_name, hero_name)
                    end
                    mymenu.auto["r_" .. hero_name]:slider(spell.name,
                        hero_name .. " " .. spell.Spell .. " " .. "Health <=", spell.menu, 0, 100, 1)
                end
            end
        end
    end
    if r_count == 0 then
        mymenu.auto:header("r_data", "No data")
    end

    mymenu.auto:header("header_5", "R")
    mymenu.auto:dropdown("save_logic", "Save logic", 3,
        { "Disable", "Near Ally", "Closer distance", "Longer distance", "Near mouse" })
    mymenu.auto:boolean("RW", "R->W logic", true)
    mymenu.auto:boolean("RE", "R->E logic", false)
    mymenu.auto:header("header_6", "General")
    mymenu.auto:slider("stack", "Force hit x stack ( 0 = Disable )", 3, 0, 4, 1)
    mymenu.auto:dropdown("auto_evolve", "Auto evolve", 1, { "E", "B" })
    mymenu.auto:header("header_7", "")
    -- #endregion

    mymenu:menu("lc", "Laneclear")
    -- #region laneclear
    mymenu.lc:header("header_0", "Laneclear")
    mymenu.lc:slider("q_minion", "Minion Q <= x ( 0 = Disable )", 0, 0, 6, 1)
    mymenu.lc:slider("q_minion_kill", "Q can kill minion >= x ( 0 = Disable )", 3, 0, 6, 1)
    mymenu.lc:header("header_1", "Jungle clear")
    mymenu.lc:boolean("q_monster", "Jungle Q", true)
    mymenu.lc:boolean("w_monster", "Jungle W", true)
    mymenu.lc:header("header_2", "")
    -- #endregion

    mymenu:menu("hc", "Hitchance")
    -- #region hitchance
    mymenu.hc:header("header_1", "Q")
    mymenu.hc:slider("q_range", "Range %", 100, 70, 100, 1)
    mymenu.hc:header("header_2", "W")
    mymenu.hc:boolean("w_high", "High hitrate", false)
    mymenu.hc:slider("w_range", "Range %", 100, 70, 100, 1)
    mymenu.hc:header("header_5", "")
    -- #endregion

    mymenu:menu("dr", "Drawings")
    -- #region Drawings
    mymenu.dr:header("range", "Range")
    mymenu.dr:boolean("Q", "Draw Q", true)
    mymenu.dr:boolean("W", "Draw W", true)
    mymenu.dr:boolean("R", "Draw R", true)

    mymenu.dr:header("damage", "Damage")
    mymenu.dr:dropdown("dmg_type", "Draw type", 1, { "Klee", "Default", "Disable" })
    mymenu.dr:boolean("p_damage", "Draw P", true)
    mymenu.dr:boolean("q_damage", "Draw Q", true)
    mymenu.dr:boolean("w_damage", "Draw W", true)
    mymenu.dr:slider("aa_damage", "Draw AA", 1, 0, 5, 1)

    local function hide_dd_menu()
        mymenu.dr.p_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.q_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.w_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.aa_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
    end
    hide_dd_menu()
    mymenu.dr.dmg_type:set('callback', hide_dd_menu)

    mymenu.dr:header("state", "State")
    mymenu.dr:boolean("sf", "SpellFarm", true)
    mymenu.dr:boolean("semi_w", "Semi W", true)

    mymenu.dr:header("other", "Other")
    mymenu.dr:boolean("p_state", "Draw P", true)

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
    mymenu.combo:header("header_1", "Q")
    mymenu.combo:boolean("q", "使用Q", true)
    mymenu.combo:slider("q_c", " ^- 使用Q <= x 小兵/野怪", 2, 0, 6, 1)
    mymenu.combo:boolean("q_after_aa", " ^- 强制普攻后Q", true)
    mymenu.combo:boolean("q_cd", " ^- 讯刃逻辑", true)

    mymenu.combo:header("header_2", "W")
    mymenu.combo:boolean("w", "使用W", true)
    mymenu.combo:boolean("w_after_aa", " ^- 强制普攻后W", true)
    mymenu.combo:boolean("w_p", " ^- 使用W爆被动", true)
    mymenu.combo:boolean("w_sc", " ^- 安全检查", false)
    mymenu.combo:slider("w_aa_block", " ^- 不要使用W如果目标生命 <= x 普攻", 0, 0, 5, 1)
    mymenu.combo:slider("w_as_block", " ^- 不要使用W如果攻击速度 >= x/100", 250, 100, 300, 1)
    mymenu.combo:boolean("w_cd", " ^- 讯刃逻辑", true)

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "使用E", true)
    mymenu.combo:boolean("e_general", " ^- 一般E", true)
    mymenu.combo:boolean("e_evolved", " ^- 进化E", true)
    mymenu.combo:boolean("e_dont_waste", " ^- 避免浪费", true)
    mymenu.combo:boolean("e_cd", " ^- 讯刃逻辑", true)

    local elements_q = { mymenu.combo.q_c, mymenu.combo.q_after_aa, mymenu.combo.q_cd }
    local elements_w = { mymenu.combo.w_after_aa, mymenu.combo.w_p, mymenu.combo.w_sc, mymenu.combo.w_aa_block,
        mymenu.combo.w_as_block, mymenu.combo.w_cd }
    local elements_e = { mymenu.combo.e_general, mymenu.combo.e_evolved, mymenu.combo.e_dont_waste, mymenu.combo.e_cd }
    utils:set_visible(elements_q, mymenu.combo.q:get())
    utils:set_visible(elements_w, mymenu.combo.w:get())
    utils:set_visible(elements_e, mymenu.combo.e:get())
    mymenu.combo.q:set('callback', function(old, new) utils:hide_menu(elements_q, true, old, new) end)
    mymenu.combo.w:set('callback', function(old, new) utils:hide_menu(elements_w, true, old, new) end)
    mymenu.combo.e:set('callback', function(old, new) utils:hide_menu(elements_e, true, old, new) end)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "骚扰")
    -- #region harass
    mymenu.harass:header("header_1", "Q")
    mymenu.harass:slider("q", "使用Q如果魔力 >= x % ( 100 = 禁用 )", 0, 0, 100, 1)
    mymenu.harass:slider("q_c", " ^- 使用Q <= x 小兵/野怪", 2, 0, 6, 1)
    mymenu.harass:boolean("q_after_aa", " ^- 强制普攻后Q", true)

    mymenu.harass:header("header_2", "W")
    mymenu.harass:slider("w", "使用W如果魔力 >= x % ( 100 = 禁用 )", 0, 0, 100, 1)

    local elements_q = { mymenu.harass.q_c, mymenu.harass.q_after_aa }
    utils:set_visible(elements_q, mymenu.harass.q:get() < 100)
    mymenu.harass.q:set('callback',
        function(old, new) utils:hide_menu(elements_q, mymenu.harass.q:get() < 100, old, new) end)

    mymenu.harass:header("header_3", "")
    -- #endregion

    mymenu:menu("auto", "自动")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "捡人头", true)
    mymenu.auto:boolean("q_alone", "孤立", true)
    mymenu.auto:boolean("q_alone_no_q", " ^- R时不使用", true)
    mymenu.auto:header("header_2", "W")
    mymenu.auto:boolean("w_ks", "捡人头", true)
    mymenu.auto:boolean("w_cancel", "尝试取消动画", true)

    mymenu.auto:header("header_3", "E格挡")
    local e_count = 0

    for i = 0, objManager.enemies_n - 1 do
        local champion = objManager.enemies[i]
        local hero_name = champion.charName
        local hero_data = spell_data[hero_name]
        if hero_data then
            for _, spell in ipairs(hero_data) do
                e_count = e_count + 1
                local skill_shot = spell.target
                if skill_shot == true then
                    local menu_tab = mymenu.auto["e_" .. hero_name]
                    if not menu_tab then
                        mymenu.auto:menu("e_" .. hero_name, hero_name)
                    end
                    mymenu.auto["e_" .. hero_name]:slider(spell.name,
                        hero_name .. " " .. spell.Spell .. " " .. "  Hp <= x", spell.menu, 0, 100, 1)
                end
            end
        end
    end
    if e_count == 0 then
        mymenu.auto:header("e_data", "没有资料")
    end

    mymenu.auto:header("header_4", "R格挡")
    local r_count = 0
    for i = 0, objManager.enemies_n - 1 do
        local champion = objManager.enemies[i]
        local hero_name = champion.charName
        local hero_data = spell_data[hero_name]
        if hero_data then
            for _, spell in ipairs(hero_data) do
                r_count = r_count + 1
                local skill_shot = spell.skillshot
                if skill_shot == true then
                    local menu_tab = mymenu.auto["r_" .. hero_name]
                    if not menu_tab then
                        mymenu.auto:menu("r_" .. hero_name, hero_name)
                    end
                    mymenu.auto["r_" .. hero_name]:slider(spell.name,
                        hero_name .. " " .. spell.Spell .. " " .. "Health <=", spell.menu, 0, 100, 1)
                end
            end
        end
    end
    if r_count == 0 then
        mymenu.auto:header("r_data", "没有资料")
    end

    mymenu.auto:header("header_5", "R")
    mymenu.auto:dropdown("save_logic", "安全逻辑", 3,
        { "禁止", "友军附近", "最近距离", "最远距离", "鼠标附近" })
    mymenu.auto:boolean("RW", "R->W 逻辑", true)
    mymenu.auto:boolean("RE", "R->E 逻辑", false)
    mymenu.auto:header("header_6", "一般")
    mymenu.auto:slider("stack", "强制普攻 x 层被动 ( 0 = 禁用 )", 3, 0, 4, 1)
    mymenu.auto:dropdown("auto_evolve", "自动进化", 1, { "E", "B" })
    mymenu.auto:header("header_7", "")
    -- #endregion

    mymenu:menu("lc", "清线")
    -- #region laneclear
    mymenu.lc:header("header_0", "清兵")
    mymenu.lc:slider("q_minion", "清兵Q <= x ( 0 = 禁用 )", 0, 0, 6, 1)
    mymenu.lc:slider("q_minion_kill", "Q可击杀小兵 >= x ( 0 = 禁用 )", 3, 0, 6, 1)
    mymenu.lc:header("header_1", "清野")
    mymenu.lc:boolean("q_monster", "清野Q", true)
    mymenu.lc:boolean("w_monster", "清野W", true)
    mymenu.lc:header("header_2", "")
    -- #endregion

    mymenu:menu("hc", "命中率")
    -- #region hitchance
    mymenu.hc:header("header_1", "Q")
    mymenu.hc:slider("q_range", "范围 %", 100, 70, 100, 1)
    mymenu.hc:header("header_2", "W")
    mymenu.hc:slider("w_range", "范围 %", 100, 70, 100, 1)
    mymenu.hc:boolean("w_high", "高命中率", false)
    mymenu.hc:header("header_5", "")
    -- #endregion

    mymenu:menu("dr", "绘制")
    -- #region Drawings
    mymenu.dr:header("range", "范围")
    mymenu.dr:boolean("Q", "绘制Q", true)
    mymenu.dr:boolean("W", "绘制W", true)
    mymenu.dr:boolean("R", "绘制R", true)

    mymenu.dr:header("damage", "伤害")
    mymenu.dr:dropdown("dmg_type", "绘制类型", 1, { "Klee", "预设", "关闭" })
    mymenu.dr:boolean("p_damage", "绘制被动", true)
    mymenu.dr:boolean("q_damage", "绘制Q", true)
    mymenu.dr:boolean("w_damage", "绘制W", true)
    mymenu.dr:slider("aa_damage", "绘制普攻", 1, 0, 5, 1)

    local function hide_dd_menu()
        mymenu.dr.p_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.q_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.w_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.aa_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
    end
    hide_dd_menu()
    mymenu.dr.dmg_type:set('callback', hide_dd_menu)

    mymenu.dr:header("state", "狀態")
    mymenu.dr:boolean("sf", "發育", true)
    mymenu.dr:boolean("semi_w", "半手动W", true)

    mymenu.dr:header("other", "其它")
    mymenu.dr:boolean("p_state", "绘制被动", true)

    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "快捷键")
    mymenu:keybind("sf", "发育", nil, 'MMB')
    mymenu:keybind("semi_w", "半手动W", 'T', nil)
    mymenu:header("header_end", "")
end
local common = utils:menu_common()

function Kaisa:Other()
    self.paa_t = 0

    self.is_combo = function()
        return orb.menu.combat.key:get()
    end
    self.is_mixed = function()
        return orb.menu.hybrid.key:get()
    end
    self.is_laneclear = function()
        return orb.menu.lane_clear.key:get() and mymenu.sf:get()
    end
    self.is_lasthit = function()
        return self.is_laneclear() or orb.menu.last_hit.key:get()
    end
    --self.is_fastclear = orb.core.is_mode_active( OrbwalkingMode.LaneClear) and orb.farm.is_spell_clear_active() and orb.farm.is_fast_clear_enabled()

    self.level_q = function()
        return player:spellSlot(0).level
    end
    self.ready_q = function()
        return self.level_q() > 0 and player:spellSlot(0).state == 0
    end

    self.level_w = function()
        return player:spellSlot(1).level
    end
    self.ready_w = function()
        return self.level_w() > 0 and player:spellSlot(1).state == 0
    end

    self.level_e = function()
        return player:spellSlot(2).level
    end
    self.ready_e = function()
        return self.level_e() > 0 and player:spellSlot(2).state == 0
    end

    self.level_r = function()
        return player:spellSlot(3).level
    end
    self.ready_r = function()
        return self.level_r() > 0 and player:spellSlot(3).state == 0
    end

    self.can_ks = function()
        return utils:use_automatic(mymenu.logic_menu.automatic_menu.ks_turret:get(),
            mymenu.logic_menu.automatic_menu.ks_grass:get(),
            mymenu.logic_menu.automatic_menu.ks_recall:get())
    end
    self.can_automatic = function()
        return utils:use_automatic(mymenu.logic_menu.automatic_menu.turret:get(),
            mymenu.logic_menu.automatic_menu.grass:get(),
            mymenu.logic_menu.automatic_menu.recall:get())
    end

    -- self.is_combo = false
    -- self.is_mixed = false
    -- self.is_laneclear = false
    -- self.is_fastclear = false
    -- self.is_lasthit = false

    self.last_q_t = 0
    self.range_q = 0
    -- self.ready_q() = false
    -- self.level_q() = 0
    self.pred_q = {
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
    self.range_w = 0
    -- self.ready_w() = false
    -- self.level_w() = 0
    self.pred_w = {
        delay = 0.4,
        speed = 1750,
        width = 100,
        range = self.range_w,
        boundingRadiusMod = 1,
        collision = {
            wall = true,
            minion = true,
            hero = true,
        },
    }

    self.last_e_t = 0
    self.range_e = 0
    -- self.ready_e() = false
    -- self.level_e() = 0


    self.last_r_t = 0
    self.range_r = 0
    -- self.ready_r() = false
    -- self.level_r() = 0

    self.count = 0
    self.p_stack = function(target)
        if target and utils:has_buff(target, "kaisapassivemarker") and target.buff["kaisapassivemarker"] then
            return target.buff["kaisapassivemarker"].stacks
            --utils:get_buff_count
        end
        return 87
    end
    self.q_evo = function()
        return utils:has_buff(player, "KaisaQEvolved")
    end
    self.w_evo = function()
        return utils:has_buff(player, "KaisaWEvolved")
    end
    self.e_evo = function()
        return utils:has_buff(player, "KaisaEEvolved")
    end
    self.e_as_buff = function()
        return utils:has_buff(player, "kaisaeattackspeed")
    end
    self.evo_t = 0

    self.r_dash = false
    self.r_dash_end_t = 0.0

    self.cast_e_dodge = 0

    self.have_cd_item = false
end

function Kaisa:spell_check()
    self.count = utils:count_enemy(player.pos, 665, 1, 1, 1, 1, 1, 1)

    if utils:has_buff(player, "kaisae") and player.buff["kaisae"].endTime - 0.1 > game.time then
        orb.core.set_pause_attack(0.05)
    end
    -- if self.r_dash == true and ((self.last_r_t + 0.1 < game.time and self.r_dash_end_t < game.time + 0.1) or self.last_r_t + 2 < game.time) then
    --     self.r_dash = false
    -- end
end

function Kaisa:load()
    self:Other()
end

function Kaisa:R_pos(menu, draw)
    if menu == 1 then return vec2(0, 0) end

    local my_pos = player.pos
    local all_pts = {}

    local function valid_target(target)
        return utils:is_valid(target) and self.p_stack(target) ~= 87
    end

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local target = Obj[i]

        if valid_target(target) then
            local t_pos = target.pos
            local t_pos_2d = t_pos:to2D()
            local circle = utils:circle_2d(t_pos_2d, 500, 8)

            for i = 1, #circle do
                local v_2d = circle[i]
                local v_3d = vec3(v_2d.x, t_pos.y, v_2d.y)

                if not navmesh.isWall(v_3d) and not utils:is_danger_2d_pos(v_2d) and
                    not utils:in_enemy_turret(v_3d) and v_3d:dist(my_pos) < self.range_r and
                    (menu ~= 2 or utils:count_ally_hero(v_3d, 300) > 0) then
                    local v_long = t_pos_2d + (v_2d - t_pos_2d):norm() * 900
                    local cone = utils:triangles_2d(t_pos_2d, v_long, 500)

                    local count = 0

                    local Obj1 = objManager.enemies
                    local Obj1_size = objManager.enemies_n
                    for i = 0, Obj1_size - 1 do
                        local enemy = Obj1[i]
                        if enemy and utils:is_valid(enemy) and utils:contains_2d(enemy.pos2D, cone) then
                            count = count + 1
                        end
                    end
                    if count < 1 then
                        all_pts[#all_pts + 1] = v_3d
                    end
                end
            end
        end
    end

    if menu == 2 and #all_pts == 0 then
        return vec2(0, 0)
    end

    local function sort_points_by_distance(a, b)
        if menu == 2 then
            return utils:count_ally_hero(a, 300) > utils:count_ally_hero(b, 300)
        elseif menu == 3 then
            return a:dist(my_pos) < b:dist(my_pos)
        elseif menu == 4 then
            return a:dist(my_pos) > b:dist(my_pos)
        elseif menu == 5 then
            return a:dist(mousePos) < b:dist(mousePos)
        end
    end

    table.sort(all_pts, sort_points_by_distance)
    local close_pos = all_pts[1]

    if close_pos and draw then
        graphics.draw_circle(close_pos, 30, 2, 0xFFFFFFFF, 3)
        for i = 1, #all_pts do
            local point = all_pts[i]
            graphics.draw_circle(point, 10, 2, 0xFFFFFFFF, 3)
        end
    end

    return close_pos
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

local q_loop = 0
local q_obj_loop = 0
function Kaisa:Q_logic()
    if not self.ready_q() then return end

    if game.time < q_loop then return end

    local ts_t = utils:get_target(self.range_q, "AD")

    local combo_q = self.is_combo() and mymenu.combo.q:get()
    local combo_q_c = mymenu.combo.q_c:get() >= self.count or mymenu.combo.q_c:get() == 6
    local combo_q_aa = utils.after_aa_t > game.time or not mymenu.combo.q_after_aa:get()
    local combo = combo_q and combo_q_c and combo_q_aa

    local mixed_q = self.is_mixed() and mymenu.harass.q:get() <= utils:get_mana_pre(player)
    local mixed_q_c = mymenu.harass.q_c:get() >= self.count or mymenu.harass.q_c:get() == 6
    local mixed_q_aa = utils.after_aa_t > game.time or not mymenu.harass.q_after_aa:get()
    local mixed = mixed_q and mixed_q_c and mixed_q_aa

    if ts_t and (combo or mixed) then
        player:castSpell('self', 0)
        q_loop = game.time + 0.1
        return
    end

    if game.time < q_obj_loop then return end
    q_obj_loop = game.time + 0.1

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local valid_enemy = utils:is_valid(enemy)
        local my_pos = player.pos
        local distance = enemy.pos:dist(my_pos) < self.range_q
        local ks = enemy.health < dmg_lib:Kaisa_Q(player, enemy) and mymenu.auto.q_ks:get() and
            self.can_ks()
        local q_enemy_c = self.count == 1
        local isol = q_enemy_c and mymenu.auto.q_alone:get() and (not mymenu.auto.q_alone_no_q:get() or not self.r_dash) and
            self.can_automatic()

        if valid_enemy and distance and (ks or isol) then
            player:castSpell('self', 0)
            q_loop = game.time + 1
            break
        end
    end
end

local w_loop = 0
local w_obj_loop = 0
function Kaisa:W_logic(draw)
    if not self.ready_w() then return end
    if utils:is_evade() then return end

    if game.time < w_loop then return end

    local target = utils:get_target(self.range_w, "AP")
    local orb_t = utils.orb_t
    if orb_t and utils:is_valid(orb_t) and orb_t.type == TYPE_HERO then
        target = orb_t
    end
    local target_c = target and utils:is_valid(target) and
        player.pos:dist(target.pos) < self.range_w

    local stack = self.p_stack(target)
    local active = player.activeSpell
    local range = target and player.pos:dist(target.pos)
    local in_aa = target and range <= player.boundingRadius + target.boundingRadius + player.attackRange

    local combo_w = self.is_combo() and mymenu.combo.w:get()
    local combo_w_aa = game.time < utils.after_aa_t or                   --or (target and not in_aa)
        (not mymenu.combo.w_after_aa:get() and not active and not in_aa) -- and (game.time + 0.3 <= utils.next_aa_t)
    local combo_stack = (self.w_evo() and stack >= 2 and stack ~= 87 or stack >= 3 and stack ~= 87) or
        (game.time < utils.after_aa_t and (self.w_evo() and stack >= 1 and stack ~= 87 or stack >= 2 and stack ~= 87)) or
        not mymenu.combo.w_p:get() -- or (target and not in_aa)
    local combo_sc = utils:save_check(player.pos, mymenu) or not mymenu.combo.w_sc:get()
    local aa_c = (target and utils:get_real_hp(target, true, false, true) > damagelib.calc_aa_damage(player, target, true) * mymenu.combo.w_aa_block:get()) or
        mymenu.combo.w_aa_block:get() == 0 or (target and not in_aa)
    local as_c = (target and in_aa and dmg_lib:as() * 100 < mymenu.combo.w_as_block:get()) or
        (target and not in_aa)
    local combo = combo_w and combo_w_aa and combo_stack and combo_sc and aa_c and as_c

    local mixed = self.is_mixed() and mymenu.harass.w:get() <= utils:get_mana_pre(player) and not active

    local r_w_combo = mymenu.auto.RW:get() and player.path.isDashing

    local use_semi_w = mymenu.semi_w:get()

    if target and target_c and (combo or mixed or use_semi_w or r_w_combo) then
        local seg = pred.linear.get_prediction(self.pred_w, target)
        if not seg then return end
        local col = pred.collision.get_prediction(self.pred_w, seg, target)
        if col then return end

        local pred_1 = pred.trace.linear.hardlock(self.pred_w, seg, target)
        local pred_2 = pred.trace.linear.hardlockmove(self.pred_w, seg, target)
        local pred_3 = pred.trace.newpath(target, 0.166666, 0.5) --and player.pos:dist(target.pos) < 600
        local pred_4 = not mymenu.hc.w_high:get()

        local cast_pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)

        if pred_1 or pred_2 or pred_3 or pred_4 then
            player:castSpell('pos', 1, cast_pos)
            w_loop = game.time + 0.5
            if draw then
                local poly = utils:rectangle_2d(player.pos2D, seg.endPos, 100)
                utils:draw_2d(poly, player.y, 0xFF00FF00)
                graphics.draw_circle(cast_pos, 100, 2, 0xFF00FF00, 36)
                graphics.draw_line_strip(target.path.point, 2, 0xFFFFFFFF, player.path.count + 1)
            end
        else
            if draw and cast_pos then
                local poly = utils:rectangle_2d(player.pos2D, seg.endPos, 100)
                utils:draw_2d(poly, player.y, 0xFFFF0000)
                graphics.draw_circle(cast_pos, 100, 2, 0xFFFF0000, 36)
                graphics.draw_line_strip(target.path.point, 2, 0xFFFFFFFF, player.path.count + 1)
            end
        end
    end

    if game.time < w_obj_loop then return end
    w_obj_loop = game.time + 0.1

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local stack = self.p_stack(enemy)
        local valid_enemy = utils:is_valid(enemy)
        local my_pos = player.pos
        local distance = enemy.pos:dist(my_pos) < self.range_w
        local w_dmg = dmg_lib:Kaisa_W(player, enemy)
        local p_dmg = 0
        if (self.w_evo() and stack >= 2 and stack ~= 87) or (stack >= 3 and stack ~= 87) then
            p_dmg = dmg_lib:Kaisa_P(player, enemy, utils:get_real_hp(enemy, true, false, true) - w_dmg)
        end

        local ks = utils:get_real_hp(enemy, true, false, true) < w_dmg + p_dmg and mymenu.auto.w_ks:get() and
            self.can_ks and utils:ignore_spell(enemy) == false
        if valid_enemy and distance and ks then
            local seg = pred.linear.get_prediction(self.pred_w, enemy)
            if not seg then return end
            local col = pred.collision.get_prediction(self.pred_w, seg, enemy)
            if col then return end

            local pred_1 = pred.trace.linear.hardlock(self.pred_w, seg, enemy)
            local pred_2 = pred.trace.linear.hardlockmove(self.pred_w, seg, enemy)
            local pred_3 = pred.trace.newpath(target, 0.166666, 0.5)

            if pred_1 or pred_2 or pred_3 then
                local cast_pos = vec3(seg.endPos.x, mousePos.y, seg.endPos.y)
                player:castSpell('pos', 1, cast_pos)
                w_loop = game.time + 1
            end
        end
    end
end

local e_loop = 0
function Kaisa:E_logic()
    if not self.ready_e() then return end

    if game.time < e_loop then return end

    if self.cast_e_dodge > game.time and self.e_evo() then
        player:castSpell('self', 2)
        e_loop = game.time + 0.1
    end

    local orb_t = utils.orb_t
    local avoid_waste = not orb_t or
        (orb_t and
            utils:get_real_hp(orb_t, true, true, true) > damagelib.calc_aa_damage(player, orb_t, true) * 1.2)

    local all_aa_t = game.time < self.paa_t or game.time < utils.after_aa_t

    local combo_e = self.is_combo() and mymenu.combo.e:get()
    local combo_e_paa = mymenu.combo.e:get() and not self.e_evo() and game.time < self.paa_t and avoid_waste
    local combo_e_aa = mymenu.combo.e_evolved:get() and self.e_evo() and not self.e_as_buff() and (all_aa_t) and
        avoid_waste
    local combo_e_melee = mymenu.combo.e_evolved:get() and self.e_evo() and (all_aa_t) and
        utils:count_enemy_hero(player.pos, 300) > 0 and avoid_waste

    local combo = combo_e and (combo_e_paa or combo_e_aa or combo_e_melee)

    local r_e_combo = mymenu.auto.RE:get() and player.path.isDashing and self.e_evo() and
        (not mymenu.auto.RE:get() or not self.ready_w())

    if combo or r_e_combo then
        player:castSpell('self', 2)
        e_loop = game.time + 0.1
    end
end

local r_loop = 0
function Kaisa:R_logic()
    if not self.ready_r() then return end

    if game.time < r_loop then return end

    r_loop = game.time + 0.1

    if evade then
        for i = evade.core.skillshots.n, 1, -1 do
            local spell = evade.core.skillshots[i]

            --chat.print(spell.end_time)
            --spell.name
            --spell.start_time
            --spell.end_time
            --spell.owner
            --spell.danger_level
            --spell.start_pos
            --spell.end_pos
            --spell.data -- assorted static data

            if spell:contains(player) then
                local start_pos = vec3(spell.start_pos.x, 0, spell.start_pos.y)

                local target = utils:get_target(self.range_r, "AD")
                if not target then return end

                if not mymenu.auto["r_" .. spell.owner.charName] or not mymenu.auto["r_" .. spell.owner.charName][spell.name] then
                    return
                end

                local menu = mymenu.auto["r_" .. spell.owner.charName][spell.name]

                if not menu then return end

                local hit_t = 0
                if spell.data.speed == math.huge then
                    hit_t = 0.2
                else
                    hit_t = start_pos:dist(player.pos) / spell.data.speed
                end

                if hit_t > 0.1 and 0.4 > hit_t and menu:get() >= utils:get_real_hp_pre(player) then
                    local r_pos = Kaisa:R_pos(mymenu.auto.save_logic:get())
                    if not r_pos then return end

                    player:castSpell('pos', 3, r_pos)
                    r_loop = game.time + 1
                end
            end
        end
    end
end

function Kaisa:Cd_item_logic()
    if not self.have_cd_item then return end

    if not self.is_combo() then return end

    local save_check = utils:save_check(player.pos, mymenu) or not mymenu.combo.w_sc:get()

    local target = utils:get_target(self.range_w, "AP")
    local orb_t = utils.orb_t
    if orb_t and utils:is_valid(orb_t) and orb_t.type == TYPE_HERO then
        target = orb_t
    end
    local range = target and player.pos:dist(target.pos) or 0

    if self.ready_q() and utils:get_mana_pre(player) > 50 and utils:count_enemy_hero(player.pos, 665) > 0 and game.time > q_loop and
        mymenu.combo.q_cd:get() and mymenu.combo.q:get() then
        player:castSpell('self', 0)
        q_loop = game.time + 0.1
    end

    local attack_windup = player:attackDelay() - player:attackCastDelay(48)
    local best_cast_w_t = game.time <= utils.after_aa_t + attack_windup and game.time + 0.3 <= utils.next_aa_t
    local in_aa = target and range <= player.boundingRadius + target.boundingRadius + player.attackRange
    if utils:is_evade() == false and target and self.ready_w() and (best_cast_w_t or not in_aa) and utils:get_mana_pre(player) > 20 and
        save_check and mymenu.combo.w_cd:get() and mymenu.combo.w:get() and game.time > w_loop then
        local seg = pred.linear.get_prediction(self.pred_w, target)
        if not seg then return end
        local col = pred.collision.get_prediction(self.pred_w, seg, target)
        if col then return end

        local pred_1 = pred.trace.linear.hardlock(self.pred_w, seg, target)
        local pred_2 = pred.trace.linear.hardlockmove(self.pred_w, seg, target)
        local pred_3 = pred.trace.newpath(target, 0.166666, 0.5)

        if pred_1 or pred_2 or pred_3 then
            local cast_pos = vec3(seg.endPos.x, mousePos.y, seg.endPos.y)
            player:castSpell('pos', 1, cast_pos)
            w_loop = game.time + 1
        end
    end

    local best_cast_e_t = orb_t and game.time <= utils.after_aa_t + attack_windup and game.time <= utils.next_aa_t and
        utils:get_real_hp(orb_t, true, true, true) > damagelib.calc_aa_damage(player, orb_t, true) * 1.3
    if orb_t and self.e_evo() and self.ready_e() and mymenu.combo.e_cd:get() and mymenu.combo.e:get() and
        (best_cast_e_t or orb_t and utils:ignore_aa(orb_t) == true) and game.time > e_loop then
        player:castSpell('self', 2)
        e_loop = game.time + 0.1
    end
end

function Kaisa:evolve_logic()
    if self.evo_t > game.time then
        player:move(game.mousePos)
    end
end

local draw_aa_p_target = nil
function Kaisa:aa_p_target()
    if mymenu.auto.stack:get() == 0 then return end

    local target = nil
    local more_stack = 0

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        local valid_enemy = utils:is_valid(enemy)
        local in_aa = player.pos:dist(enemy.pos) <=
            player.boundingRadius + enemy.boundingRadius + player.attackRange + 50
        local stack = self.p_stack(enemy)
        local aa_target = stack >= mymenu.auto.stack:get() and self.p_stack(enemy) ~= 87
        if valid_enemy and in_aa and aa_target and stack > more_stack then
            more_stack = stack
            target = enemy
        end
    end

    if target and utils:is_valid(target) and self.is_combo() and target.type == TYPE_HERO and target.team == TEAM_ENEMY then
        orb.combat.target = target
        self.orb_check = true
        draw_aa_p_target = target
    elseif not target then
        draw_aa_p_target = nil
    end
end

local lc_obj_loop = 0
function Kaisa:Laneclear()
    if not self.is_laneclear() then return end

    if utils.last_aa_target and utils.last_aa_target.isMonster and game.time <= utils.after_aa_t then
        if utils.last_aa_target.health > dmg_lib:Kaisa_Q(player, utils.last_aa_target) and mymenu.lc.q_monster:get() then
            player:castSpell('self', 0)
        end
        if utils.last_aa_target.health > dmg_lib:Kaisa_W(utils.last_aa_target) and mymenu.lc.w_monster:get() then
            player:castSpell('pos', 1, utils.last_aa_target.pos)
        end
    end

    if game.time < lc_obj_loop then return end
    lc_obj_loop = game.time + 0.1

    local q_c = 0
    local q_c_kill = 0

    local Obj = objManager.minions["farm"]
    local Obj_size = objManager.minions.size["farm"]
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if utils:is_valid_minion(obj) and player.pos:dist(obj.pos) < self.range_q then
            q_c = q_c + 1
            if obj.health < dmg_lib:Kaisa_Q(player, obj) then
                q_c_kill = q_c_kill + 1
            end
        end
    end
    local q_lc = (mymenu.lc.q_minion:get() > 0 and mymenu.lc.q_minion:get() >= q_c) or
        (mymenu.lc.q_minion_kill:get() > 0 and mymenu.lc.q_minion_kill:get() <= q_c_kill)
    if q_lc and self.ready_q() then
        player:castSpell('self', 0)
    end
end

function Kaisa:FastLaneclear()
    if not self.is_fastclear then return end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Kaisa:slow_tick()
    if player.isDead then return end

    self.range_q = 665 * mymenu.hc.q_range:get() / 100
    self.range_w = 3000 * mymenu.hc.w_range:get() / 100

    self.range_r = player:spellSlot(3).level == 0 and 0 or
        1500 + (player:spellSlot(3).level - 1) * 750

    self.have_cd_item = false
    for i = 0, 5, 1 do
        if player:itemID(i) == 6675 then
            self.have_cd_item = true
            break
        end
    end

    if mymenu.auto.auto_evolve:get() == 1 and player.evolvePoints > 0 and self.ready_e() and utils:count_enemy_hero(player.pos, 1000) == 0 then
        local in_home = player.inShopRange
        if in_home then return end

        self.evo_t = game.time + 1
        player:castSpell('self', 2)
        player:levelSpell(0)
        player:levelSpell(1)
        player:levelSpell(2)
    end
    if mymenu.auto.auto_evolve:get() == 2 and player.evolvePoints > 0 and utils:count_enemy_hero(player.pos, 1000) == 0 then
        player:castSpell('self', 13)
        player:levelSpell(0)
        player:levelSpell(1)
        player:levelSpell(2)
    end
end

function Kaisa:tick()
    if player.isDead then return end

    local target = utils:get_target(2000)
    if target then
    end
    self:spell_check()

    --self:aa_p_target()
    self:Q_logic()
    self:W_logic()
    self:E_logic()
    self:R_logic()
    self:Cd_item_logic()
    self:evolve_logic()
    self:Laneclear()
    self:FastLaneclear()

    -- print(orb.core.next_attack)
    -- print(orb.core.time_to_next_attack())
    -- print(orb.core.is_winding_up_attack())
end

function Kaisa:process_spell(spell)
    if not spell or player.isDead then return end

    if spell.name == "KaisaR" and spell.owner and spell.owner == player then
        self.last_r_t = game.time
        self.r_dash = true
        orb.core.reset()
    end
    if spell.name == "KaisaW" and spell.owner and spell.owner == player then
        orb.core.set_pause(0.3)
    end

    if spell.target and spell.owner and spell.target == player and spell.owner.team == TEAM_ENEMY and spell.owner.type == TYPE_HERO then
        local menu_champion = mymenu.auto["e_" .. spell.owner.charName]
        if not menu_champion then return end
        local muen_spell = menu_champion[spell.name]
        if not muen_spell then return end

        if muen_spell:get() >= utils:get_real_hp_pre(player) then
            self.cast_e_dodge = game.time + 0.03
            return
        end
    end
end

function Kaisa:finish_spell(spell)
    if not spell or player.isDead then return end
end

function Kaisa:on_cast_spell(args)
    if not args or player.isDead then return end
    if mymenu.auto.w_cancel:get() and args.spellSlot == 1 and self.ready_q() and player.mana - player.manaCost0 - player.manaCost1 > 0 then
        player:castSpell('self', 0)
    end
    --self.ready_q()
end

function Kaisa:path(target)
    if not target then return end
end

function Kaisa:dmg_output()
    if mymenu.dr.dmg_type:get() == 3 and mymenu.dr.p_state:get() == false then return end
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        --graphics.draw_line_2D(enemy.barPos.x + 163, enemy.barPos.y + 123, enemy.barPos.x + 268, enemy.barPos.y + 123, 11.5 , 0xA5FFFFFF)

        if utils:is_valid(enemy) and enemy.isVisible and enemy.isOnScreen then
            if mymenu.dr.dmg_type:get() == 2 then
                local dmg = { passive = 0, aa = 0, q = 0, w = 0, e = 0, r = 0 }
                local qw_dmg = 0

                if mymenu.dr.q_damage:get() and self.ready_q() then
                    dmg.q = dmg_lib:Kaisa_Q(player, enemy)
                    qw_dmg = qw_dmg + dmg_lib:Kaisa_Q(player, enemy)
                end

                if mymenu.dr.w_damage:get() and self.ready_w() then
                    dmg.w = dmg_lib:Kaisa_W(player, enemy)
                    qw_dmg = qw_dmg + dmg_lib:Kaisa_W(player, enemy)
                end

                if mymenu.dr.aa_damage:get() > 0 then
                    dmg.aa = damagelib.calc_aa_damage(player, enemy, true) +
                        damagelib.calc_aa_damage(player, enemy, false) * (mymenu.dr.aa_damage:get() - 1)
                    qw_dmg = qw_dmg + damagelib.calc_aa_damage(player, enemy, true) +
                        damagelib.calc_aa_damage(player, enemy, false) * (mymenu.dr.aa_damage:get() - 1)
                end

                if mymenu.dr.p_damage:get() then
                    dmg.passive = dmg_lib:Kaisa_P(player, enemy, qw_dmg)
                end

                utils:draw_hp_bar(enemy, dmg)
            elseif mymenu.dr.dmg_type:get() == 1 then
                local dmg = 0
                local qw_dmg = 0

                if self.ready_q() then
                    dmg = dmg + dmg_lib:Kaisa_Q(player, enemy)
                    qw_dmg = qw_dmg + dmg_lib:Kaisa_Q(player, enemy)
                end
                if self.ready_w() then
                    dmg = dmg + dmg_lib:Kaisa_W(player, enemy)
                    qw_dmg = qw_dmg + dmg_lib:Kaisa_W(player, enemy)
                end

                local p_buff = self.p_stack(enemy)
                local aa_count = p_buff == 87 and 5 or 5 - p_buff
                if aa_count > 0 then
                    dmg = dmg + damagelib.calc_aa_damage(player, enemy, true) +
                        damagelib.calc_aa_damage(player, enemy, false) * (aa_count - 1)
                    qw_dmg = qw_dmg + damagelib.calc_aa_damage(player, enemy, true) +
                        damagelib.calc_aa_damage(player, enemy, false) * (aa_count - 1)
                end

                dmg = dmg + dmg_lib:Kaisa_P(player, enemy, qw_dmg)

                utils:draw_hp_bar(enemy, dmg)
            end
            if mymenu.dr.p_state:get() == true then
                local stack = self.p_stack(enemy)
                if stack and stack ~= 87 and utils:is_valid(enemy) then
                    local my_pos = vec3(player.pos.x, enemy.pos.y, player.pos.z)
                    local extend_pos = enemy.pos + (enemy.pos - my_pos):norm() * -100
                    local p2d = graphics.world_to_screen(extend_pos)
                    local color = stack == 1 and 0xff00ff00 or stack == 2 and 0xff7dff00 or stack == 3 and 0xffff7d00 or
                        stack == 4 and 0xffff0000
                    local text_stack = tostring(5 - stack)
                    if text_stack and p2d and color then
                        graphics.draw_text_2D(tostring(5 - stack), 80, p2d.x - 10, p2d.y - 10, color)
                    end
                end
            end
        end
    end
end

function Kaisa:new_draw()
    if player.isDead then return end

    if keyboard.isKeyDown(0x09) then return end

    if mymenu.dr.Q:get() then
        local color = self.ready_q() and common.drawdr_menu.clr_q:get() or
            utils:set_alpha(common.drawdr_menu.clr_q:get(), 120)
        utils:draw_circle("q_range", player.pos, self.range_q, color)
    end
    if mymenu.dr.W:get() then
        local color = self.ready_w() and common.drawdr_menu.clr_w:get() or
            utils:set_alpha(common.drawdr_menu.clr_w:get(), 120)
        utils:draw_circle("w_range", player.pos, self.range_w, color)
        minimap.draw_circle(player.pos, 3000, 1, color, 18)
    end
    if mymenu.dr.R:get() then
        local color = self.ready_r() and common.drawdr_menu.clr_r:get() or
            utils:set_alpha(common.drawdr_menu.clr_r:get(), 120)
        utils:draw_circle("r_range", player.pos, self.range_r, color)
        minimap.draw_circle(player.pos, self.range_r, 1, color, 18)
    end

    if draw_aa_p_target then
        graphics.draw_circle(draw_aa_p_target.pos, draw_aa_p_target.boundingRadius, 2, 0xFFFFFFFF, 36)
    end

    self:dmg_output()
    --Kaisa:W_logic(true)

    local state_style = utils.menuc.draw_state_menu.state_style:get()
    local text_size = utils.menuc.draw_state_menu.text_size:get()
    local state_color = utils.menuc.draw_state_menu.text_color:get()
    local state_pos = player.pos + vec3(50, 0, -50)
    local p2d = graphics.world_to_screen(state_pos)
    local state_list = {
        { mymenu.sf, mymenu.dr.sf:get(), "SpellFarm", "发育" },
        { mymenu.semi_w, mymenu.dr.semi_w:get(), "Semi W", "半手动W" },

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

    --:to3DWorld()
    -- local v = player.pos
    -- graphics.draw_text_2D('foo', 14, v.x, v.y, 0xFFFFFFFF)

    --graphics.draw_circle(player.pos, 700, 2, 0xFFFFFFFF, 36)
    --graphics.draw_line(a, b, 2, 0xFFFFFFFF)
end

function Kaisa:init()
    self:load()
    local tick_function = utils.on_slow_tick(1, function() Kaisa:slow_tick() end)
    cb.add(cb.tick, tick_function)
    cb.add(cb.tick, function() self:tick() end)
    cb.add(cb.spell, function(...) self:process_spell(...) end)
    cb.add(cb.cast_finish, function(...) self:finish_spell(...) end)
    cb.add(cb.cast_spell, function(...) self:on_cast_spell(...) end)

    cb.add(cb.path, function(...) self:path(...) end)
    cb.add(cb.draw, function() self:new_draw() end)

    local function after_attack()
        if utils.orb_t and self.p_stack(utils.orb_t) == 4 then
            self.paa_t = game.time + 0.03
        end
        orb.combat.set_invoke_after_attack(false)
    end

    orb.combat.register_f_after_attack(after_attack)

    local function on_tick_orb()
        self:aa_p_target()
    end
    orb.combat.register_f_pre_tick(on_tick_orb)
end

return Kaisa:init()
