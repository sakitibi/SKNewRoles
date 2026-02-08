#ヒットタグを削除
tag @s remove hit_roar
#ダメージ元を召喚
summon area_effect_cloud ~ ~ ~ {Tags:["roar"]}
#ダメージ処理
damage @s[type=!player] 50 fall
#タグをリセット
tag @s remove no_jinrou
tag @s remove camp_green
tag @s remove camp_red
tag @s remove camp_pink

#タグを付与
tag @s add team_enchant_kyoujin
tag @s add no_jinrou
tag @s add camp_red

#村/第三陣営=1 人狼陣営(狂人除く)=2
scoreboard players set @s role 1

#スキルと役職本リセット
item replace entity @s hotbar.7 with air

title @a[tag=Enchantress,limit=1] title {text:"あなたは","color":"red"}{"selector":"@s","color":"red"},{"text":"に魔法をかけ、魅了した!","color":"red"}
title @s title {"text":"あなたは魔女に魔法をかけられ、魅了された!","color":"red"}
playsound minecraft:enchantress-enchant master @s ~ ~ ~
data modify storage sys: enchantress set value false
#演出
particle minecraft:explosion ~ ~1 ~ 1 1 1 0 3 force @a[team=Cupid]