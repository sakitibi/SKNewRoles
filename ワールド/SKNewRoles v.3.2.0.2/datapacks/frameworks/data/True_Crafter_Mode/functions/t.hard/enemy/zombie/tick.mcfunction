# スポーン時
    execute if entity @s[tag=!T.HardAlreadyInit] run function True_Crafter_Mode:t.hard/enemy/zombie/init

# 周囲に敵がいるなら
    execute if entity @e[predicate=True_Crafter_Mode:t.hard/battle_mode] run function True_Crafter_Mode:t.hard/enemy/zombie/moveset

# 自身がゾンビピグリンなら常時敵対
    data modify entity @s[type=zombified_piglin] AngryAt set from entity @p[tag=!T.HardException] UUID

# スコアリセット
    execute unless entity @s[predicate=True_Crafter_Mode:t.hard/battle_mode] run scoreboard players reset @s T.HardMoveset1