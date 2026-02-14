#クールタイム用ダメージ更新
execute if score @s skill_wanashi_cooltime < GameManager cooltime_wanashi_10 if score @s skill_wanashi_cooltime >= GameManager cooltime_wanashi_9 run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_0
execute if score @s skill_wanashi_cooltime < GameManager cooltime_wanashi_9 if score @s skill_wanashi_cooltime >= GameManager cooltime_wanashi_8 run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_1
execute if score @s skill_wanashi_cooltime < GameManager cooltime_wanashi_8 if score @s skill_wanashi_cooltime >= GameManager cooltime_wanashi_7 run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_2
execute if score @s skill_wanashi_cooltime < GameManager cooltime_wanashi_7 if score @s skill_wanashi_cooltime >= GameManager cooltime_wanashi_6 run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_3
execute if score @s skill_wanashi_cooltime < GameManager cooltime_wanashi_6 if score @s skill_wanashi_cooltime >= GameManager cooltime_wanashi_5 run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_4
execute if score @s skill_wanashi_cooltime < GameManager cooltime_wanashi_5 if score @s skill_wanashi_cooltime >= GameManager cooltime_wanashi_4 run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_5
execute if score @s skill_wanashi_cooltime < GameManager cooltime_wanashi_4 if score @s skill_wanashi_cooltime >= GameManager cooltime_wanashi_3 run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_6
execute if score @s skill_wanashi_cooltime < GameManager cooltime_wanashi_3 if score @s skill_wanashi_cooltime >= GameManager cooltime_wanashi_2 run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_7
execute if score @s skill_wanashi_cooltime < GameManager cooltime_wanashi_2 if score @s skill_wanashi_cooltime >= GameManager cooltime_wanashi_1 run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_8
execute if score @s skill_wanashi_cooltime < GameManager cooltime_wanashi_1 if score @s skill_wanashi_cooltime matches 1.. run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_9
execute if score @s skill_wanashi_cooltime matches 0 run item modify entity @s hotbar.8 werewolf:item/skill/wanashi/cooltime/set_damage_10

