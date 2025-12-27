
# スポーン時
    execute if entity @s[tag=!T.HardAlreadyInit] run function True_Crafter_Mode:t.hard/enemy/skeleton/init

# 周囲に敵がいるなら(通常スケ)
    execute if entity @s[predicate=True_Crafter_Mode:t.hard/battle_mode] run function True_Crafter_Mode:t.hard/enemy/skeleton/attack

# 周囲に敵がいるなら(ウィザスケ)
    execute if entity @s[type=wither_skeleton] if entity @e[type=!#True_Crafter_Mode:t.hard/w.skeleton_enemy,tag=!T.HardException,distance=..30] run function True_Crafter_Mode:t.hard/enemy/skeleton/attack_w.ske