scoreboard players add @s skill_rimokon_marking_cooltime 0
execute unless score @s skill_rimokon_marking_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_1
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_2
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_3
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_4
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_5
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_6
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_7
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_8
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_9
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_10
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_11
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_12
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_rimokon_marking_cooltime matches 0 run function werewolf:skill/skill_rimokon/rimokon_marking_skill/particular/rimokon_marking_13

execute as @s[team=rimokon,scores={skill_rimokon_marking_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/rimokon_marking_skill/cooltime
#使用回数を減らす
execute as @s[scores={skill_rimokon_marking_cooltime=0}] run scoreboard players remove @s skill_rimokon_marking_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_rimokon_marking_cooltime=0}] run scoreboard players operation @s skill_rimokon_marking_frequency = GameManager skill_rimokon_marking_frequency

execute as @s[scores={skill_rimokon_marking_cooltime=0}] run scoreboard players add @s skill_rimokon_marking_cooltime 1