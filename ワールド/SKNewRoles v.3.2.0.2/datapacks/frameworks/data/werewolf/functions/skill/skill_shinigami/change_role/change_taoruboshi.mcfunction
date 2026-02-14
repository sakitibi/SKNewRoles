
#チームに参加
team join Taoruboshi

#タグをリセット
execute as @s run function werewolf:skill/skill_shinigami/change_role/tag_reset

#タグを付与
tag @s add team_taoruboshi
#tag @s add no_jinrou
tag @s add camp_green

#村/第三陣営=1 人狼陣営(狂人除く)=2
scoreboard players set @s role 1

#スキルと役職本リセット
item replace entity @s hotbar.7 with air
item replace entity @s hotbar.8 with air