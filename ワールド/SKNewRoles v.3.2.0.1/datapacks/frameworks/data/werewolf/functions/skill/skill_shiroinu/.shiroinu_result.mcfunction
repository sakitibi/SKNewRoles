scoreboard players add @s skill_shiroinu_cooltime 0
execute unless score @s skill_shiroinu_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_1
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_2
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_3
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_4
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_5
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_6
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_7
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_8
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_9
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_10
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_11
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_12
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_shiroinu_cooltime matches 0 run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/shiroinu_13

#人狼用
execute as @s[team=Shiroinu,scores={skill_shiroinu_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/shiroinu_skill/cooltime
#ポンコツ用
execute as @s[team=Ponkotsu,scores={skill_shiroinu_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/shiroinu_skill/cooltime
#アサシン用
execute if entity @s[team=Asasine] at @s run function werewolf:skill/skill_shiroinu/shiroinu_skill/particular/invisibility
execute as @s[team=Asasine,scores={skill_shiroinu_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/asasine_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_shiroinu_cooltime=0}] run scoreboard players remove @s skill_shiroinu_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_shiroinu_cooltime=0}] run scoreboard players operation @s skill_shiroinu_frequency = GameManager skill_shiroinu_frequency

execute as @s[scores={skill_shiroinu_cooltime=0}] run scoreboard players add @s skill_shiroinu_cooltime 1
