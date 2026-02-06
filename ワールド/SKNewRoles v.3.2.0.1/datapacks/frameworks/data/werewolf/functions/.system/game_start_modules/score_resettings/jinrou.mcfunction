scoreboard players set @a skill_jinrou_slash_cooltime 0
scoreboard players operation @a skill_jinrou_slash_limit = GameManager skill_jinrou_slash_limit
scoreboard players set @a skill_jinrou_slash_frequency 0
scoreboard players set @a skill_jinrou_roar_cooltime 0
scoreboard players reset @s charge_roar
function werewolf:skill/skill_jinrou/jinrou_roar_skill/cooltime/setup

scoreboard players set @a skill_witch_slash_cooltime 0
scoreboard players operation @a skill_witch_slash_limit = GameManager skill_witch_slash_limit
scoreboard players set @a skill_witch_slash_frequency 0
scoreboard players set @a skill_witch_roar_cooltime 0
scoreboard players reset @s charge_roar
function werewolf:skill/skill_witch/witch_roar_skill/cooltime/setup

scoreboard players set @a skill_rimokon_slash_cooltime 0
scoreboard players operation @a skill_rimokon_slash_limit = GameManager skill_rimokon_slash_limit
scoreboard players set @a skill_rimokon_slash_frequency 0
scoreboard players set @a skill_rimokon_marking_cooltime 0
scoreboard players operation @a skill_rimokon_marking_limit = GameManager skill_rimokon_marking_limit
scoreboard players set @a skill_rimokon_marking_frequency 0
scoreboard players set @a skill_rimokon_operation_cooltime 0
scoreboard players operation @a skill_rimokon_operation_limit = GameManager skill_rimokon_operation_limit
scoreboard players set @a skill_rimokon_operation_frequency 0

scoreboard players set @a skill_doublekiller_mainslash_cooltime 0
scoreboard players mainslash @a skill_doublekiller_mainslash_limit = GameManager skill_doublekiller_mainslash_limit
scoreboard players set @a skill_doublekiller_mainslash_frequency 0
scoreboard players set @a skill_doublekiller_subslash_cooltime 0
scoreboard players subslash @a skill_doublekiller_subslash_limit = GameManager skill_doublekiller_subslash_limit
scoreboard players set @a skill_doublekiller_subslash_frequency 0

scoreboard players set @a skill_evilguesser_cooltime 0
scoreboard players subslash @a skill_evilguesser_limit = GameManager skill_evilguesser_limit
scoreboard players set @a skill_evilguesser_frequency 0

scoreboard players set @a skill_sniper_cooltime 0
scoreboard players reset @s charge_roar
function werewolf:skill/skill_sniper/cooltime/setup

scoreboard players set @a skill_evilseer_slash_cooltime 0
scoreboard players operation @a skill_evilseer_slash_limit = GameManager skill_evilseer_slash_limit
scoreboard players set @a skill_evilseer_slash_frequency 0
scoreboard players set @a skill_evilseer_sidekick_cooltime 0
scoreboard players operation @a skill_evilseer_sidekick_limit = GameManager skill_evilseer_sidekick_limit
scoreboard players set @a skill_evilseer_sidekick_frequency 0

scoreboard players set @a skill_comuner_cooltime 0
scoreboard players subslash @a skill_comuner_limit = GameManager skill_comuner_limit
scoreboard players set @a skill_comuner_frequency 0

execute unless GameManager skill_serialkiller_frequency matches 0 run scoreboard players set GameManager skill_serialkiller_frequency 1
execute if score GameManager skill_serialkiller_frequency matches 1 run execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_killcooldown 20
execute if score GameManager skill_serialkiller_frequency matches 2 run execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_killcooldown 40
execute if score GameManager skill_serialkiller_frequency matches 3 run execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_killcooldown 60

scoreboard players set @a skill_wanashi_cooltime 0
scoreboard players set @a fall_into_a_pitfall 0
function werewolf:skill/skill_wanashi/cooltime/setup

scoreboard players set @a skill_madseer_cooltime 0
scoreboard players operation @a skill_madseer_limit = GameManager skill_madseer_limit
scoreboard players set @a skill_madseer_frequency 0