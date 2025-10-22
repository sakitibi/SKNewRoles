#罠を可視化する処理
execute as @e[type=item,tag=pitfall_dummy,tag=!inactive] at @s on origin run function werewolf:skill/skill_wanashi/particle_dummy

#ポンコツ罠師が離れると罠起動
execute as @e[type=item,tag=pitfall_dummy,tag=inactive] at @s unless entity @a[team=Ponkotsu,tag=wanashi_dummy,distance=..1.3] run tag @s remove inactive