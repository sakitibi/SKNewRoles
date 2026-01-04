execute if score @s can_vote matches 1 run tellraw @s "あなたは既に投票している"
execute if score @s can_vote matches 0 run tellraw @s [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=10]"},{"text":" に投票した"}]

execute if score @s can_vote matches 0 run scoreboard players add @a[team=!Tenkai,team=!Fusanka,tag=10] votes 1
execute if score @s can_vote matches 0 run scoreboard players set @s can_vote 1
