local Obj_list = {}
--objManager.enemies
--objManager.allies
--objManager.turrets[team][i]
local Obj = objManager.minions[TEAM_ENEMY]
--objManager.enemies_n
--objManager.allies_n
--objManager.turrets.size[team]
--Parameters team can be any of these: TEAM_ALLY/TEAM_ENEMY/TEAM_NEUTRAL / "plants" / "others" / "farm" / "lane_ally" / "lane_enemy" / "pets_ally" / "pets_enemy" / "barrels"
--farm + pets_enemy
local Obj_size = objManager.minions.size[TEAM_ENEMY]
for i=0, Obj_size-1 do
    local obj = Obj[i]
    Obj_list[#Obj_list + 1 ] = obj
end

table.sort(Obj_list, function(a, b)
    return a.health < b.health
end)



--obj.type == TYPE_HERO
--obj.team == TEAM_ENEMY

-- orb.ts

-- last_aa_target

-- function utils:menu_utils(menu_obj)


-- menu_utils 隱藏菜單有問題

-- set_hidden ->set_visible