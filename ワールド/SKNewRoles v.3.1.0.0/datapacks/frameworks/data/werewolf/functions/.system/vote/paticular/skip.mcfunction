execute if score @s can_vote matches 1 run tellraw @s "あなたは既に投票している"
execute if score @s can_vote matches 0 run tellraw @s [{"text":"投票をスキップした"}]

execute if score @s can_vote matches 0 run scoreboard players add GameManager vote_skip 1
execute if score @s can_vote matches 0 run scoreboard players set @s can_vote 1
