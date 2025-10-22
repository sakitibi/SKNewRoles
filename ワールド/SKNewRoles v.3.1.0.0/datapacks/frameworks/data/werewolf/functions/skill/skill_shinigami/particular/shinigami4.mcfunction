execute as @a[tag=4] run function werewolf:skill/skill_shinigami/.shinigami_store_role
function werewolf:skill/skill_shinigami/.shinigami_change_role
tag @a[tag=4] add copying
function werewolf:skill/skill_shinigami/.shinigami_copy_scoreboard
tag @a[tag=4] remove copying
tellraw @s [{"selector":"@a[tag=4]"},{"text":"の能力を得た。"}]
execute as @s at @s run function werewolf:.system/player_attacked/sword_effect