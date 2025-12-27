execute if entity @s[team=Hanazonogirl] run scoreboard players set @a[tag=4] skill_hanazonogirl_unlocked_curse 0
execute if entity @s[team=Hanazonogirl] run tag @a[tag=4] add hanazonogirl_unlocked_curse
execute if entity @s[team=Hanazonogirl] run tellraw @s [{"selector":"@a[tag=4]","color":"green"},{"text":"の呪いを徐々に浄化する!","color":"green"}]