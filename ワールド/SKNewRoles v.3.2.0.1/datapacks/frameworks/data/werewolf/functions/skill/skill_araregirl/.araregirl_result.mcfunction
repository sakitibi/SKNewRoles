scoreboard players add @s skill_araregirl_cooltime 0
execute unless score @s skill_araregirl_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_1
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_2
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_3
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_4
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_5
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_6
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_7
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_8
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_9
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_10
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_11
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_12
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_araregirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_araregirl/araregirl_skill/particular/araregirl_13

#人狼用
execute as @s[team=Araregirl,scores={skill_araregirl_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/araregirl_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_araregirl_cooltime=0}] run scoreboard players remove @s skill_araregirl_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_araregirl_cooltime=0}] run scoreboard players operation @s skill_araregirl_frequency = GameManager skill_araregirl_frequency

execute as @s[scores={skill_araregirl_cooltime=0}] run scoreboard players add @s skill_araregirl_cooltime 1
