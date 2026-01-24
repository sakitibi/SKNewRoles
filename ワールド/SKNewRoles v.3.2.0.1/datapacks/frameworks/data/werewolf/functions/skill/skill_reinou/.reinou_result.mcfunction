scoreboard players add @s skill_reinou_cooltime 0
execute unless score @s skill_reinou_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_1] run function werewolf:skill/skill_reinou/particular/reinou1
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_2] run function werewolf:skill/skill_reinou/particular/reinou2
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_3] run function werewolf:skill/skill_reinou/particular/reinou3
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_4] run function werewolf:skill/skill_reinou/particular/reinou4
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_5] run function werewolf:skill/skill_reinou/particular/reinou5
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_6] run function werewolf:skill/skill_reinou/particular/reinou6
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_7] run function werewolf:skill/skill_reinou/particular/reinou7
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_8] run function werewolf:skill/skill_reinou/particular/reinou8
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_9] run function werewolf:skill/skill_reinou/particular/reinou9
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_10] run function werewolf:skill/skill_reinou/particular/reinou10
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_11] run function werewolf:skill/skill_reinou/particular/reinou11
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_12] run function werewolf:skill/skill_reinou/particular/reinou12
execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:have_skill/reinou_skill,predicate=werewolf:look_at/look_at_grave,predicate=werewolf:look_at/look_at_player/look_at_player_13] run function werewolf:skill/skill_reinou/particular/reinou13

execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:look_at/look_at_grave,predicate=werewolf:have_item/have_reinou_tool] run loot replace entity @s weapon.mainhand loot werewolf:skill/reinou_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_reinou_cooltime=0}] run scoreboard players remove @s skill_reinou_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_reinou_cooltime=0}] run scoreboard players operation @s skill_reinou_frequency = GameManager skill_reinou_frequency

execute as @s[scores={skill_reinou_cooltime=0},predicate=werewolf:look_at/look_at_grave] if score @s skill_reinou_cooltime matches 0 run scoreboard players set @s skill_reinou_cooltime 1

advancement revoke @s only werewolf:used_skill/reinou_skill
advancement revoke @s only werewolf:used_skill/reinou_skill_cooltime