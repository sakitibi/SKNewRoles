scoreboard players add @s skill_uranai_cooltime 0
execute unless score @s skill_uranai_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai1
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai2
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai3
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai4
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai5
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai6
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai7
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai8
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai9
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai10
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai11
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai12
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_uranai_cooltime matches 0 run function werewolf:skill/skill_uranai/particular/uranai13

execute as @s[scores={skill_uranai_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/uranai_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_uranai_cooltime=0}] run scoreboard players remove @s skill_uranai_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_uranai_cooltime=0}] run scoreboard players operation @s skill_uranai_frequency = GameManager skill_uranai_frequency

execute as @s[scores={skill_uranai_cooltime=0}] run scoreboard players add @s skill_uranai_cooltime 1
