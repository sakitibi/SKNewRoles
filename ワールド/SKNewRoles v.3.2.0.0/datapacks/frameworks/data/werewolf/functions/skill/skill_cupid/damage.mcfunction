#ヒットタグを削除
tag @s remove hit_cupid_arrow
#タグ処理
tag @s[type=player] add lovers

execute if entity @a[tag=player,tag=lovers_1] unless entity @a[tag=player,tag=lovers_2] run tag @s add lovers_2
execute if entity @a[tag=player,tag=lovers_2] unless entity @a[tag=player,tag=lovers_1] run tellraw @a[team=Cupid] [{"selector":"@s","color":"light_purple"},{"text":"は誰かの恋人になりそうだ。","color":"light_purple"}]

execute unless entity @a[tag=player,tag=lovers_1] run tag @s add lovers_1
execute if entity @a[tag=player,tag=lovers_1] unless entity @a[tag=player,tag=lovers_2] run tellraw @a[team=Cupid] [{"selector":"@s","color":"light_purple"},{"text":"は誰かの恋人になりそうだ。","color":"light_purple"}]


execute if entity @a[tag=player,tag=lovers_1] if entity @a[tag=player,tag=lovers_2] run tellraw @a[team=Cupid] [{"selector":"@a[tag=lovers_1]","color":"light_purple"},{"text":"と","color":"light_purple"},{"selector":"@a[tag=lovers_2]","color":"light_purple"},{"text":"は恋人となった。","color":"light_purple"}]
execute if entity @a[tag=player,tag=lovers_1] if entity @a[tag=player,tag=lovers_2] run tellraw @a[tag=lovers] [{"selector":"@a[tag=lovers_1]","color":"light_purple"},{"text":"と","color":"light_purple"},{"selector":"@a[tag=lovers_2]","color":"light_purple"},{"text":"は恋人となった。","color":"light_purple"}]

#演出等
execute if entity @a[tag=player,tag=lovers_1] if entity @a[tag=player,tag=lovers_2] as @a[team=Cupid] at @s run playsound minecraft:fall_in_love master @s
execute if entity @a[tag=player,tag=lovers_1] if entity @a[tag=player,tag=lovers_2] as @a[tag=player,tag=lovers] at @s run playsound minecraft:fall_in_love master @s
execute if entity @a[tag=player,tag=lovers_1] if entity @a[tag=player,tag=lovers_2] at @a[tag=lovers] run particle minecraft:heart ~ ~1.7 ~ 0.2 0.2 0.2 0 5 force @a[team=Cupid]
execute if entity @a[tag=player,tag=lovers_1] if entity @a[tag=player,tag=lovers_2] at @a[tag=lovers] run particle minecraft:heart ~ ~1.7 ~ 0.2 0.2 0.2 0 5 force @a[tag=lovers]

#カップル完成時にカップル未完成のラバーズタグを削除
execute if entity @a[tag=player,tag=lovers_1] if entity @a[tag=player,tag=lovers_2] run tag @a[tag=!player] remove lovers
execute if entity @a[tag=player,tag=lovers_1] if entity @a[tag=player,tag=lovers_2] run tag @a[tag=!player] remove lovers_1
execute if entity @a[tag=player,tag=lovers_1] if entity @a[tag=player,tag=lovers_2] run tag @a[tag=!player] remove lovers_2