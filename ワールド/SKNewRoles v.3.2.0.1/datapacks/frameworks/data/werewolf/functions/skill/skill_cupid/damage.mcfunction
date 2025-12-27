#ヒットタグを削除
tag @s remove hit_cupid_arrow
execute as entity @s[type=player,team=!Marmade] run schedule function werewolf:skill/skill_cupid/lovers 1t append false
damage @s[type=player,team=Marmade] 0.01 fall by @a[team=Cupid,limit=1]