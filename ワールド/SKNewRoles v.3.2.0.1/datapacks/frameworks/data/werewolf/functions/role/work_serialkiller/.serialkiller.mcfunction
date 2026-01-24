# 猶予系
    execute if entity @s[scores={serialkiller_countdown=1..}] run scoreboard players remove @s[scores={serialkiller_countdown=1..}] serialkiller_countdown 1
    execute if entity @s[scores={serialkiller_countdown=..0}] run kill @s[scores={serialkiller_countdown=..0}]
    execute if entity @s[scores={serialkiller_countdown=..0}] run scoreboard players reset @s[scores={serialkiller_countdown=..0}] serialkiller_countdown
# キルクール系
    execute as @s[scores={serialkiller_killcooldown=0}] run function werewolf:skill/.switch_skill/.set_skill_serialkiller_onwards