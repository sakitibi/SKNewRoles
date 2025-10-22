scoreboard players add @s skill_niceteleporter_cooltime 0
execute as @s if score @s skill_niceteleporter_cooltime matches 0 unless score GameManager event_timer matches -1 run tellraw @s {"text":"今はまだ使えない。"}

execute if score GameManager event_timer matches -1 as @s[team=Niceteleporter] if score @s skill_niceteleporter_cooltime matches 0 run function werewolf:skill/skill_niceteleporter/particular/1
execute if score GameManager event_timer matches -1 as @s[scores={skill_niceteleporter_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/niceteleporter_skill/cooltime

#使用回数を減らす
execute if score GameManager event_timer matches -1 as @s[scores={skill_niceteleporter_cooltime=0}] run scoreboard players remove @s skill_niceteleporter_limit 1
#回復タイミングのカウントを開始
execute if score GameManager event_timer matches -1 as @s[scores={skill_niceteleporter_cooltime=0}] run scoreboard players operation @s skill_niceteleporter_frequency = GameManager skill_niceteleporter_frequency

execute if score GameManager event_timer matches -1 as @s[scores={skill_niceteleporter_cooltime=0}] run scoreboard players add @s skill_niceteleporter_cooltime 1


#イベント判定を進行
execute if score GameManager event_timer matches -1 as @s[scores={skill_niceteleporter_cooltime=0}] run scoreboard players set GameManager event_timer -2