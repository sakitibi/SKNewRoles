# スキルのカウント等進行
execute if data storage sys: {time_query:6000} as @a unless score @s skill_uranai_frequency matches 0 run scoreboard players remove @s skill_uranai_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_reinou_frequency matches 0 run scoreboard players remove @s skill_reinou_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_kishi_frequency matches 0 run scoreboard players remove @s skill_kishi_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_hoankan_frequency matches 0 run scoreboard players remove @s skill_hoankan_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_saibankan_frequency matches 0 run scoreboard players remove @s skill_saibankan_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_niceteleporter_frequency matches 0 run scoreboard players remove @s skill_niceteleporter_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_hanazonogirl_frequency matches 0 run scoreboard players remove @s skill_hanazonogirl_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_forest_frequency matches 0 run scoreboard players remove @s skill_forest_frequency 1
# スキル回復
execute if data storage sys: {time_query:6000} as @a if score @s skill_uranai_frequency matches 0 unless score @s skill_uranai_limit matches 0 run scoreboard players set @s skill_uranai_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_reinou_frequency matches 0 unless score @s skill_reinou_limit matches 0 run scoreboard players set @s skill_reinou_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_kishi_frequency matches 0 unless score @s skill_kishi_limit matches 0 run scoreboard players set @s skill_kishi_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_hoankan_frequency matches 0 unless score @s skill_hoankan_limit matches 0 run scoreboard players set @s skill_hoankan_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_saibankan_frequency matches 0 unless score @s skill_saibankan_limit matches 0 run scoreboard players set @s skill_saibankan_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_niceteleporter_frequency matches 0 unless score @s skill_niceteleporter_limit matches 0 run scoreboard players set @s skill_niceteleporter_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_sakenomikoto_frequency matches 0 unless score @s skill_sakenomikoto_limit matches 0 run scoreboard players set @s skill_sakenomikoto_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_hanazonogirl_frequency matches 0 unless score @s skill_hanazonogirl_limit matches 0 run scoreboard players set @s skill_hanazonogirl_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_forest_frequency matches 0 unless score @s skill_forest_limit matches 0 run scoreboard players set @s skill_forest_cooltime 0