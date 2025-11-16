#スポーン時
execute if entity @s[tag=!T.HardAlreadyInit] run function True_Crafter_Mode:t.hard/enemy/piglin_brute/spawn
#周囲に敵がいるなら
execute if entity @e[type=#True_Crafter_Mode:t.hard/piglin_enemy,tag=!T.HardException,distance=..30] run function True_Crafter_Mode:t.hard/enemy/piglin_brute/attack