#通常
 #占い処理
execute if entity @s[team=Uranai] if score @a[tag=5,limit=1] role matches 1 unless entity @a[tag=!1,team=Tenkai,team=Youko,team=!Witch,tag=!Sorceress] run tellraw @s [{"selector":"@a[tag=5]","color":"red"},{"text":"によって狂人になった。","color":"red"}]
execute if entity @s[team=Uranai] if score @a[tag=5,limit=1] role matches 1 if entity @a[tag=5,team=!Tenkai] run tellraw @s[tag=!warlock_black_curse] [{"selector":"@a[tag=5]","color":"green"},{"text":"は人狼ではないようだ。","color":"green"}]
execute if entity @s[team=Uranai] if score @a[tag=5,limit=1] role matches 2 if entity @a[tag=5,team=!Tenkai,team=Witch] run tellraw @s [{"selector":"@a[tag=5]","color":"green"},{"text":"は人狼ではないようだ。","color":"green"}]
execute if entity @s[team=Uranai] if score @a[tag=5,limit=1] role matches 1 if entity @a[tag=5,team=Youko] run tellraw @s [{"selector":"@a[tag=5]","color":"aqua"},{"text":"は妖狐だったようだ。","color":"aqua"}]
execute if entity @s[team=Uranai] if score @a[tag=5,limit=1] role matches 2 if entity @a[tag=5,team=!Tenkai,team=!Witch] run tellraw @s[tag=warlock_black_curse] [{"selector":"@a[tag=5]","color":"red"},{"text":"は人狼のようだ。","color":"red"}]
execute if entity @s[team=Uranai] if entity @a[tag=5,team=Tenkai] run tellraw @s [{"selector":"@a[tag=5]"},{"text":"はこの世にいないようだ。"}]
 #妖狐処理
execute if entity @s[team=Uranai] as @a[tag=5,team=Youko] at @s run particle soul_fire_flame ~ ~1 ~ 0.5 0.5 0.5 0 10 force @s
execute if entity @s[team=Uranai] as @a[tag=5,team=Youko] at @s run playsound minecraft:entity.blaze.shoot master @s
execute if entity @s[team=Uranai] as @a[tag=5,team=Youko] run tellraw @s "あなたは占われてしまった…"
execute if entity @s[team=Uranai] as @s[team=Uranai] run kill @a[tag=5,team=Youko]
#Witch処理
execute if entity @s[team=Uranai] as @a[tag=5,team=Witch] at @s run particle soul_fire_flame ~ ~1 ~ 0.5 0.5 0.5 0 10 force @s[tag=Sorceress]
execute if entity @s[team=Uranai] as @a[tag=5,team=Witch] at @s run playsound minecraft:entity.blaze.shoot master @s[tag=Sorceress]
execute if entity @s[team=Uranai] as @a[tag=5,team=Witch] run tellraw @s[tag=Sorceress] "あなたは占いを防いだ!"
execute if entity @s[tag=Sorceress] as @s[team=Uranai] run tag @s add uranaifailed
execute if entity @s[team=Uranai,tag=uranaifailed] as @s[team=Uranai,tag=uranaifailed] run team leave @s
execute if entity @s[tag=uranaifailed] as @s[tag=uranaifailed] run team join Kyoujin @s
execute if entity @s[team=Kyoujin,tag=uranaifailed] as @s[team=Kyoujin,tag=uranaifailed] run tag @s remove uranaifailed
#ポンコツ
execute if entity @s[team=Ponkotsu] run tellraw @s [{"selector":"@a[tag=5]","color":"green"},{"text":"は人狼ではないようだ。","color":"green"}]