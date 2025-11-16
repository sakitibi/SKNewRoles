
# スポーン時
    execute if entity @s[tag=!T.HardAlreadyInit] run function True_Crafter_Mode:t.hard/enemy/spider/init

# 周囲に敵がいるなら
    execute if entity @s[predicate=True_Crafter_Mode:t.hard/battle_mode] run function True_Crafter_Mode:t.hard/enemy/spider/moveset

# スコアリセット
    execute unless entity @s[predicate=True_Crafter_Mode:t.hard/battle_mode] run scoreboard players reset @s T.HardMoveset1
    execute unless entity @s[predicate=True_Crafter_Mode:t.hard/battle_mode] run scoreboard players reset @s T.HardMoveset2