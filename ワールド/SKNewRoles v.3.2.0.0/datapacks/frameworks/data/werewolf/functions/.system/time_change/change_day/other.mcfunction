# スキルのカウント等進行
execute if data storage sys: {time_query:6000} as @a unless score @s skill_ojousama_frequency matches 0 run scoreboard players remove @s skill_ojousama_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_youko_frequency matches 0 run scoreboard players remove @s skill_youko_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_jackal_frequency matches 0 run scoreboard players remove @s skill_jackal_frequency 1

# スキル回復
execute if data storage sys: {time_query:6000} as @a if score @s skill_ojousama_frequency matches 0 unless score @s skill_ojousama_limit matches 0 run scoreboard players set @s skill_ojousama_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_youko_frequency matches 0 unless score @s skill_youko_limit matches 0 run scoreboard players set @s skill_youko_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_jackal_frequency matches 0 unless score @s skill_jackal_limit matches 0 run scoreboard players set @s skill_jackal_cooltime 0