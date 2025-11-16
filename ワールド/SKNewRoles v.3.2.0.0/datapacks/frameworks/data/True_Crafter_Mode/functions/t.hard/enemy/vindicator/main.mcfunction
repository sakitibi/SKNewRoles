#スポーン時
execute if entity @s[tag=!T.HardAlreadyInit] run function True_Crafter_Mode:t.hard/enemy/vindicator/vindicator_change

#周囲に敵がいるなら
execute if entity @e[type=#True_Crafter_Mode:t.hard/zombie_enemy,tag=!T.HardException,distance=..30] run function True_Crafter_Mode:t.hard/enemy/vindicator/attack
