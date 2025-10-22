scoreboard players add @s skill_jinrou_slash_cooltime 0
execute unless score @s skill_jinrou_slash_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_1
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_2
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_3
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_4
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_5
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_6
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_7
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_8
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_9
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_10
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_11
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_12
execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_jinrou_slash_cooltime matches 0 run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/jinrou_slash_13

#人狼用
execute as @s[team=Jinrou,scores={skill_jinrou_slash_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/jinrou_slash_skill/cooltime
#ポンコツ用
execute as @s[team=Ponkotsu,scores={skill_jinrou_slash_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/jinrou_slash_skill/cooltime
#アサシン用
execute if entity @s[team=Asasine] at @s run function werewolf:skill/skill_jinrou/jinrou_slash_skill/particular/invisibility
execute as @s[team=Asasine,scores={skill_jinrou_slash_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/asasine_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_jinrou_slash_cooltime=0}] run scoreboard players remove @s skill_jinrou_slash_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_jinrou_slash_cooltime=0}] run scoreboard players operation @s skill_jinrou_slash_frequency = GameManager skill_jinrou_slash_frequency

execute as @s[scores={skill_jinrou_slash_cooltime=0}] run scoreboard players add @s skill_jinrou_slash_cooltime 1
