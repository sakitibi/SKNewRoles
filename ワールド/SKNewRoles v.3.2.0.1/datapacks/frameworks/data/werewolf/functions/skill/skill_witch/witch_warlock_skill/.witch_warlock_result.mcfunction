# C#Scripts Compiled by SekaC#
scoreboard players add @s skill_witch_slash_cooltime 0
execute unless score @s skill_witch_slash_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_1
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_2
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_3
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_4
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_5
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_6
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_7
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_8
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_9
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_10
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_11
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_12
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_witch_slash_cooltime matches 0 run function werewolf:skill/skill_witch/witch_warlock_skill/particular/witch_warlock_13

#Witch用
execute if entity @s[team=Witch,tag=Warlock] at @s run function werewolf:skill/skill_witch/witch_warlock_skill/particular/invisibility
execute as @s[team=Witch,tag=Warlock,scores={skill_witch_slash_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/asasine_skill/cooltime
#使用回数を減らす
execute as @s[scores={skill_witch_slash_cooltime=0}] run scoreboard players remove @s skill_witch_slash_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_witch_slash_cooltime=0}] run scoreboard players operation @s skill_witch_slash_frequency = GameManager skill_witch_slash_frequency
execute as @s[scores={skill_witch_slash_cooltime=0}] run scoreboard players add @s skill_witch_slash_cooltime 1