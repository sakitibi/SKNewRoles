#通常
 #後任指名処理
execute if entity @s[team=Saibankan] run tellraw @s [{"selector":"@a[tag=13]","color":"green"},{"text":"を後任に指名した。","color":"green"}]
execute if entity @s[team=Saibankan] run tellraw @a[tag=13,tag=player] [{"text":"あなたは裁判官の後任に指名された。","color":"green"}]
execute if entity @s[team=Saibankan] run tag @a[tag=13,tag=player] add saibankan_1

#ポンコツ
execute if entity @s[team=Ponkotsu] run tellraw @s [{"selector":"@a[tag=13]","color":"green"},{"text":"を後任に指名した。","color":"green"}]