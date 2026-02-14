scoreboard players add @s skill_poisoner_cooltime 0
execute unless score @s skill_poisoner_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}
execute unless entity @s[scores={poisoner_killcooldown=1..}]  0 run tellraw @s {"text":"今はまだ使えない。"}

execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_1
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_2
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_3
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_4
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_5
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_6
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_7
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_8
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_9
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_10
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_11
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_12
execute if score GameManager meeting matches 0 run execute as @s[predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_poisoner_cooltime matches 0 run function werewolf:skill/skill_poisoner/poisoner_skill/particular/poisoner_13
execute unless score GameManager meeting matches 0 run tellraw @s {"text":"今はまだ使えない。"}

#人狼用
execute as @s[team=Poisoner,scores={skill_poisoner_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/poisoner_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_poisoner_cooltime=0}] run scoreboard players remove @s skill_poisoner_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_poisoner_cooltime=0}] run scoreboard players operation @s skill_poisoner_frequency = GameManager skill_poisoner_frequency

execute as @s[scores={skill_poisoner_cooltime=0}] run scoreboard players add @s skill_poisoner_cooltime 1
