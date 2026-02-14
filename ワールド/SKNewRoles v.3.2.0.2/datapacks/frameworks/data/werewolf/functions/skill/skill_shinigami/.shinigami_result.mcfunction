scoreboard players add @s skill_shinigami_cooltime 0

execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami1
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami2
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami3
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami4
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami5
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami6
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami7
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami8
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami9
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami10
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami11
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami12
execute as @s[team=Shinigami,predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_shinigami_cooltime matches 0 run function werewolf:skill/skill_shinigami/particular/shinigami13

execute as @s[scores={skill_shinigami_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/shinigami_skill/cooltime

execute as @s run function werewolf:skill/skill_shinigami/.shinigami_change_role

execute as @s run tag @s add ex_shinigami

execute as @s[scores={skill_shinigami_cooltime=0}] run scoreboard players add @s skill_shinigami_cooltime 1


