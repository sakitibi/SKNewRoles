scoreboard players add @s skill_hoankan_cooltime 0
execute unless score @s skill_hoankan_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan1
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan2
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan3
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan4
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan5
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan6
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan7
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan8
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan9
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan10
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan11
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan12
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_hoankan_cooltime matches 0 run function werewolf:skill/skill_hoankan/particular/hoankan13

execute as @s[scores={skill_hoankan_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/hoankan_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_hoankan_cooltime=0}] run scoreboard players remove @s skill_hoankan_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_hoankan_cooltime=0}] run scoreboard players operation @s skill_hoankan_frequency = GameManager skill_hoankan_frequency

execute as @s[scores={skill_hoankan_cooltime=0}] run scoreboard players add @s skill_hoankan_cooltime 1
