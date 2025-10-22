#スポーン時
execute if entity @s[tag=!T.HardAlreadyInit] run function True_Crafter_Mode:t.hard/enemy/enderman/spawn
#周囲に敵がいるなら
execute if entity @a[tag=!T.HardException,distance=..30] run function True_Crafter_Mode:t.hard/enemy/enderman/attack