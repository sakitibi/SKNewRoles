scoreboard players add @s skill_hanazonogirl_cooltime 0
execute unless score @s skill_hanazonogirl_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl1
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl2
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl3
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl4
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl5
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl6
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl7
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl8
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl9
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl10
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl11
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl12
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_hanazonogirl_cooltime matches 0 run function werewolf:skill/skill_hanazonogirl/particular/hanazonogirl13

execute as @s[scores={skill_hanazonogirl_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/hanazonogirl_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_hanazonogirl_cooltime=0}] run scoreboard players remove @s skill_hanazonogirl_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_hanazonogirl_cooltime=0}] run scoreboard players operation @s skill_hanazonogirl_frequency = GameManager skill_hanazonogirl_frequency

execute as @s[scores={skill_hanazonogirl_cooltime=0}] run scoreboard players add @s skill_hanazonogirl_cooltime 1
