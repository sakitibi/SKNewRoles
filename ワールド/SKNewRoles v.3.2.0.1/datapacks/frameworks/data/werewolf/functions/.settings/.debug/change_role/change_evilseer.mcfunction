#チームに参加
team join Evilseer

#タグをリセット
execute as @s run function werewolf:.settings/.debug/change_role/tag_reset

#タグを付与
tag @s add team_evilseer
#tag @s add no_jinrou
tag @s add camp_red

#村/第三陣営=1 人狼陣営(狂人除く)=2
scoreboard players set @s role 2

#スキルと役職本リセット
    item replace entity @s hotbar.7 with air
    item replace entity @s hotbar.8 with air
tellraw @s {"text":"[システムアナウンス] 役職がイビルシーアに変更されました"}