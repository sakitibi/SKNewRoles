scoreboard players operation GameManager votes > @a votes
scoreboard players operation @a votes -= GameManager votes
scoreboard players operation GameManager vote_skip -= GameManager votes

scoreboard players set GameManager vote_checker 0
execute as @a[scores={votes=0..}] unless score @s votes <= GameManager vote_skip run execute store result score GameManager vote_checker if entity @a[scores={votes=0..}]

execute if score GameManager vote_checker matches 1 run tag @a[scores={votes=0..}] add hang


