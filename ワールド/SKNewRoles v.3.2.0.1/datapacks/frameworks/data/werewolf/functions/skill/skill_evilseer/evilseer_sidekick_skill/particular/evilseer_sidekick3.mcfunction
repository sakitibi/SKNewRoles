execute if entity @a[tag=3,team=!Kyoushin] run tellraw @s [{"selector":"@a[tag=3]"},{"text":"を狂わせた。"}]
execute as @a[tag=3,team=!Kyoushin] run tellraw @s {"text":"あなたは狂信者になった。"}
scoreboard players remove @s seer_madness 1

execute as @a[tag=3] run function werewolf:skill/skill_evilseer/change_role