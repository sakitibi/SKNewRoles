scoreboard players add @s skill_ojousama_cooltime 0
execute unless score @s skill_ojousama_cooltime matches 0 run tellraw @s {"text":"あなたのワガママはもう聞いてもらえない…"}
execute as @s if score @s skill_ojousama_cooltime matches 0 unless score GameManager event_timer matches -1 run tellraw @s {"text":"今はまだ使えない。"}

#通常
execute if score GameManager event_timer matches -1 as @s[team=Ojousama] if score @s skill_ojousama_cooltime matches 0 run function werewolf:skill/skill_ojousama/particular/1
#ポンコツ
execute if score GameManager event_timer matches -1 as @s[team=Ponkotsu] if score @s skill_ojousama_cooltime matches 0 run function werewolf:skill/skill_ojousama/particular/2

execute if score GameManager event_timer matches -1 as @s[scores={skill_ojousama_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/ojousama_skill/cooltime

#使用回数を減らす
execute if score GameManager event_timer matches -1 as @s[scores={skill_ojousama_cooltime=0}] run scoreboard players remove @s skill_ojousama_limit 1
#回復タイミングのカウントを開始
execute if score GameManager event_timer matches -1 as @s[scores={skill_ojousama_cooltime=0}] run scoreboard players operation @s skill_ojousama_frequency = GameManager skill_ojousama_frequency

execute if score GameManager event_timer matches -1 as @s[scores={skill_ojousama_cooltime=0}] run scoreboard players add @s skill_ojousama_cooltime 1


#イベント判定を進行
execute if score GameManager event_timer matches -1 as @s[scores={skill_ojousama_cooltime=0}] run scoreboard players set GameManager event_timer -2