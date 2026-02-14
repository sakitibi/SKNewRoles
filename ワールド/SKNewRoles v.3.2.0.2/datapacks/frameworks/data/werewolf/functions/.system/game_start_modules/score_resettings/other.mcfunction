scoreboard players set @a skill_ojousama_cooltime 0
scoreboard players operation @a skill_ojousama_limit = GameManager skill_ojousama_limit
scoreboard players set @a skill_ojousama_frequency 0

scoreboard players set @a skill_youko_cooltime 0
scoreboard players operation @a skill_youko_limit = GameManager skill_youko_limit
scoreboard players set @a skill_youko_frequency 0

scoreboard players set @a skill_shinigami_cooltime 0

scoreboard players set @a skill_jackal_slash_cooltime 0
scoreboard players operation @a skill_jackal_slash_limit = GameManager skill_jackal_slash_limit
scoreboard players set @a skill_jackal_slash_frequency 0
scoreboard players set @a skill_jackal_sidekick_cooltime 0
scoreboard players operation @a skill_jackal_sidekick_limit = GameManager skill_jackal_sidekick_limit
scoreboard players set @a skill_jackal_sidekick_frequency 0

scoreboard players set GameManager lovers_full 0
scoreboard players set @a skill_cupid_cooltime 0
scoreboard players reset @s charge_cupid_arrow

function werewolf:skill/skill_cupid/cooltime/setup