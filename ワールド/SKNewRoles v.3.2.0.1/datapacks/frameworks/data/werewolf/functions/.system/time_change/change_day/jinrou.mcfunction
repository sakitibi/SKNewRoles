# スキルのカウント等進行
execute if data storage sys: {time_query:6000} as @a unless score @s skill_jinrou_slash_frequency matches 0 run scoreboard players remove @s skill_jinrou_slash_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_witch_slash_frequency matches 0 run scoreboard players remove @s skill_witch_slash_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_rimokon_slash_frequency matches 0 run scoreboard players remove @s skill_rimokon_slash_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_rimokon_marking_frequency matches 0 run scoreboard players remove @s skill_rimokon_marking_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_rimokon_operation_frequency matches 0 run scoreboard players remove @s skill_rimokon_operation_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_doublekiller_mainslash_frequency matches 0 run scoreboard players remove @s skill_doublekiller_mainslash_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_doublekiller_subslash_frequency matches 0 run scoreboard players remove @s skill_doublekiller_subslash_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_evilseer_slash_frequency matches 0 run scoreboard players remove @s skill_evilseer_slash_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_evilseer_sidekick_frequency matches 0 run scoreboard players remove @s skill_evilseer_sidekick_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_evilguesser_frequency matches 0 run scoreboard players remove @s skill_evilguesser_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_comuner_frequency matches 0 run scoreboard players remove @s skill_comuner_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_wanashi_frequency matches 0 run scoreboard players remove @s skill_wanashi_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_madseer_frequency matches 0 run scoreboard players remove @s skill_madseer_frequency 1
execute if data storage sys: {time_query:6000} as @a unless score @s skill_shiroinu_frequency matches 0 run scoreboard players remove @s skill_shiroinu_frequency 1

# スキル回復
execute if data storage sys: {time_query:6000} as @a if score @s skill_jinrou_slash_frequency matches 0 unless score @s skill_jinrou_slash_limit matches 0 run scoreboard players set @s skill_jinrou_slash_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_witch_slash_frequency matches 0 unless score @s skill_witch_slash_limit matches 0 run scoreboard players set @s skill_witch_slash_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_jackal_slash_frequency matches 0 unless score @s skill_jackal_slash_limit matches 0 run scoreboard players set @s skill_jackal_slash_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_jackal_sidekick_frequency matches 0 unless score @s skill_jackal_sidekick_limit matches 0 run scoreboard players set @s skill_jackal_sidekick_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_rimokon_slash_frequency matches 0 unless score @s skill_rimokon_slash_limit matches 0 run scoreboard players set @s skill_rimokon_slash_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_rimokon_marking_frequency matches 0 unless score @s skill_rimokon_marking_limit matches 0 run scoreboard players set @s skill_rimokon_marking_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_rimokon_operation_frequency matches 0 unless score @s skill_rimokon_operation_limit matches 0 run scoreboard players set @s skill_rimokon_operation_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_doublekiller_mainslash_frequency matches 0 unless score @s skill_doublekiller_mainslash_limit matches 0 run scoreboard players set @s skill_doublekiller_mainslash_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_doublekiller_subslash_frequency matches 0 unless score @s skill_doublekiller_subslash_limit matches 0 run scoreboard players set @s skill_doublekiller_subslash_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_evilguesser_frequency matches 0 unless score @s skill_evilguesser_limit matches 0 run scoreboard players set @s skill_evilguesser_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_evilseer_slash_frequency matches 0 unless score @s skill_evilseer_slash_limit matches 0 run scoreboard players set @s skill_evilseer_slash_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_evilseer_sidekick_frequency matches 0 unless score @s skill_evilseer_sidekick_limit matches 0 run scoreboard players set @s skill_evilseer_sidekick_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_comuner_frequency matches 0 unless score @s skill_comuner_limit matches 0 run scoreboard players set @s skill_comuner_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_wanashi_frequency matches 0 unless score @s skill_wanashi_limit matches 0 run scoreboard players set @s skill_wanashi_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_madseer_frequency matches 0 unless score @s skill_madseer_limit matches 0 run scoreboard players set @s skill_madseer_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_shiroinu_frequency matches 0 unless score @s skill_shiroinu_limit matches 0 run scoreboard players set @s skill_shiroinu_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_kyoujinkusushi_health_frequency matches 0 unless score @s skill_kyoujinkusushi_health_limit matches 0 run scoreboard players set @s skill_kyoujinkusushi_health_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_kyoujinkusushi_kankai_frequency matches 0 unless score @s skill_kyoujinkusushi_kankai_limit matches 0 run scoreboard players set @s skill_kyoujinkusushi_kankai_cooltime 0
execute if data storage sys: {time_query:6000} as @a if score @s skill_poisoner_frequency matches 0 unless score @s skill_poisoner_limit matches 0 run scoreboard players set @s skill_poisoner_cooltime 0