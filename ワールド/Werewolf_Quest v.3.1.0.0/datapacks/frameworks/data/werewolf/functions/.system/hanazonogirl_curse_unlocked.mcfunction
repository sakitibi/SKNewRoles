# 呪い解除処理
scoreboard players remove @a[tag=warlock_curse,tag=hanazonogirl_unlocked_curse] warlock_curse 1
execute unless entity @a[tag=!warlock_curse,tag=!hanazonogirl_unlocked_curse] run scoreboard players add @s skill_hanazonogirl_unlocked_curse 1
execute unless entity @a[tag=!warlock_curse,tag=!hanazonogirl_unlocked_curse] run tag @s[scores={warlock_curse=..0}] remove warlock_curse
scoreboard players reset @a[tag=hanazonogirl_unlocked_curse,scores={warlock_curse=..0}] warlock_curse
scoreboard players reset @a[tag=hanazonogirl_unlocked_curse] skill_hanazonogirl_unlocked_curse
tag @a[tag=hanazonogirl_unlocked_curse] remove warlock_curse
# 呪い防御処理
execute as @a[tag=warlock_curse_protected] run tellraw @a[team=Hanazonogirl] [{"selector":"@s","color":"green"},{"text":"を呪いから守った!","color":"green"}]
execute as @a[tag=warlock_curse_protected] run tag @s remove warlock_curse_protected