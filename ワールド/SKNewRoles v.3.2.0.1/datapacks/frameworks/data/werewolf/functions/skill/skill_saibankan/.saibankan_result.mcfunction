scoreboard players add @s skill_saibankan_cooltime 0
execute unless score @s skill_saibankan_cooltime matches 0 run tellraw @s {"text":"あなたはもう後任を指名している。"}

execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/1
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/2
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/3
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/4
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/5
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/6
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/7
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/8
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/9
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/10
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/11
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/12
execute as @s[team=Saibankan,predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_saibankan_cooltime matches 0 run function werewolf:skill/skill_saibankan/particular/13

execute as @s[scores={skill_saibankan_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/saibankan_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_saibankan_cooltime=0}] run scoreboard players remove @s skill_saibankan_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_saibankan_cooltime=0}] run scoreboard players operation @s skill_saibankan_frequency = GameManager skill_saibankan_frequency

execute as @s[scores={skill_saibankan_cooltime=0}] run scoreboard players add @s skill_saibankan_cooltime 1