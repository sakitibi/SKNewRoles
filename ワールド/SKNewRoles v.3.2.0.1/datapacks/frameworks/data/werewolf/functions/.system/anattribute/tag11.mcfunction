#タグをリセット
tag @s remove no_jinrou
tag @s remove camp_green
tag @s remove camp_red
tag @s remove camp_pink

#背徳者へ役職チェンジ
#チームに参加
team join Kyoujin

#タグを付与
tag @s add team_kyoujin
tag @s add no_jinrou
tag @s add camp_red

#村/第三陣営=1 人狼陣営(狂人除く)=2
scoreboard players set @s role 1

#スキルと役職本リセット
item replace entity @s hotbar.7 with air
item replace entity @s hotbar.8 with air