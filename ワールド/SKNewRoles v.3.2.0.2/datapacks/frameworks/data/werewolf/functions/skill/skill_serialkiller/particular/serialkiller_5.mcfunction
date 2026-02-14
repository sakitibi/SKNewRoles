#通常
execute if entity @s[team=Serialkiller] run damage @a[tag=5,limit=1] 0.01 fall by @s
execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_countdown 2400
execute if score GameManager skill_serialkiller_frequency matches 1 run execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_killcooldown 20
execute if score GameManager skill_serialkiller_frequency matches 2 run execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_killcooldown 40
execute if score GameManager skill_serialkiller_frequency matches 3 run execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_killcooldown 60
execute if entity @s[team=Serialkiller] as @s at @s run function werewolf:.system/player_attacked/sword_effect