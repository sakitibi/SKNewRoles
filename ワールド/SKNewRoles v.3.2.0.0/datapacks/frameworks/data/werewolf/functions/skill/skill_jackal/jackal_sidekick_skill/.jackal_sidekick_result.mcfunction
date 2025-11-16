scoreboard players add @s skill_jackal_sidekick_cooltime 0
execute unless score @s skill_jackal_sidekick_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_1
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_2
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_3
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_4
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_5
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_6
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_7
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_8
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_9
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_10
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_11
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_12
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_jackal_sidekick_cooltime matches 0 run function werewolf:skill/skill_jackal/jackal_sidekick_skill/particular/jackal_sidekick_13

#人狼用
execute as @s[team=Jackal,scores={skill_jackal_sidekick_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/jackal_sidekick_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_jackal_sidekick_cooltime=0}] run scoreboard players remove @s skill_jackal_sidekick_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_jackal_sidekick_cooltime=0}] run scoreboard players operation @s skill_jackal_sidekick_frequency = GameManager skill_jackal_sidekick_frequency

execute as @s[scores={skill_jackal_sidekick_cooltime=0}] run scoreboard players add @s skill_jackal_sidekick_cooltime 1
