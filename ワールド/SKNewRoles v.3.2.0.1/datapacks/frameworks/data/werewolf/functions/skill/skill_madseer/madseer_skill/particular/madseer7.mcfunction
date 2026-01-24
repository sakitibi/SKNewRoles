execute if entity @a[tag=7,team=!Kyoushin] run tellraw @s [{"selector":"@a[tag=7]"},{"text":"を狂わせた。"}]
execute as @a[tag=7,team=!Kyoushin] run tellraw @s {"text":"あなたは狂信者になった。"}
scoreboard players remove @s seer_madness 1

execute as @a[tag=7] run function werewolf:skill/skill_madseer/change_role