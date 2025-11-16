scoreboard players add @s skill_youko_cooltime 0
execute unless score @s skill_youko_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko1
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko2
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko3
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko4
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko5
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko6
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko7
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko8
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko9
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko10
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko11
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko12
execute as @s[team=Youko,predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_youko_cooltime matches 0 run function werewolf:skill/skill_youko/particular/youko13

execute as @s[scores={skill_youko_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/youko_skill/cooltime

#使用回数を減らす
execute as @s[team=Youko,scores={skill_youko_cooltime=0}] run scoreboard players remove @s skill_youko_limit 1
#回復タイミングのカウントを開始
execute as @s[team=Youko,scores={skill_youko_cooltime=0}] run scoreboard players operation @s skill_youko_frequency = GameManager skill_youko_frequency

execute as @s[scores={skill_youko_cooltime=0}] run scoreboard players add @s skill_youko_cooltime 1


