#テレポート
tag @r[tag=player,team=!Tenkai] add teleport
tp @a[tag=player,tag=!teleport] @a[tag=teleport]
#ボスバー名を更新
bossbar set time_bossbar name [{"interpret":true,"nbt":"bossbar_text","storage":"sys:"}]
# 全員にアナウンス
tellraw @s {"text":"全員が一箇所にワープした!!!","color":"white"}
playsound minecraft:random.levelup master @s