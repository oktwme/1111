local Yasuo = {}

---@type utils
local utils = module.load(header.id, "Help/utils")
local dmg_lib = module.load(header.id, "Help/dmg_lib")

local orb = module.internal('orb')
local pred = module.internal('pred')
local damagelib = module.internal('damagelib')
local evade = module.seek('evade')

local my_name = player.charName
local spell_data = module.load(header.id, "Help/spell_database")

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
    mymenu.combo:boolean("eq", " ^- EQ", true)
    mymenu.combo:boolean("q3", " ^- Include Q3", true)
    mymenu.combo:boolean("q_aoe", " ^- Try AOE", true)
    mymenu.combo:boolean("q_stack", " ^- Try stack Q", true)

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "Use E", true)
    mymenu.combo:boolean("e_sc", " ^- Save Check", true)
    mymenu.combo.e_sc:set('tooltip', 'Logic setting -> Save Check')
    mymenu.combo:slider("e_flex", " ^- E Sensitivity", 600, 0, 1000, 1)
    mymenu.combo:slider("e_angle", " ^- E angle", 50, 30, 90, 1)

    mymenu.combo:header("header_4", "R")
    mymenu.combo:boolean("r", "Use R", true)
    mymenu.combo:boolean("r_eq", " ^- EQ -> R", true)
    mymenu.combo:boolean("r_sup", " ^- Assist ally", true)
    mymenu.combo:boolean("r_n_waste", " ^- Don't waste R", true)
    mymenu.combo:slider("r_can_kill", " ^- If can kill (DPS)", 3, 1, 6, 1)
    mymenu.combo:slider("r_aoe", " ^- Use R >= x enemy", 2, 2, 5, 1)

    mymenu.combo:header("header_5", "EQ -> Flash")
    mymenu.combo:slider("eq_f", "Use EQ -> Flash if hp <= x%", 35, 0, 50, 1)

    local elements_q = { mymenu.combo.eq, mymenu.combo.q3, mymenu.combo.q_aoe, mymenu.combo.q_stack }
    local elements_e = { mymenu.combo.e_sc, mymenu.combo.e_flex, mymenu.combo.e_angle }
    local elements_r = { mymenu.combo.r_eq, mymenu.combo.r_sup, mymenu.combo.r_n_waste, mymenu.combo.r_can_kill,
        mymenu.combo.r_aoe }
    utils:set_visible(elements_q, mymenu.combo.q:get())
    utils:set_visible(elements_e, mymenu.combo.e:get())
    utils:set_visible(elements_r, mymenu.combo.r:get())
    mymenu.combo.q:set('callback', function(old, new) utils:hide_menu(elements_q, true, old, new) end)
    mymenu.combo.e:set('callback', function(old, new) utils:hide_menu(elements_e, true, old, new) end)
    mymenu.combo.r:set('callback', function(old, new) utils:hide_menu(elements_r, true, old, new) end)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "Harass")
    -- #region harass
    mymenu.harass:header("header_1", "Q")
    mymenu.harass:boolean("q", "Use Q", true)
    mymenu.harass:dropdown("q_lh", "Q lasthit", 1, { "Killable", "Freeze", "Disable" })
    mymenu.harass:dropdown("q_jg", "Q steal jungle", 1, { "Dmg pred", "Heal", "Disable" })

    mymenu.harass:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "Automatic")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "Killsteal", true)
    mymenu.auto:header("header_2", "W dodge")

    local w_count = 0
    for i = 0, objManager.enemies_n - 1 do
        local champion = objManager.enemies[i]
        local hero_name = champion.charName
        local hero_data = spell_data[hero_name]
        if hero_data then
            for _, spell in ipairs(hero_data) do
                w_count = w_count + 1
                local missile = spell.missile
                if missile == true then
                    local menu_tab = mymenu.auto["w_" .. hero_name]
                    if not menu_tab then
                        mymenu.auto:menu("w_" .. hero_name, hero_name)
                    end
                    mymenu.auto["w_" .. hero_name]:slider(spell.name,
                        hero_name .. " " .. spell.Spell .. " " .. "  Hp <= x", spell.menu, 0, 100, 1)
                end
            end
        end
    end
    if w_count == 0 then
        mymenu.auto:header("e_data", "No data")
    end
    mymenu.auto:header("header_3", "E")
    mymenu.auto:boolean("e_ks", "Killsteal", true)

    mymenu.auto:header("header_4", "Misc")
    mymenu.auto:boolean("cancel_windup", "Cancel animation", true)
    mymenu.auto:header("header_5", "")
    -- #endregion

    mymenu:menu("lc", "Laneclear")
    -- #region laneclear
    mymenu.lc:header("header_1", "Laneclear")
    mymenu.lc:boolean("q_lc", "Laneclear Q", true)
    mymenu.lc:boolean("e_lc", "Laneclear E", true)
    mymenu.lc:header("header_2", "Jungle")
    mymenu.lc:boolean("q_jg", "Jungle Q", true)
    mymenu.lc:boolean("e_jg", "Jungle E", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("hc", "Hitchance")
    -- #region hitchance
    mymenu.hc:header("header_1", "Q")
    mymenu.hc:slider("q_range", "Range %", 100, 70, 100, 1)
    mymenu.hc:header("header_5", "")
    -- #endregion

    mymenu:menu("dr", "Drawings")
    -- #region Drawings
    mymenu.dr:header("range", "Range")
    mymenu.dr:boolean("Q", "Draw Q", true)
    mymenu.dr:boolean("E", "Draw E", true)
    mymenu.dr:boolean("R", "Draw R", true)

    mymenu.dr:header("damage", "Damage")
    mymenu.dr:dropdown("dmg_type", "Draw type", 1, { "R Dps", "Default", "Disable" })
    mymenu.dr:boolean("q_damage", "Draw Q", true)
    mymenu.dr:boolean("e_damage", "Draw E", true)
    mymenu.dr:boolean("r_damage", "Draw R", true)
    mymenu.dr:slider("aa_damage", "Draw AA", 1, 0, 5, 1)

    local function hide_dd_menu()
        mymenu.dr.q_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.e_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.r_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.aa_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
    end
    hide_dd_menu()
    mymenu.dr.dmg_type:set('callback', hide_dd_menu)

    mymenu.dr:header("state", "State")
    mymenu.dr:boolean("sf", "SpellFarm", true)
    mymenu.dr:boolean("dive", "Dive", true)
    mymenu.dr:boolean("flash", "Flash combo", true)
    mymenu.dr:boolean("semi_e", "Semi E", true)
    mymenu.dr:boolean("semi_r", "Force R", true)

    mymenu.dr:header("misc", "Misc")
    mymenu.dr:boolean("ts", "Draw E target selector", true)
    mymenu.dr:boolean("line", "Draw E line", true)

    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "Key")
    mymenu:keybind("sf", "SpellFarm", nil, 'MMB')
    mymenu:keybind("dive", "Dive", nil, 'T', true)
    mymenu:keybind("flash", "Flash combo", 'A', nil, true)
    mymenu:keybind("semi_e", "Semi E", 'Z', nil)
    mymenu:keybind("semi_r", "Force R", nil, 'R')
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
    mymenu.combo:boolean("eq", " ^- EQ", true)
    mymenu.combo:boolean("q3", " ^- 包含Q3", true)
    mymenu.combo:boolean("q_aoe", " ^- 尝试AOE", true)
    mymenu.combo:boolean("q_stack", " ^- 尝试叠Q", true)

    mymenu.combo:header("header_3", "E")
    mymenu.combo:boolean("e", "使用E", true)
    mymenu.combo:boolean("e_sc", " ^- 安全检查", true)
    mymenu.combo.e_sc:set('tooltip', '逻辑设置 -> 安全检查             ')
    mymenu.combo:slider("e_flex", " ^- E敏感度", 600, 0, 1000, 1)
    mymenu.combo:slider("e_angle", " ^- E角度", 50, 30, 90, 1)

    mymenu.combo:header("header_4", "R")
    mymenu.combo:boolean("r", "使用R", true)
    mymenu.combo:boolean("r_eq", " ^- EQ -> R", true)
    mymenu.combo:boolean("r_sup", " ^- 帮助队友", true)
    mymenu.combo:boolean("r_n_waste", " ^- 不浪费R", true)
    mymenu.combo:slider("r_can_kill", " ^- 如果可击杀 (秒伤)", 3, 1, 6, 1)
    mymenu.combo:slider("r_aoe", " ^- 使用R >= x 敌人", 2, 2, 5, 1)

    mymenu.combo:header("header_5", "EQ -> 闪现")
    mymenu.combo:slider("eq_f", "使用 EQ -> 闪现当生命 <= x%", 35, 0, 50, 1)

    local elements_q = { mymenu.combo.eq, mymenu.combo.q3, mymenu.combo.q_aoe, mymenu.combo.q_stack }
    local elements_e = { mymenu.combo.e_sc, mymenu.combo.e_flex, mymenu.combo.e_angle }
    local elements_r = { mymenu.combo.r_eq, mymenu.combo.r_sup, mymenu.combo.r_n_waste, mymenu.combo.r_can_kill,
        mymenu.combo.r_aoe }
    utils:set_visible(elements_q, mymenu.combo.q:get())
    utils:set_visible(elements_e, mymenu.combo.e:get())
    utils:set_visible(elements_r, mymenu.combo.r:get())
    mymenu.combo.q:set('callback', function(old, new) utils:hide_menu(elements_q, true, old, new) end)
    mymenu.combo.e:set('callback', function(old, new) utils:hide_menu(elements_e, true, old, new) end)
    mymenu.combo.r:set('callback', function(old, new) utils:hide_menu(elements_r, true, old, new) end)

    mymenu.combo:header("header_5", "")
    -- #endregion

    mymenu:menu("harass", "骚扰")
    -- #region harass
    mymenu.harass:header("header_1", "Q")
    mymenu.harass:boolean("q", "使用Q", true)
    mymenu.harass:dropdown("q_lh", "Q尾兵", 1, { "能击杀时", "控线", "关闭" })
    mymenu.harass:dropdown("q_jg", "Q抢野", 1, { "伤害预测", "血量", "关闭" })

    mymenu.harass:header("header_5", "")
    -- #endregion

    mymenu:menu("auto", "自动")
    -- #region automatic
    mymenu.auto:header("header_1", "Q")
    mymenu.auto:boolean("q_ks", "捡人头", true)
    mymenu.auto:header("header_2", "W格挡")

    local w_count = 0
    for i = 0, objManager.enemies_n - 1 do
        local champion = objManager.enemies[i]
        local hero_name = champion.charName
        local hero_data = spell_data[hero_name]
        if hero_data then
            for _, spell in ipairs(hero_data) do
                w_count = w_count + 1
                local missile = spell.missile
                if missile == true then
                    local menu_tab = mymenu.auto["w_" .. hero_name]
                    if not menu_tab then
                        mymenu.auto:menu("w_" .. hero_name, hero_name)
                    end
                    mymenu.auto["w_" .. hero_name]:slider(spell.name,
                        hero_name .. " " .. spell.Spell .. " " .. "  Hp <= x", spell.menu, 0, 100, 1)
                end
            end
        end
    end
    if w_count == 0 then
        mymenu.auto:header("e_data", "没有资料")
    end
    mymenu.auto:header("header_3", "E")
    mymenu.auto:boolean("e_ks", "捡人头", true)

    mymenu.auto:header("header_4", "杂项")
    mymenu.auto:boolean("cancel_windup", "取消动画(能击杀时)", true)
    mymenu.auto:header("header_5", "")
    -- #endregion

    mymenu:menu("lc", "清线")
    -- #region laneclear
    mymenu.lc:header("header_1", "清兵")
    mymenu.lc:boolean("q_lc", "清兵Q", true)
    mymenu.lc:boolean("e_lc", "清兵E", true)
    mymenu.lc:header("header_2", "清野")
    mymenu.lc:boolean("q_jg", "清野Q", true)
    mymenu.lc:boolean("e_jg", "清野E", true)
    mymenu.lc:header("header_3", "")
    -- #endregion

    mymenu:menu("hc", "命中率")
    -- #region hitchance
    mymenu.hc:header("header_1", "Q")
    mymenu.hc:slider("q_range", "范围%", 100, 70, 100, 1)
    mymenu.hc:header("header_5", "")
    -- #endregion

    mymenu:menu("dr", "绘制")
    -- #region Drawings
    mymenu.dr:header("range", "范围")
    mymenu.dr:boolean("Q", "绘制Q", true)
    mymenu.dr:boolean("E", "绘制E", true)
    mymenu.dr:boolean("R", "绘制R", true)

    mymenu.dr:header("damage", "伤害")
    mymenu.dr:dropdown("dmg_type", "绘制种类", 1, { "R秒伤", "预设", "关闭" })
    mymenu.dr:boolean("q_damage", "绘制Q", true)
    mymenu.dr:boolean("e_damage", "绘制E", true)
    mymenu.dr:boolean("r_damage", "绘制R", true)
    mymenu.dr:slider("aa_damage", "绘制普攻", 1, 0, 5, 1)

    local function hide_dd_menu()
        mymenu.dr.q_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.e_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.r_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
        mymenu.dr.aa_damage:set('visible', mymenu.dr.dmg_type:get() == 2)
    end
    hide_dd_menu()
    mymenu.dr.dmg_type:set('callback', hide_dd_menu)

    mymenu.dr:header("state", "状态")
    mymenu.dr:boolean("sf", "发育", true)
    mymenu.dr:boolean("dive", "越塔", true)
    mymenu.dr:boolean("flash", "闪现连招", true)
    mymenu.dr:boolean("semi_e", "半手动E", true)
    mymenu.dr:boolean("semi_r", "强制R", true)

    mymenu.dr:header("misc", "杂项")
    mymenu.dr:boolean("ts", "绘制E目标选择", true)
    mymenu.dr:boolean("line", "绘制E线条", true)

    mymenu.dr:header("header_1", "")
    -- #endregion

    mymenu:header("2", "快捷键")
    mymenu:keybind("sf", "发育", nil, 'MMB')
    mymenu:keybind("dive", "越塔", nil, 'T', true)
    mymenu:keybind("flash", "闪现连招", 'A', nil, true)
    mymenu:keybind("semi_e", "半手动E", 'Z', nil)
    mymenu:keybind("semi_r", "强制R", nil, 'R')
    mymenu:header("header_end", "")
