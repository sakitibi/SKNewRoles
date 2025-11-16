
# スポーン時
    execute if entity @s[tag=!T.HardAlreadyInit] run function True_Crafter_Mode:t.hard/enemy/piglin/init

# 周囲に敵がいるなら
    execute if entity @s[nbt=!{IsBaby:1b}] if entity @e[type=#True_Crafter_Mode:t.hard/piglin_enemy,tag=!T.HardException,distance=..30] run function True_Crafter_Mode:t.hard/enemy/piglin/moveset