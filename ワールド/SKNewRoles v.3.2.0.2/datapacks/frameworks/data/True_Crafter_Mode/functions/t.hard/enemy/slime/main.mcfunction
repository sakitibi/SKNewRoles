
#スポーン時
execute if entity @s[tag=!T.HardAlreadyInit] run function True_Crafter_Mode:t.hard/enemy/slime/init

#周囲に敵がいるなら
execute if entity @s[predicate=True_Crafter_Mode:t.hard/battle_mode] run function True_Crafter_Mode:t.hard/enemy/slime/moveset