end
local common = utils:menu_common()

local yasuo_dash_pos =
{
    --start e_pos
    --?{?r?R
    { vec3(2246.00, 51.78, 8426.00),  vec3(2049.81, 51.78, 8459.68) },
    { vec3(1674.00, 52.84, 8476.00),  vec3(2129.88, 51.78, 8442.90),  "out" },
    --?{?{B
    { vec3(3826.00, 52.11, 8004.00),  vec3(3817.49, 51.89, 7787.87) },
    { vec3(3780.00, 51.82, 7428.00),  vec3(3815.12, 51.91, 7796.48),  "out" },
    --?{????
    { vec3(3724.00, 52.46, 6508.00),  vec3(3749.54, 52.46, 6783.02) },
    { vec3(3912.00, 52.46, 6478.00),  vec3(4066.44, 52.47, 6404.68) },
    { vec3(3674.00, 50.33, 7058.00),  vec3(3719.61, 52.46, 6667.00),  "out" },
    { vec3(4324.00, 51.54, 6258.00),  vec3(3987.36, 52.47, 6447.94),  "out" },
    --?{???B
    { vec3(6424.00, 48.53, 5208.00),  vec3(6832.00, 48.53, 5239.81),  "out" },
    { vec3(6916.00, 48.53, 5228.00),  vec3(6748.98, 48.53, 5226.57) },
    { vec3(6868.00, 54.01, 5480.00),  vec3(6568.24, 54.95, 5672.03) },
    { vec3(7030.00, 53.76, 5452.00),  vec3(7190.32, 60.70, 5697.02) },
    { vec3(7274.00, 52.48, 5908.00),  vec3(7052.18, 55.90, 5538.39),  "out" },
    --?{??^
    { vec3(8296.00, 50.98, 2606.00),  vec3(8264.84, 51.13, 2728.13) },
    { vec3(8534.00, 50.12, 2618.00),  vec3(8429.36, 51.12, 2796.83) },
    { vec3(8222.00, 51.65, 3158.00),  vec3(8272.82, 51.13, 2727.14),  "out" },
    --?t?r?R
    { vec3(12560.00, 51.74, 6436.00), vec3(12805.67, 51.66, 6454.77) },
    { vec3(13172.00, 54.20, 6508.00), vec3(12742.99, 51.68, 6451.37), "out" },
    --?t?{B
    { vec3(11022.00, 51.72, 6908.00), vec3(11058.37, 51.72, 7211.34) },
    --?t????
    { vec3(11022.00, 62.18, 8276.00), vec3(11071.43, 62.25, 8200.41) },
    { vec3(11222.00, 52.21, 7856.00), vec3(11043.64, 62.06, 8246.41), "out" },
    { vec3(10900.00, 62.71, 8368.00), vec3(10757.89, 63.19, 8405.56) },
    { vec3(10370.00, 61.58, 8454.00), vec3(10778.54, 63.18, 8391.18), "out" },
    --?t???B
    { vec3(8372.00, 50.38, 9606.00),  vec3(8047.55, 52.33, 9490.29),  "out" },
    { vec3(7910.00, 52.36, 9444.00),  vec3(8159.36, 52.31, 9532.80) },
    { vec3(7788.00, 52.35, 9490.00),  vec3(7514.20, 52.87, 9149.45) },
    { vec3(7672.00, 52.87, 8910.00),  vec3(7859.97, 52.48, 9262.56),  "out" },
    { vec3(7856.00, 52.43, 9342.00),  vec3(8078.57, 52.57, 9128.80) },
    --?t??^
    { vec3(6650.00, 53.83, 11766.00), vec3(6535.21, 56.48, 12143.67), "out" },
    { vec3(6550.00, 56.48, 12246.00), vec3(6542.97, 56.48, 12035.53) },
    { vec3(6296.00, 56.48, 12250.00), vec3(6341.43, 56.48, 12014.70) },

}

function Yasuo:load()
    self.bonus_as = 0

    self.is_combo = false
    self.is_mixed = false
    self.is_laneclear = false
    self.is_fastclear = false
    self.is_lasthit = false

    self.kill_t = nil

    self.f_use_eq = 0
    self.f_use_flash = false

    self.Q123 = 0
    self.last_q_t = 0
    self.q_range = 0
    self.q_ready = false
    self.eq_ready = false
    self.last_eq_t = 0
    self.use_eq = 0
    self.q_level = 0
    self.q_cd = 5

    self.q_pred = self.Q123 == 3 and {
        width = 90,
        delay = 0.35,
        speed = 1200,
        range = self.q_range,
        boundingRadiusMod = 1.0,
        collision = { hero = false, minion = false, walls = true },
    } or {
        width = 40,
        delay = 0.35,
        speed = math.huge,
        range = self.q_range,
        boundingRadiusMod = 1.0,
        collision = { hero = false, minion = false, walls = false },
    }
    self.q_pred_aoe = self.Q123 == 3 and {
        width = 90,
        delay = 0.35,
        speed = 1200,
        range = self.q_range,
        boundingRadiusMod = 1.0,
        collision = { hero = true, minion = false, walls = true },
    } or {
        width = 40,
        delay = 0.35,
        speed = math.huge,
        range = self.q_range,
        boundingRadiusMod = 1.0,
        collision = { hero = true, minion = false, walls = false },
    }

    self.cast_q = function(target)
        if not target or not self.q_ready then return false end

        local pred_pos = nil
        if self.Q123 == 3 then
            local seg = pred.linear.get_prediction(self.q_pred, target)
            if seg then
                local pred_1 = pred.trace.linear.hardlock(self.q_pred, seg, target)
                local pred_2 = pred.trace.linear.hardlockmove(self.q_pred, seg, target)
                local pred_3 = pred.trace.newpath(target, 0.167, 0.500)
                if pred_1 or pred_2 or pred_3 or target.active_spell then
                    pred_pos = vec3(seg.endPos.x, target.pos.y, seg.endPos.y)
                end
            end
        else
            if (target.path and not target.path.isMoving) or target.active_spell then
                pred_pos = target.pos
            else
                local true_delay = self.q_pred.delay + network.latency
                local range = true_delay * target.moveSpeed - target.boundingRadius - 30
                if target.path and range > 0 then
                    local target_pos = target.pos:to2D()
                    local target_path = target.path.endPos2D
                    local dir = (target_path - target_pos):norm()
                    pred_pos = (target_pos + dir * range):to3D(target.y)
                else
                    pred_pos = target.pos
                end
            end
        end


        if pred_pos and player.pos:dist(pred_pos) <= self.q_range then
            player:castSpell('pos', 0, pred_pos)
        end
    end

    self.last_w_t = 0
    self.w_ready = false
    self.w_level = 0

    self.last_e_t = 0
    self.e_dash = {
        is_e_dash = false,
        start_t = 0,
        end_t = 0,
        start_pos = vec3(0, 0, 0),
        end_pos = vec3(0, 0, 0),
        use_eq = false
    }
    self.e_range = 0
    self.e_ready = false
    self.e_level = 0

    self.last_r_t = 0
    self.r_range = 0
    self.r_ready = false
    self.r_level = 0
end

local kill_t_loop = 0
function Yasuo:spell_check()
    if self.use_eq + 0.35 > game.time then
        orb.core.set_pause_attack(0.1)
    end

    if game.time > kill_t_loop then
        local target = utils:get_target(self.r_range, "AD")
        local force_target = utils:get_target(1500, "Force")
        if target then
            self.kill_t = target
            kill_t_loop = game.time + 0.1
        elseif force_target then
            self.kill_t = force_target
        end
    end
    if self.kill_t and (not utils:is_valid(self.kill_t) or self.kill_t.pos:dist(player.pos) > 2000) then
        self.kill_t = nil
    end

    self.bonus_as = (dmg_lib:as_per() - 1) * 100

    self.is_combo = orb.menu.combat.key:get()
    self.is_mixed = orb.menu.hybrid.key:get()
    self.is_laneclear = orb.menu.lane_clear.key:get() and mymenu.sf:get()
    self.is_lasthit = self.is_laneclear or orb.menu.last_hit.key:get()

    local Qdelay_s = 0.35 - 0.035 * self.bonus_as / 24
    local Q1_delay = Qdelay_s < 0.175 and 0.175 or Qdelay_s
    local Q3_delay = Qdelay_s < 0.28 and 0.28 or Qdelay_s
    self.q_pred.delay = self.Q123 == 3 and Q3_delay or Q1_delay
    self.q_pred_aoe.delay = self.Q123 == 3 and Q3_delay or Q1_delay

    local q_name = player:spellSlot(0).name
    local q_cd_now = player:spellSlot(0).cooldown
    self.Q123 = q_name == "YasuoQ1Wrapper" and 1 or q_name == "YasuoQ2Wrapper" and 2 or q_name == "YasuoQ3Wrapper" and 3
    self.q_range = self.Q123 == 3 and 1150 * mymenu.hc.q_range:get() / 100 or 475 * mymenu.hc.q_range:get() / 100
    self.q_pred_aoe.range = self.q_range
    self.q_pred.range = self.q_range
    self.q_level = player:spellSlot(0).level
    self.q_ready = self.q_level > 0 and player:spellSlot(0).state == 0
    self.eq_ready = q_cd_now <= 0.56 + network.latency
    local Q_CD_s = 4 * (1 - (0.01 * self.bonus_as / 1.67))
    self.q_cd = Q_CD_s < 1.33 and 1.33 or Q_CD_s

    self.w_level = player:spellSlot(1).level
    self.w_ready = self.w_level > 0 and player:spellSlot(1).state == 0

    self.e_range = 475
    self.e_level = player:spellSlot(2).level
    self.e_ready = self.e_level > 0 and player:spellSlot(2).state == 0

    for i = #self.e_dash, 1, -1 do
        local e_dash_list = self.e_dash[i]
        local e_check_1 = e_dash_list.end_t ~= 0 and e_dash_list.end_t + 0.04 < game.time
        local e_check_2 = game.time - e_dash_list.start_t > 1
        if e_check_1 or e_check_2 then
            table.remove(self.e_dash, i)
        end
    end

    self.r_range = 1400
    self.r_level = player:spellSlot(3).level
    self.r_ready = self.r_level > 0 and player:spellSlot(3).state == 0
end

function Yasuo:can_kill(target, aa_c, q_c, e_c, r_c)
    if not target then return false end

    local dmg = 0.0
    if aa_c >= 1 then
        dmg = dmg + damagelib.calc_aa_damage(player, target, true)
        if aa_c >= 2 then
            dmg = dmg + damagelib.calc_aa_damage(player, target, false) * (aa_c - 1)
        end
    end

    dmg = dmg + dmg_lib:Yasuo_Q(player, target) * q_c

    if not utils:has_buff(target, "YasuoE") then
        dmg = dmg + dmg_lib:Yasuo_E(player, target) * e_c
    end

    if self.r_ready then
        dmg = dmg + dmg_lib:Yasuo_R(player, target) * r_c
    end
    return dmg > utils:get_real_hp(target, true, false, false)
end

function Yasuo:dps(target, sec)
    if not target then return 0 end

    local dmg = 0.0

    local aa_c = sec / player:attackDelay()
    if aa_c >= 1 then
        dmg = dmg + damagelib.calc_aa_damage(player, target, true)
        if aa_c >= 2 then
            dmg = dmg + damagelib.calc_aa_damage(player, target, false) * (aa_c - 1)
        end
    end
    local q_c = sec / self.q_cd
    dmg = dmg + dmg_lib:Yasuo_Q(player, target) * q_c

    if not utils:has_buff(target, "YasuoE") then
        dmg = dmg + dmg_lib:Yasuo_E(player, target)
    end

    if self.r_ready and self.q_cd < 1.5 then
        dmg = dmg + dmg_lib:Yasuo_Q(player, target)
    end

    return dmg
end

function Yasuo:get_e_pos(target)
    if not target or not utils:is_valid(target) then return vec3(0, 0, 0) end

    local function is_safe_pos(pos)
        return not navmesh.isWall(pos) and not navmesh.isStructure(pos)
    end

    local norm = (target.pos - player.pos):norm()
    local pos = player.pos + norm * 475
    if is_safe_pos(pos) then
        return pos
    end

    for i = 475, 625, 5 do
        pos = player.pos + norm * i
        if is_safe_pos(pos) then
            return pos
        end
    end
    for i = 475, 0, -10 do
        pos = player.pos + norm * i
        if is_safe_pos(pos) then
            return pos
        end
    end
    return player.pos
end

--Yasuo:e_save_poly(player.pos2D + (target.pos2D - player.pos2D):norm() * 930, true)
function Yasuo:e_save_poly(pos, draw)
    local cone = utils:triangles_2d(player.pos2D, pos, 400)

    if draw then
        utils:draw_2d(cone, player.y)
    end

    return cone
end

function Yasuo:count_enemy_poly(pos)
    local count = 0
    local cone = self:e_save_poly(pos)

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local target = Obj[i]
        if target and utils:is_valid(target) and utils:contains_2d(target.pos2D, cone) then
            count = count + 1
        end
    end
    return count
end

function Yasuo:can_e_target()
    local target = {}

    local Obj1 = objManager.enemies
    local Obj1_size = objManager.enemies_n
    for i = 0, Obj1_size - 1 do
        local obj = Obj1[i]
        if obj and utils:is_valid(obj) and not utils:has_buff(obj, "YasuoE") and player.pos:dist(obj.pos) <= self.e_range then
            target[#target + 1] = obj
        end
    end

    local Obj2 = objManager.minions[TEAM_ENEMY]
    local Obj2_size = objManager.minions.size[TEAM_ENEMY]
    for i = 0, Obj2_size - 1 do
        local obj = Obj2[i]
        if obj and utils:is_valid_minion(obj) and obj.isTargetable and not utils:has_buff(obj, "YasuoE") and player.pos:dist(obj.pos) <= self.e_range then
            target[#target + 1] = obj
        end
    end

    local Obj3 = objManager.minions[TEAM_NEUTRAL]
    local Obj3_size = objManager.minions.size[TEAM_NEUTRAL]
    for i = 0, Obj3_size - 1 do
        local obj = Obj3[i]
        if obj and utils:is_valid(obj) and obj.isTargetable and not utils:has_buff(obj, "YasuoE") and player.pos:dist(obj.pos) <= self.e_range then
            target[#target + 1] = obj
        end
    end
    return target
end

function Yasuo:can_use_e(target)
    if not target then return false end

    if not mymenu.dive:get() and utils:in_enemy_turret(Yasuo:get_e_pos(target)) then
        return false
    end

    if evade then
        local end_pos = Yasuo:get_e_pos(target):to2D()
        local evade_dis = end_pos:dist(player.pos2D)
        local evade_pos = player.pos2D + (end_pos - player.pos2D):norm() * evade_dis
        if evade.core.is_action_safe(evade_pos, 1000, 0) == false then
            return false
        end
    end

    local my_pos = player.pos

    if mymenu.combo.e_sc:get() then
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
            return a.pos:dist(player.pos) < b.pos:dist(player.pos)
        end)

        local solo = utils:count_ally_hero(my_pos, 1000) == 0 and #enemy > 0 and
            utils:count_enemy_hero(enemy[1].pos, 1000) == 1

        local ally_more = #enemy > 0 and
            my_pos:dist(enemy[1].pos) <= mymenu.logic_menu.save_check.m_enemy_r:get() and
            utils:count_ally_hero(my_pos, mymenu.logic_menu.save_check.m_ally_r:get()) >=
            utils:count_enemy_hero(my_pos, 1000)

        local enemy_more = #enemy > 0 and
            my_pos:dist(enemy[1].pos) <= mymenu.logic_menu.save_check.l_enemy_r:get() and
            utils:count_ally_hero(my_pos, mymenu.logic_menu.save_check.l_ally_r:get()) <
            utils:count_enemy_hero(my_pos, 1000)

        if not solo and not ally_more and not enemy_more then
            return true
        end

        if solo and not mymenu.logic_menu.save_check.s_ignore:get() and
            utils:get_real_hp_pre(player) <= mymenu.logic_menu.save_check.s_my_hp:get() and
            utils:get_real_hp_pre(enemy[1]) >= mymenu.logic_menu.save_check.s_t_hp:get() and
            player.pos:dist(enemy[1].pos) <= mymenu.logic_menu.save_check.s_r:get() then
            return false
        elseif ally_more and not mymenu.logic_menu.save_check.m_ignore:get() and
            utils:get_real_hp_pre(player) <= mymenu.logic_menu.save_check.m_my_hp:get() and
            self:count_enemy_poly(target.pos2D) > mymenu.logic_menu.save_check.m_enemy:get() then
            return false
        elseif enemy_more and not mymenu.logic_menu.save_check.l_ignore:get() and
            utils:get_real_hp_pre(player) <= mymenu.logic_menu.save_check.l_my_hp:get() and
            self:count_enemy_poly(target.pos2D) > mymenu.logic_menu.save_check.l_enemy:get() then
            return false
        end
    end

    return true
end

function Yasuo:next_e_t(draw)
    if self.e_level == 0 then return nil end

    local e_gap_t = self:can_e_target()
    local e_gap_list = {}

    local player_pos2D = player.pos2D
    local player_attack_range = player.attackRange + player.boundingRadius
    local hud_pos = player.pos + (game.mousePos - player.pos):norm() * 1000
    local my_pos = #self.e_dash == 0 and player.pos or self.e_dash[1].end_pos

    local e_flex = mymenu.combo.e_flex:get()
    local angle = mymenu.combo.e_angle:get()

    --local t_angle = self.kill_t and utils:calc_angle(mousePos2D, player.pos2D, self.kill_t.pos2D)
    local choise_kill_t = self.kill_t and e_flex ~= 0 and self.kill_t.pos:dist(game.mousePos) < e_flex
    --(angle ~= 30 and t_angle < angle or e_flex ~= 0 )

    local e_gap_pos = self.kill_t and choise_kill_t and self.kill_t.pos or hud_pos
    local player_dist_e_gap = my_pos:dist(e_gap_pos)

    if draw then
        -- local target = e_gap_list[1] and e_gap_list[1] or e_kill_t_total and self.kill_t

        -- local color = self.e_ready and 0xffffffff or 0x50ffffff
        -- local line = self.e_ready and 2 or 1
        -- if target and not can_a and not can_q then
        --     graphics.draw_line(self:get_e_pos(target), my_pos, line, color)
        -- end
        -- for _, obj in ipairs(e_gap_list) do
        --     graphics.draw_circle(obj.pos, 30, -1, 0xffffffff, 3)
        -- end
        graphics.draw_line(player.pos, e_gap_pos, 1, 0x90ffffff)
    end
    if draw then return end

    for i = #e_gap_t, 1, -1 do
        local obj = e_gap_t[i]
        local obj_pos = obj.pos
        local obj_pos2D = obj_pos:to2D()

        local all_condition =
        {
            --鼠标在上面，而且可以打到敌人，就删掉全部 (if mouse pos inside, and can hit kill_t)
            self.kill_t and game.mousePos:dist(self.kill_t.pos) < e_flex and utils:in_aa_range(player, self.kill_t),
            --删掉角度外的 (delete out of angle)
            (player_dist_e_gap < 300 or not choise_kill_t) and angle ~= 30 and
            utils:calc_angle(e_gap_pos:to2D(), player_pos2D, obj_pos2D) > angle,
            choise_kill_t and player_dist_e_gap >= 300 and player_dist_e_gap < self:get_e_pos(obj):dist(e_gap_pos) - 200,
            --鼠标内，但还得突进 (inside mouse pos, but need gapcolser)
            choise_kill_t and player_dist_e_gap < e_flex and
            self:get_e_pos(obj):dist(e_gap_pos) > player_attack_range + obj.boundingRadius,
            --Don't E
            not self:can_use_e(obj),
            --is kill_t
            obj == self.kill_t,
            -- to close
            obj_pos:dist(player.pos) < 70 and obj.path.isMoving,
        }
        local should_remove = false
        for _, condition in ipairs(all_condition) do
            if condition then
                should_remove = true
                break
            end
        end

        if not should_remove then
            e_gap_list[#e_gap_list + 1] = obj
        end
    end

    local function sort_points(a, b)
        return a.pos:dist(e_gap_pos) < b.pos:dist(e_gap_pos)
    end

    table.sort(e_gap_list, sort_points)

    local e_buff = utils:get_buff_count(player, "YasuoDashScalar")
    local in_aa = self.kill_t and
        player.pos:dist(self.kill_t.pos) <= player_attack_range + self.kill_t.boundingRadius
    local q_kill_t = self.kill_t and player.pos:dist(self.kill_t.pos) <= self.e_range and
        not in_aa and self.eq_ready
    local e_kill_t_0 = choise_kill_t

    local e_kill_t_1 = q_kill_t and self.Q123 == 3
    local e_kill_t_2 = q_kill_t and self.kill_t and self:can_kill(self.kill_t, 4, 2, 1, 1)
    local e_kill_t_3 = q_kill_t and self.e_level > 3
    local e_kill_t_4 = self.kill_t and player.pos:dist(self.kill_t.pos) <= self.e_range and
        player.pos:dist(self.kill_t.pos) + e_flex < player.pos:dist(hud_pos)
    local e_kill_t_5 = q_kill_t and e_buff and e_buff == 4 and player.levelRef <= 9
    local e_kill_t_6 = self.kill_t and player.pos:dist(self.kill_t.pos) > 460
    local e_kill_t_total = utils:is_valid(self.kill_t) and self:can_use_e(self.kill_t) and e_kill_t_0
        and
        (e_kill_t_1 or e_kill_t_2 or e_kill_t_3 or e_kill_t_4 or e_kill_t_5 or e_kill_t_6)

    local can_a = choise_kill_t and self.kill_t and in_aa
    local can_q = choise_kill_t and self.q_ready and self.kill_t and player.pos:dist(self.kill_t.pos) < self.q_range

    if can_a or can_q then
        return nil
    elseif e_gap_list[1] then
        return e_gap_list[1]
    elseif e_kill_t_total then
        return self.kill_t
    else
        return nil
    end
end

function Yasuo:fly(target)
    if not target then return 0 end

    local fly_1 = target.buff[BUFF_KNOCKUP]
    local fly_2 = target.buff[BUFF_KNOCKBACK]
    if fly_1 then
        return fly_1.endTime - game.time
    elseif fly_2 then
        return fly_2.endTime - game.time
    end
    return 0
end

--aoe and cc time
function Yasuo:check_r_aoe(target)
    local fly_target_list = {}
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        local dist = obj.pos:dist(target.pos)
        if utils:is_valid(obj) and dist < 400 then
            if self:fly(obj) > 0.0 + network.latency then
                fly_target_list[#fly_target_list + 1] = obj
            end
        end
    end

    local function sort_points(a, b)
        return self:fly(a) < self:fly(b)
    end

    table.sort(fly_target_list, sort_points)

    if fly_target_list[1] then
        return #fly_target_list, self:fly(fly_target_list[1])
    end

    return 0, 0
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

-- #region Automatic
local w_loop = 0
function Yasuo:w_dodge()
    if not self.w_ready then return end
    if w_loop > game.time then return end

    if evade then
        for i = evade.core.skillshots.n, 1, -1 do
            local spell = evade.core.skillshots[i]
            if not spell or not spell.name then return end

            if spell:contains(player) then
                local menu0 = mymenu.auto["w_" .. spell.owner.charName]
                if not menu0 then return end

                local menu = mymenu.auto["w_" .. spell.owner.charName][spell.name]
                if not menu then return end

                local start_pos = vec3(spell.start_pos.x, 0, spell.start_pos.y)
                local hit_t = 0
                if spell.data.speed == math.huge then
                    hit_t = 0.2
                else
                    hit_t = start_pos:dist(player.pos) / spell.data.speed
                end

                if hit_t > 0 and 0.2 + network.latency > hit_t and menu:get() >= utils:get_real_hp_pre(player) then
                    player:castSpell('pos', 1, start_pos)
                    w_loop = game.time + 1
                end
            end
        end
        for i = evade.core.targeted.n, 1, -1 do
            local spell = evade.core.targeted[i]
            if not spell or not spell.name or not spell.missile or not spell.target then return end

            if spell.target == player and spell.missile.pos:dist(player.pos) < 250 then
                local menu0 = mymenu.auto["w_" .. spell.owner.charName]
                if not menu0 then return end

                local menu = mymenu.auto["w_" .. spell.owner.charName][spell.name]
                if not menu then return end

                if menu:get() >= utils:get_real_hp_pre(player) then
                    player:castSpell('pos', 1, spell.missile.pos)
                    w_loop = game.time + 1
                end
            end
        end
    end
end

local ks_loop = 0
function Yasuo:ks()
    if ks_loop > game.time then return end
    ks_loop = game.time + 0.3

    local can_ks = utils:use_automatic(mymenu.logic_menu.automatic_menu.ks_turret:get(),
        mymenu.logic_menu.automatic_menu.ks_grass:get(),
        mymenu.logic_menu.automatic_menu.ks_recall:get())
    if not can_ks then return end

    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local obj = Obj[i]
        if utils:is_valid(obj) and not obj.isZombie then
            if self.q_ready and mymenu.auto.q_ks:get() and #self.e_dash == 0 and dmg_lib:Yasuo_Q(player, obj) > utils:get_real_hp(obj) and player.pos:dist(obj.pos) <= self.q_range then
                self.cast_q(obj)
                ks_loop = game.time + 0.1
            elseif self.e_ready and mymenu.auto.e_ks:get() and dmg_lib:Yasuo_E(player, obj) > utils:get_real_hp(obj)
                and
                player.pos:dist(obj.pos) <= self.e_range and Yasuo:can_use_e(obj)
            then
                player:castSpell('obj', 2, obj)
                ks_loop = game.time + 0.1
            end
        end
    end
end

local flash_loop = 0
function Yasuo:Flash_AOE(draw)
    if flash_loop > game.time or self.Q123 ~= 3 or not self.q_ready
        or
        #self.e_dash == 0 or game.time > self.e_dash[1].end_t - network.latency
        or
        not self.r_ready
    then
        return
    end

    local flash = player:findSpellSlot("SummonerFlash")
    if not flash or flash.state ~= 0 then return end

    local point = {}
    for i = 1, 4 do
        local circle = utils:circle_2d(player.pos2D, i * 100, 3 + i * 3)
        for i = 1, #circle do
            local wall = navmesh.isWall(circle[i])
            local evade_check = not evade or (evade and not utils:is_danger_2d_pos(circle[i]))
            if not wall and evade_check then
                point[#point + 1] = circle[i]
            end
        end
    end
    local t = math.max(self.e_dash[1].end_t - 2 * network.latency - game.time, 0)
    local range = t * 1200 + 300

    local flash_pos = nil
    local count = 0
    local e_end_pos_count = utils:count_enemy_hero(self.e_dash[1].end_pos, 150)

    for i = 1, #point do
        local pos = point[i]
        local pos_count = utils:count_enemy_hero(pos:to3D(player.y), 190)
        local offset = utils:count_enemy_hero(pos:to3D(player.y), range)
        local offset_count = pos_count >= offset
        local point_count = pos_count >= count
        local waste_check = pos_count > e_end_pos_count
        if offset_count and point_count and waste_check then
            count = pos_count
            flash_pos = pos:to3D(player.y)
        end
    end

    if draw then
        graphics.draw_circle(self.e_dash[1].end_pos, range, 2, 0xFFFFFFFF, 30)
        for i = 1, #point do
            graphics.draw_circle(point[i]:to3D(player.y), 10, 2, 0xFFFFFFFF, 3)
        end
    end

    --
    local use_eqf_1 = flash_pos and count >= 2
    local use_eqf_2 = flash_pos and count >= 1 and utils:get_real_hp_pre(player) < mymenu.combo.eq_f:get()
    if use_eqf_1 or use_eqf_2 then
        player:castSpell("pos", 0, player.pos)
        player:castSpell("pos", flash.slot, flash_pos)
        flash_loop = game.time + 1
    end
end

function Yasuo:Automatic()
    Yasuo:w_dodge()
    Yasuo:Flash_AOE()

    if player.activeSpell then return end
    Yasuo:ks()
end

-- #endregion

-- #region Combo
local enemy_fly_time = 0
local q_loop = 0

function Yasuo:Combo_Q()
    if not mymenu.combo.q:get() then return end
    if game.time < q_loop then return end
    --if enemy_fly_time > 0 then return end

    local target = Yasuo:next_e_t(false)
    local can_e = target and self.e_ready
    if mymenu.combo.eq:get() and self.eq_ready and #self.e_dash > 0 and self.e_dash[1].end_t > game.time and game.time > self.last_eq_t then
        local last_t = self.e_dash[1].end_t - game.time
        local range = 200 - 250 * last_t
        local can_eq_1 = utils:count_enemy_hero(self.e_dash[1].end_pos, range) > 1

        local can_eq_2 = self.kill_t and self.Q123 == 3 and self.e_dash[1].end_pos:dist(self.kill_t.pos) < range
        local can_eq_3 = false

        local Obj = objManager.enemies
        local Obj_size = objManager.enemies_n
        for i = 0, Obj_size - 1 do
            local enemy = Obj[i]
            if utils:is_valid(enemy) and self.e_dash[1].end_pos:dist(enemy.pos) < range and dmg_lib:Yasuo_Q(player, enemy) > utils:get_real_hp(enemy, true) then
                can_eq_3 = true
                break
            end
        end
        if can_eq_1 or can_eq_2 or can_eq_3 then
            player:castSpell('pos', 0, player.pos)
            self.last_eq_t = game.time + 0.5
            q_loop = game.time + 0.1
            return
        end
    elseif utils:is_evade() == false and mymenu.combo.q:get() and self.q_ready and not can_e and not player.path.isDashing and #self.e_dash == 0 then
        local max_hit = 0
        local max_pos = vec3(0, 0, 0)

        local Obj = objManager.enemies
        local Obj_size = objManager.enemies_n
        for i = 0, Obj_size - 1 do
            local obj = Obj[i]
            local function filter()
                if not utils:is_valid(obj) then return 0, nil end
                if obj.pos:dist(player.pos) > self.q_pred.range then return 0, nil end

                local seg = pred.linear.get_prediction(self.q_pred_aoe, obj)
                if not seg then return 0, nil end

                local col = pred.collision.get_prediction(self.q_pred_aoe, seg, obj)
                if not col then return 0, nil end
                return #col, vec3(seg.endPos.x, obj.pos.y, seg.endPos.y)
            end
            local count, pos = filter()
            if count > max_hit then
                max_hit = count
                max_pos = pos
            end
            --[[
                local seg = pred.linear.get_prediction(self.q_pred_aoe, obj)
                local poly = utils:rectangle_2d(player.pos2D, seg.endPos, self.q_pred.width)
                local count = 0

                if obj and utils:is_valid(obj) and obj.pos:dist(player.pos) < self.q_pred.range and seg then
                    local Obj2 = objManager.enemies
                    local Obj2_size = objManager.enemies_n
                    for i = 0, Obj2_size - 1 do
                        local obj2 = Obj2[i]
                        local obj_path = pred.core.get_pos_after_time(obj2, self.q_pred.delay)
                        local in_poly = utils:contains_2d(obj_path, poly)
                        if obj2 and utils:is_valid(obj2) and obj2 ~= obj and in_poly then
                            count = count + 1
                        end
                    end
                end
                if count >= max_hit then
                    max_hit = count
                    max_pos = vec3(seg.endPos.x, player.pos.y, seg.endPos.y)
                end
            ]]
        end
        if max_hit > 0 and not player.activeSpell then
            player:castSpell('pos', 0, max_pos)
            q_loop = game.time + 0.1
        end

        if self.Q123 == 3 and mymenu.flash:get() then return end
        local q_target = utils:get_target(self.q_range, "AD")
        if utils.orb_t and self.Q123 ~= 3 then
            q_target = utils.orb_t
        end
        if q_target then
            local speed = player.moveSpeed - q_target.moveSpeed * 0.1
            local aa_offset = 0
            if not utils:face(player, q_target.pos) then
                aa_offset = 0
            elseif speed < 0 then
                aa_offset = 0
            elseif speed > 100 then
                aa_offset = 100
            else
                aa_offset = speed
            end
            local in_aa = player.pos:dist(q_target.pos) <=
                player.boundingRadius + q_target.boundingRadius + player.attackRange + aa_offset
            if utils.after_aa_t >= game.time or not in_aa then
                self.cast_q(q_target)
                q_loop = game.time + 0.06
            end
        end
    end
end

function Yasuo:Comno_Q_stack()
    if not self.q_ready or not mymenu.combo.q_stack:get() or not mymenu.combo.q:get() or self.Q123 == 3 then return end

    if game.time < q_loop then return end

    if utils:count_enemy_hero(player.pos, 2000) == 0 then return end

    if self.q_cd >= 1.6 then return end

    if #self.e_dash > 0 and utils:count_enemy_hero(player.pos, 700) == 0 and utils:count_enemy(self.e_dash[1].end_pos, 300, 1, 1, 1, 1, 1, 1) > 0 then
        player:castSpell('pos', 0, player.pos)
        q_loop = game.time + 0.1
    elseif utils:count_enemy_hero(player.pos, 700) == 0 and utils:count_enemy(player.pos, 475, 0, 1, 1, 1, 1, 1) > 0 and #self.e_dash == 0 then
        q_loop = game.time + 0.1
        local q_lc = utils:get_best_lc_pos("line", self.q_pred, 1, false, 0)
        local q_jg = utils:get_best_lc_pos("line", self.q_pred, 1, true, 0)
        if q_lc then
            player:castSpell('pos', 0, q_lc)
        elseif q_jg then
            player:castSpell('pos', 0, q_jg)
        end
    end
end

local e_loop = 0
function Yasuo:Combo_E()
    if not self.e_ready then return end
    if e_loop > game.time then return end
    --if enemy_fly_time > 0 then return end
    local target = Yasuo:next_e_t(false)
    if target and (not player.activeSpell or game.time <= utils.after_aa_t) then
        player:castSpell('obj', 2, target)
        e_loop = game.time + 0.03
    end
end

local r_loop = 0
function Yasuo:Combo_R()
    if not self.r_ready then return end
    if game.time < r_loop then return end

    local player_pos = player.pos
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]

        local function filter()
            if not enemy then return false end
            if not utils:is_valid(enemy) then return false end

            local enemy_pos = enemy.pos
            local dist = player_pos:dist(enemy_pos)
            if dist > self.r_range then return false end

            local fly_cc_time = self:fly(enemy)
            if fly_cc_time == 0 then return false end

            local aoe_count, aoe_cc_time = Yasuo:check_r_aoe(enemy)
            enemy_fly_time = math.min(aoe_cc_time, fly_cc_time)
            if enemy_fly_time == 0 or enemy_fly_time > 0.15 + network.latency then return false end

            local in_turret = utils:in_enemy_turret(enemy_pos)
            local close_turret = utils:close_turret(enemy)
            --waste
            local waste_r_1 = self:can_kill(enemy, 1, 1, 1, 0) and dist < self.q_range
            local waste_r_2 = self:can_kill(enemy, 1, 1, 1, 0) and dist > self.q_range and
                dist < 800 and Yasuo:next_e_t(false)
            local waste_r_3 = Yasuo:dps(enemy, 1) > utils:get_real_hp(enemy, true, true) and
                utils:get_real_hp_pre(player) > 40 and
                dist < self.q_range
            local waste_r_4 = Yasuo:dps(enemy, 2) > utils:get_real_hp(enemy, true, true) and
                utils:get_real_hp_pre(player) > 60 and
                dist < self.q_range
            local dont_waste_r = not (waste_r_1 or waste_r_2 or waste_r_3 or waste_r_4) or
                not mymenu.combo.r_n_waste:get()

            --can kill
            local sec = mymenu.combo.r_can_kill:get()
            local dps_can_kill = Yasuo:dps(enemy, sec) > utils:get_real_hp(enemy, true, true)
            local r_kill_1 = dps_can_kill and
                ((close_turret and enemy_pos:dist(close_turret.pos) > 1200) or not in_turret)
            local r_kill_2 = dps_can_kill and not in_turret
            local r_kill_3 = self:can_kill(enemy, 2, 2, 1, 1) and in_turret
            local r_kill_4 = mymenu.combo.r_sup:get() and utils:count_ally_hero(enemy_pos, 700) > 0 and
                dist > 701
            local r_kill_5 = mymenu.combo.r_sup:get() and utils:count_ally_hero(enemy_pos, 600) > 1
            local r_kill = (r_kill_1 or r_kill_2 or r_kill_3 or r_kill_4 or r_kill_5)

            --dive
            local dive_c = mymenu.dive:get() or (close_turret and enemy_pos:dist(close_turret.pos) > 500) or
                not in_turret

            local all_check = (r_kill and dont_waste_r and dive_c) or aoe_count >= mymenu.combo.r_aoe:get() or
                mymenu.semi_r:get()
            if all_check then return true end
            return false
        end
        r_loop = game.time + 0.1
        if filter() then
            player:castSpell('pos', 3, enemy.pos)
            r_loop = game.time + 1
            enemy_fly_time = 0
            break
        end
    end
end

function Yasuo:Combo()
    if not self.is_combo then return end

    Yasuo:Combo_E()
    Yasuo:Combo_Q()
    Yasuo:Comno_Q_stack()
    Yasuo:Combo_R()
end

-- #endregion

-- #region Mixed
function Yasuo:Mixed_Q()
    if not self.q_ready then return end
    if game.time < q_loop then return end

    local target = utils:get_target(self.q_range, "AD")
    if target then
        local in_aa = player.pos:dist(target.pos) <= player.boundingRadius + target.boundingRadius + player.attackRange
        if utils.after_aa_t >= game.time or not in_aa then
            self.cast_q(target)
            q_loop = game.time + 0.06
        end
    end
end

function Yasuo:Mixed_Q_last_hit()
    if mymenu.harass.q_jg:get() == 3 and mymenu.harass.q_lh:get() == 3 then return end
    if self.Q123 == 3 and utils:count_enemy_hero(player.pos, 1000) > 0 then return end
    if player.activeSpell then return end
    if not self.q_ready then return end
    if game.time < q_loop then return end

    q_loop = game.time + 0.04

    local q_pred = self.q_pred
    local q_pred_speed = q_pred.speed
    local q_pred_delay = q_pred.delay
    local q_minion = {}
    if mymenu.harass.q_lh:get() ~= 3 then
        local Obj = objManager.minions["farm"]
        local Obj_size = objManager.minions.size["farm"]
        for i = 0, Obj_size - 1 do
            local obj = Obj[i]
            local obj_pos = obj.pos
            local player_pos = player.pos
            local dist = player_pos:dist(obj_pos)
            local in_range = dist < self.q_range
            if obj and utils:is_valid_minion(obj) and obj ~= utils.last_aa_target and in_range then
                local hit_t = dist / q_pred_speed + q_pred_delay
                local obj_hp = orb.farm.predict_hp(obj, hit_t)
                local can_kill = mymenu.harass.q_lh:get() == 1 and
                    dmg_lib:Yasuo_Q(player, obj) > obj_hp
                local can_freeze = mymenu.harass.q_lh:get() == 2 and
                    damagelib.calc_aa_damage(player, obj, true) > obj_hp and 1 < obj_hp
                local turret_lc = (utils:in_ally_turret(obj_pos) or utils:in_ally_turret(player_pos)) and
                    dmg_lib:Yasuo_Q(player, obj) > obj_hp
                if in_range and (can_kill or can_freeze or turret_lc) then
                    q_minion[#q_minion + 1] = obj
                end
            end
        end
    end
    if mymenu.harass.q_jg:get() ~= 3 then
        local Obj = objManager.minions[TEAM_NEUTRAL]
        local Obj_size = objManager.minions.size[TEAM_NEUTRAL]
        for i = 0, Obj_size - 1 do
            local obj = Obj[i]
            local obj_pos = obj.pos
            local player_pos = player.pos
            local dist = player_pos:dist(obj_pos)
            local in_range = dist < self.q_range
            if obj and utils:is_valid(obj) and in_range then
                local hit_t = dist / q_pred_speed + q_pred_delay
                local obj_hp = orb.farm.predict_hp(obj, hit_t)
                local pred_kill = mymenu.harass.q_lh:get() == 1 and
                    dmg_lib:Yasuo_Q(player, obj) > obj_hp
                local can_kill = mymenu.harass.q_lh:get() == 2 and dmg_lib:Yasuo_Q(player, obj) > utils:get_real_hp(obj)
                if can_kill or pred_kill then
                    q_minion[#q_minion + 1] = obj
                end
            end
        end
    end

    local function sort_points(a, b)
        return utils:get_real_hp(a) < utils:get_real_hp(b)
    end

    table.sort(q_minion, sort_points)

    if q_minion[1] then
        local hit_t = player.pos:dist(q_minion[1].pos) / q_pred_speed + q_pred_delay
        local pred_pos = utils:check_2Dpath(q_minion[1], hit_t):to3D(q_minion[1].y)
        player:castSpell('pos', 0, pred_pos)
        q_loop = game.time + 0.5
    end

    local count_minion = utils:count_enemy(player.pos, self.q_range + 50, 0, 1, 0, 0, 0, 0)
    local min_hit = count_minion > 3 and 3 or count_minion
    local q_pos = utils:get_best_lc_pos("line", q_pred, min_hit, false, dmg_lib:Yasuo_Q(player) * 0.9)
    if q_pos ~= vec3(0, 0, 0) then
        player:castSpell("pos", 0, q_pos)
        q_loop = game.time + 0.5
    end
end

function Yasuo:Mixed()
    if not self.is_mixed then return end
    if mymenu.harass.q:get() then
        Yasuo:Mixed_Q()
        Yasuo:Mixed_Q_last_hit()
    end
end

-- #endregion

-- #region LaneClear

local lc_loop = 0
function Yasuo:Laneclear()
    if not self.is_laneclear then return end
    if lc_loop > game.time then return end

    local count_minion = utils:count_enemy(player.pos, self.q_range, 0, 1, 0, 0, 0, 0)
    local min_hit = count_minion > 3 and 3 or 1
    local count_monster = utils:count_enemy(player.pos, self.q_range, 0, 0, 1, 1, 1, 1)
    local mon_hit = count_monster > 4 or 4 and count_monster
    local active = player.activeSpell

    if self.q_ready and (not active or game.time <= utils.after_aa_t) and mymenu.lc.q_lc:get() and #self.e_dash == 0
        and
        (utils.time_until_next_aa > 0.2 or utils.time_until_next_aa == 0)
    then
        local q_pred = self.q_pred
        local q_pos = vec3(0, 0, 0)

        if self.q_cd < 1.5 then
            if utils:get_best_lc_pos("line", q_pred, 1, false, 0) ~= vec3(0, 0, 0) then
                q_pos = utils:get_best_lc_pos("line", q_pred, 1, false, 0)
            elseif utils:get_best_lc_pos("line", q_pred, 1, true, 0) ~= vec3(0, 0, 0) then
                q_pos = utils:get_best_lc_pos("line", q_pred, 1, true, 0)
            else
                q_pos = vec3(0, 0, 0)
            end
        else
            if utils:get_best_lc_pos("line", q_pred, min_hit, false, 0) ~= vec3(0, 0, 0) then
                q_pos = utils:get_best_lc_pos("line", q_pred, min_hit, false, 0)
            elseif utils:get_best_lc_pos("line", q_pred, mon_hit, true, 0) ~= vec3(0, 0, 0) then
                q_pos = utils:get_best_lc_pos("line", q_pred, mon_hit, true, 0)
            else
                q_pos = vec3(0, 0, 0)
            end
        end

        if q_pos and q_pos ~= vec3(0, 0, 0) then
            player:castSpell("pos", 0, q_pos)
            lc_loop = game.time + 0.5
        end
    elseif not self.q_ready and (not active or game.time <= utils.after_aa_t) and self.e_ready and utils:count_enemy_hero(player.pos, 1000) == 0 and mymenu.lc.e_lc:get() then
        local can_e_minion = {}
        local Obj = objManager.minions["farm"]
        local Obj_size = objManager.minions.size["farm"]
        for i = 0, Obj_size - 1 do
            local obj = Obj[i]
            local angle = utils:calc_angle(obj.pos2D, player.pos2D, game.mousePos2D) < 60
            local dist = obj.pos:dist(player.pos) < self.e_range
            if obj and utils:is_valid(obj) and angle and dist and utils:get_real_hp(obj) < dmg_lib:Yasuo_E(player, obj) then
                can_e_minion[#can_e_minion + 1] = obj
            end
        end

        local function sort_points(a, b)
            return a.pos:dist(player.pos) < b.pos:dist(player.pos)
        end

        table.sort(can_e_minion, sort_points)

        local is_vaild = can_e_minion[1] and utils:is_valid(can_e_minion[1])
        local not_turret = not utils:in_enemy_turret(self:get_e_pos(can_e_minion[1]))
        if is_vaild and not_turret then
            player:castSpell('obj', 2, can_e_minion[1])
        end
    end
end

-- #endregion

local semi_e_loop = 0
local semi_ew_loop = 0
function Yasuo:Semi_E(draw)
    if not self.e_ready then return end
    if semi_e_loop > game.time then return end
    if not mymenu.semi_e:get() then return end

    local hud_pos_2D = game.mousePos2D
    local player_pos2D = player.pos2D
    local e_gap_t = self:can_e_target()

    local e_dash_list = {}
    for _, dash_point in ipairs(yasuo_dash_pos) do
        local start_pos = dash_point[1]
        if game.mousePos:dist(start_pos) < 300 then
            e_dash_list[#e_dash_list + 1] = dash_point
            if draw then
                graphics.draw_circle(start_pos, 30, 4, 0Xffffffff, 5)
            end
        elseif game.mousePos:dist(start_pos) < 1000 and draw then
            graphics.draw_circle(start_pos, 30, 2, 0X90ffffff, 5)
        end
    end

    if #e_dash_list > 0 then
        orb.core.set_pause_move(0.05)

        table.sort(e_dash_list, function(a, b)
            return game.mousePos:dist(a[1]) < game.mousePos:dist(b[1])
        end)

        local start_pos, end_pos = e_dash_list[1][1], e_dash_list[1][2]

        local line_dash = start_pos + (end_pos - start_pos):norm() * 400
        if draw then
            graphics.draw_line(start_pos, line_dash, 2, 0x99ffffff)
        end
        if draw then return end

        if player.pos:dist(start_pos) > 10 then
            player:move(start_pos)
        else
            local E_target = {}
            local neutral_minions = objManager.minions[TEAM_NEUTRAL]
            for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
                local obj = neutral_minions[i]
                if obj and utils:is_valid(obj) and obj.pos:dist(player) < 475 then
                    local dash_pos = Yasuo:get_e_pos(obj)
                    local dis = player.pos:dist(dash_pos)
                    for i = 0, dis, 10 do
                        local pos = player.pos + (dash_pos - player.pos):norm() * i
                        if navmesh.isWall(pos) then
                            E_target[#E_target + 1] = obj
                            break
                        end
                    end
                end
            end
            table.sort(E_target, function(a, b)
                return end_pos:dist(a.pos) < end_pos:dist(b.pos)
            end)

            if self.w_ready and #E_target == 0 and navmesh.isInFoW(end_pos) and semi_ew_loop < game.time then
                player:castSpell('pos', 1, end_pos)
                semi_ew_loop = game.time + 1
            elseif #E_target > 0 then
                player:castSpell('obj', 2, E_target[1])
                semi_e_loop = game.time + 0.03
            end
        end
    else
        local semi_e_list = {}
        for i = #e_gap_t, 1, -1 do
            local obj = e_gap_t[i]
            local angle = utils:calc_angle(hud_pos_2D, player_pos2D, obj.pos2D)
            if angle < 45 then
                semi_e_list[#semi_e_list + 1] = obj
            end
        end
        local function sort_points(a, b)
            return utils:calc_angle(a.pos2D, player.pos2D, game.mousePos2D) <
                utils:calc_angle(b.pos2D, player.pos2D, game.mousePos2D)
        end

        table.sort(semi_e_list, sort_points)

        if semi_e_list[1] then
            player:castSpell('obj', 2, semi_e_list[1])
            semi_e_loop = game.time + 0.03
        end
    end
end

function Yasuo:Flash_combo()
    if not mymenu.flash:get() then return end

    local flash = player:findSpellSlot("SummonerFlash")
    if not flash or flash.state ~= 0 then return end

    local target = self.kill_t or not self.kill_t and utils:get_target(600, "AD")

    if not target then return end

    if self.e_ready and self.q_ready and self.Q123 == 3 and self.f_use_eq + 5 < game.time and not self.f_use_flash then
        local e_gap_t = {}
        local can_e_target = self:can_e_target()

        for i = #can_e_target, 1, -1 do
            local obj = can_e_target[i]
            if utils:calc_angle(obj.pos2D, player.pos2D, target.pos2D) < 90 and obj ~= target and
                obj.pos:dist(target.pos) < 400 then
                e_gap_t[#e_gap_t + 1] = obj
            end
        end

        if #e_gap_t > 0 then
            table.sort(e_gap_t, function(a, b)
                return utils:calc_angle(a.pos2D, player.pos2D, target.pos2D) <
                    utils:calc_angle(b.pos2D, player.pos2D, target.pos2D)
            end)
            player:castSpell("obj", 2, e_gap_t[1])
            player:castSpell("pos", 0, target.pos)
            self.f_use_flash = true
            self.f_use_eq = game.time --+ 0.2
            return
        elseif target.pos:dist(player.pos) < self.e_range and not utils:has_buff(target, "YasuoE") then
            player:castSpell("obj", 2, target)
            player:castSpell("pos", 0, target.pos)
            self.f_use_flash = true
            self.f_use_eq = game.time --+ 0.2
            return
        end
    elseif target and player.pos:dist(target.pos) < 400 and utils:is_valid(target) and
        #self.e_dash > 0 and self.f_use_eq < game.time and
        self.f_use_flash and self.f_use_eq + 0.2 > game.time then
        player:castSpell("pos", flash.slot, target.pos)
        self.f_use_eq = 0
        self.f_use_flash = false
    end
    if self.f_use_eq + 5 < game.time then
        self.f_use_flash = false
    end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////

function Yasuo:tick()
    if player.isDead then return end
    local target = utils:get_target(1000)
    if target then

    end

    self:spell_check()

    self:Automatic()
    self:Combo()
    self:Mixed()
    self:Laneclear()
    self:Semi_E()
    self:Flash_combo()

    -- print(orb.core.next_attack)
    -- print(orb.core.time_to_next_attack())
    -- print(orb.core.is_winding_up_attack())
end

function Yasuo:slow_tick()
    if player.isDead then return end
end

local spell_emote_0 = {
    ["recall"] = true,
    ["YasuoQ1"] = true,
    ["YasuoQ2"] = true,
    ["YasuoQ3"] = true
}
local spell_emote_3 = {
    ["YasuoE"] = true,
    ["YasuoR"] = true,
}

function Yasuo:process_spell(spell)
    if not spell or player.isDead then return end

    --print(spell.name)

    if spell.owner and spell.owner == player then
        if spell.name == "YasuoQE1" or spell.name == "YasuoQE2" or spell.name == "YasuoQE3" then
            self.use_eq = game.time
        end
        if spell.name == "YasuoE" then
            self.last_e_t = game.time
            table.insert(self.e_dash, {
                is_e_dash = true,
                start_t = game.time,
                end_t = 0,
                start_pos = player.pos,
                end_pos = Yasuo:get_e_pos(spell.target),
                use_eq = false
            })
        end

        if mymenu.auto.cancel_windup:get() then
            local last_aa_t = utils.last_aa_target
            if (self.is_combo and last_aa_t and last_aa_t.type == TYPE_HERO) and utils:get_real_hp_pre(last_aa_t) < 30
                or
                spell.name == "recall"
            then
                if spell_emote_0[spell.name] then
                    game.sendEmote(0)
                end
                if spell_emote_3[spell.name] then
                    game.sendEmote(3)
                end
            end
        end
    end


    -- last_q_t
    -- last_w_t
    -- last_e_t
    -- last_r_t
end

function Yasuo:finish_spell(spell)
    if not spell or player.isDead then return end
end

function Yasuo:on_cast_spell(args)
    if not args or player.isDead then return end
    --print( args.spellSlot)
    local e_gap_t = self:can_e_target()

    local function sort_points(a, b)
        return a.pos:dist(player.pos) > b.pos:dist(player.pos)
    end
    table.sort(e_gap_t, sort_points)

    if args.spellSlot == 3 and #e_gap_t > 0 and player:spellSlot(0).cooldown < 0.58 then
        player:castSpell('obj', 2, e_gap_t[1])
        player:castSpell('pos', 0, mousePos, nil, true)
    end
end

function Yasuo:path(target)
    if not target or player.isDead then return end

    if target == player and target.path.isDashing then
        for i = #self.e_dash, 1, -1 do
            local path = target.path
            local e_dash_list = self.e_dash[i]
            if e_dash_list.is_e_dash == true and e_dash_list.end_t == 0 then
                self.e_dash[i].end_t = path.startPoint:dist(path.endPoint) / path.dashSpeed + game.time
                self.e_dash[i].end_pos = path.endPoint
            end
        end
    end
end

function Yasuo:dmg_output()
    if mymenu.dr.dmg_type:get() == 3 then return end
    local Obj = objManager.enemies
    local Obj_size = objManager.enemies_n
    for i = 0, Obj_size - 1 do
        local enemy = Obj[i]
        --graphics.draw_line_2D(enemy.barPos.x + 163, enemy.barPos.y + 123, enemy.barPos.x + 268, enemy.barPos.y + 123, 11.5 , 0xA5FFFFFF)

        if utils:is_valid(enemy) and enemy.isVisible and enemy.isOnScreen then
            if mymenu.dr.dmg_type:get() == 2 then
                local dmg = { passive = 0, aa = 0, q = 0, w = 0, e = 0, r = 0 }

                if mymenu.dr.q_damage:get() and self.q_ready then
                    dmg.q = dmg_lib:Yasuo_Q(player, enemy)
                end

                if mymenu.dr.e_damage:get() and self.e_ready then
                    dmg.e = dmg_lib:Yasuo_E(player, enemy)
                end

                if mymenu.dr.r_damage:get() and self.r_ready then
                    dmg.r = dmg_lib:Yasuo_R(player, enemy)
                end

                if mymenu.dr.aa_damage:get() > 0 then
                    dmg.aa = damagelib.calc_aa_damage(player, enemy, true) +
                        damagelib.calc_aa_damage(player, enemy, false) * (mymenu.dr.aa_damage:get() - 1)
                end

                utils:draw_hp_bar(enemy, dmg)
            elseif mymenu.dr.dmg_type:get() == 1 then
                local sec = mymenu.combo.r_can_kill:get()
                local dmg = Yasuo:dps(enemy, sec)

                utils:draw_hp_bar(enemy, dmg)
            end
        end
    end
end

local e_target_loop = true
local e_target = graphics.create_effect(graphics.CIRCLE_FILL)
local e_target_out = graphics.create_effect(graphics.CIRCLE_GLOW_BOLD)
function Yasuo:new_draw()
    if player.isDead then return end

    if keyboard.isKeyDown(0x09) then
        e_target:hide()
        e_target_out:hide()
        return
    end

    if mymenu.dr.Q:get() then
        utils:draw_circle("q_range", player.pos, self.q_range, common.drawdr_menu.clr_q:get())
    end
    if mymenu.dr.E:get() and self.e_level > 0 and (not self.q_ready or self.Q123 == 3 or not mymenu.dr.Q:get())
    then
        utils:draw_circle("e_range", player.pos, self.e_range, common.drawdr_menu.clr_e:get())
    end
    if mymenu.dr.R:get() then
        local color = self.r_ready and common.drawdr_menu.clr_r:get() or
            utils:set_alpha(common.drawdr_menu.clr_r:get(), 100)
        utils:draw_circle("r_range", player.pos, self.r_range, color)
        minimap.draw_circle(player.pos, self.r_range, 1, color, 18)
    end

    if mymenu.dr.ts:get() and self.kill_t then
        local kill_t_aa_range = self.kill_t.attackRange + self.kill_t.boundingRadius
        local draw_range = kill_t_aa_range > 300 and 300 or kill_t_aa_range
        --graphics.draw_circle(self.kill_t.pos, draw_range, 2, 0xffff0000, 30)
        e_target:update_circle(self.kill_t.pos, draw_range, 2, 0x35ff0000)
        e_target:show()

        local e_flex = mymenu.combo.e_flex:get()
        --local angle = mymenu.combo.e_angle:get()
        --local t_angle = utils:calc_angle(mousePos2D, player.pos2D, self.kill_t.pos2D)

        local choise_kill_t = e_flex ~= 0 and self.kill_t.pos:dist(game.mousePos) < e_flex
        --angle ~= 30 and t_angle < angle or
        if choise_kill_t then
            --graphics.draw_circle(self.kill_t.pos, e_flex, 3, 0xffff5050, 30)
            e_target_out:show()
            e_target_out:update_circle(self.kill_t.pos, e_flex, 1, 0xffff5050)
        elseif self.kill_t.pos:dist(player.pos) < self.r_range then
            --graphics.draw_circle(self.kill_t.pos, e_flex, 1, 0x60ffffff, 30)
            e_target_out:show()
            e_target_out:update_circle(self.kill_t.pos, e_flex, 1, 0x50ffffff)
        end
        e_target_loop = true
    elseif e_target_loop == true then
        e_target:update_circle(vec3(0, 0, 0), 0, 2, 0x00000000)
        e_target_out:update_circle(vec3(0, 0, 0), 0, 1, 0x00000000)
        e_target_loop = false
    end

    if self.e_dash[1] then
        graphics.draw_line(self.e_dash[1].start_pos, self.e_dash[1].end_pos, 3, 0xFFFFFFFF)
    end

    if mymenu.dr.line:get() then
        Yasuo:next_e_t(true)
    end

    --Yasuo:Flash_AOE(true)
    Yasuo:Semi_E(true)

    self:dmg_output()

    local state_style = utils.menuc.draw_state_menu.state_style:get()
    local text_size = utils.menuc.draw_state_menu.text_size:get()
    local state_color = utils.menuc.draw_state_menu.text_color:get()
    local state_pos = player.pos + vec3(50, 0, -50)
    local p2d = graphics.world_to_screen(state_pos)
    local state_list = {
        { mymenu.sf,     mymenu.dr.sf:get() },
        { mymenu.dive,   mymenu.dr.dive:get() },
        { mymenu.flash,  mymenu.dr.flash:get() },
        { mymenu.semi_e, mymenu.dr.semi_e:get() },
        { mymenu.semi_r, mymenu.dr.semi_r:get() },
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
end

function Yasuo:init()
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

return Yasuo:init()
