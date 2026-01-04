#罠を可視化する処理
execute at @e[type=marker,tag=pitfall,tag=!inactive] run function werewolf:skill/skill_wanashi/particle

#罠師が離れると罠起動
execute as @e[type=marker,tag=pitfall,tag=inactive] at @s unless entity @a[team=Wanashi,distance=..1.3] run tag @s remove inactive

#罠にかかった時の処理
execute at @e[type=marker,tag=pitfall,tag=!inactive] as @a[tag=player,distance=..1.2] at @s run function werewolf:skill/skill_wanashi/caught_in_a_trap
