scoreboard players add @s skill_jibakuma_bomb_cooltime 0
execute unless score @s skill_jibakuma_bomb_cooltime matches 0 run tellraw @s {"text":"今はまだ使えない。"}

execute if score @s skill_jibakuma_bomb_cooltime matches 0 run function werewolf:skill/skill_jibakuma/jibakuma_bomb_skill/particular/1

#人狼用
execute as @s[team=Jibakuma,scores={skill_jibakuma_bomb_cooltime=0}] run loot replace entity @s weapon.mainhand loot werewolf:skill/jibakuma_bomb_skill/cooltime

#使用回数を減らす
execute as @s[scores={skill_jibakuma_bomb_cooltime=0}] run scoreboard players remove @s skill_jibakuma_bomb_limit 1
#回復タイミングのカウントを開始
execute as @s[scores={skill_jibakuma_bomb_cooltime=0}] run scoreboard players operation @s skill_jibakuma_bomb_frequency = GameManager skill_jibakuma_bomb_frequency

execute as @s[scores={skill_jibakuma_bomb_cooltime=0}] run scoreboard players add @s skill_jibakuma_bomb_cooltime 1
