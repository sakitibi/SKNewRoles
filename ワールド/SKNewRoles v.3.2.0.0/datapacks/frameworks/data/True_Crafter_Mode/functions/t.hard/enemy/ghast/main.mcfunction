
# 火の玉をなんか別のものに変換
    execute as @e[type=fireball,limit=1,distance=..6,sort=nearest,tag=!T.HardGhastBulletDisplay,tag=!T.HardAlreadyInit] at @s run function True_Crafter_Mode:t.hard/enemy/ghast/shoot_fireball 
