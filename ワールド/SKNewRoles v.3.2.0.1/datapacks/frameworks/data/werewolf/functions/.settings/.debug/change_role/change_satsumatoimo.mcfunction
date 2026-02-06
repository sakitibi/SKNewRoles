#チームに参加
team join Satsumatoimo

#タグをリセット
execute as @s run function werewolf:.settings/.debug/change_role/tag_reset

#タグを付与
scoreboard players random @s satsumatoimo_role 0 1
tag @s add team_satsumatoimo
tag @s add no_jinrou
tag @s[scores={satsumatoimo_role=0}] add camp_green
tag @s[scores={satsumatoimo_role=1}] add camp_red

#村/第三陣営=1 人狼陣営(狂人除く)=2
scoreboard players set @s role 1

#スキルと役職本リセット
item replace entity @s hotbar.7 with air
item replace entity @s hotbar.8 with air

tellraw @s {"text":"[システムアナウンス] 役職がさつまといもに変更されました"}