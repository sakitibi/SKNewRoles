#テレポート
execute as @s[team=Niceteleporter] run tag @r[tag=player,team=!Tenkai] add warp
tp @a[tag=player,tag=!warp] @a[tag=warp]
# 全員にアナウンス
tellraw @s {"text":"全員が一箇所にワープした!!!","color":"white"}
playsound minecraft:random.levelup master @s