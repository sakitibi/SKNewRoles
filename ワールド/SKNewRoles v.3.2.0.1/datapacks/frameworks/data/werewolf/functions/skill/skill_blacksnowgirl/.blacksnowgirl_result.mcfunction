scoreboard players add @s skill_blacksnowgirl_cooltime 0
execute unless score @s skill_blacksnowgirl_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_1
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_2
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_3
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_4
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_5
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_6
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_7
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_8
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_9
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_10
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_11
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_12
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_blacksnowgirl_cooltime matches 0 unless entity @s[scores={seer_madness=0}] run function werewolf:skill/skill_blacksnowgirl/blacksnowgirl_skill/particular/blacksnowgirl_13

#人狼用
execute as @s[team=Blacksnowgirl,scores={skill_blacksnowgirl_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/blacksnowgirl_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_blacksnowgirl_cooltime=0}] run scoreboard players remove @s skill_blacksnowgirl_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_blacksnowgirl_cooltime=0}] run scoreboard players operation @s skill_blacksnowgirl_frequency = GameManager skill_blacksnowgirl_frequency

execute as @s[scores={skill_blacksnowgirl_cooltime=0}] run scoreboard players add @s skill_blacksnowgirl_cooltime 1
