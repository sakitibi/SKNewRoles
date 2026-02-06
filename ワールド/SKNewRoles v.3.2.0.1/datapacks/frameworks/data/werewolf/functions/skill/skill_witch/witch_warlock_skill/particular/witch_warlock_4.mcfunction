#ダメージ処理
execute unless entity @a[tag=!warlock_curse,tag=!4,tag=hanazonogirl_unlocked_curse] run scoreboard players add @s[scores={warlock_curse=0..}] warlock_curse 400
execute unless entity @a[tag=warlock_curse,tag=hanazonogirl_unlocked_curse,tag=!4] run scoreboard players set @s warlock_curse 0
tag @a[tag=!warlock_curse,tag=!hanazonogirl_unlocked_curse,tag=4] add warlock_curse
execute if entity @a[tag=!hanazonogirl_unlocked_curse,tag=4] run title @a[tag=Warlock,limit=1] title [{text:"あなたは","color":"red"},{"selector":"@s","color":"red"},{"text":"に魔法をかけた!","color":"red"}]
execute unless entity @a[tag=!hanazonogirl_unlocked_curse,tag=!4] run tag @s add witch_curse_protected
execute unless entity @a[tag=!4,tag=!witch_curse_protected] run title @a[tag=Warlock,limit=1] title [{"selector":"@s","color":"green"},{"text":"には魔術が効かない!","color":"green"}]
playsound minecraft:sorceress-curse master @s ~ ~ ~