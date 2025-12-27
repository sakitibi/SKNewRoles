scoreboard players add @s skill_kishi_cooltime 0
execute unless score @s skill_kishi_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute if score @s skill_kishi_cooltime matches 0 if entity @a[scores={skill_kishi_protected=1}] run tellraw @s[team=Kishi] {"text":"あなたは今も誰かを護っている。"}

#使用回数を減らす
execute if score @s skill_kishi_cooltime matches 0 if entity @a[scores={skill_kishi_protected=0}] as @s[scores={skill_kishi_cooltime=0}] run scoreboard players remove @s skill_kishi_limit 1
#回復タイミングのカウントを開始
execute if score @s skill_kishi_cooltime matches 0 if entity @a[scores={skill_kishi_protected=0}] as @s[scores={skill_kishi_cooltime=0}] run scoreboard players operation @s skill_kishi_frequency = GameManager skill_kishi_frequency

#騎士
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi1
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi2
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi3
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi4
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi5
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi6
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi7
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi8
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi9
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi10
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi11
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi12
execute unless entity @a[team=Kishi,scores={skill_kishi_protected=1}] as @s[team=Kishi,predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi13
#ポンコツ
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_1] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi1
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_2] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi2
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_3] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi3
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_4] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi4
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_5] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi5
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_6] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi6
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_7] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi7
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_8] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi8
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_9] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi9
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_10] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi10
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_11] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi11
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_12] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi12
execute as @s[team=Ponkotsu,predicate=werewolf:look_at/look_at_player/look_at_player_13] if score @s skill_kishi_cooltime matches 0 run function werewolf:skill/skill_kishi/particular/kishi13