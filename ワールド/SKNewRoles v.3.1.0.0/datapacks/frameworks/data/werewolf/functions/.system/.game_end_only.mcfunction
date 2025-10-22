#team join Sanka @s[team=!Fusanka]
clear @s
gamemode adventure @s
effect clear @s

# 役職判定をリセット
scoreboard players set @s role 0
# タグリセット
tag @s remove player
tag @s remove 1
tag @s remove 2
tag @s remove 3
tag @s remove 4
tag @s remove 5
tag @s remove 6
tag @s remove 7
tag @s remove 8
tag @s remove 9
tag @s remove 10
tag @s remove 11
tag @s remove 12
tag @s remove 13
tag @s remove hang
# 結果出力用の役職タグをリセット
#                        //------------------------------------------------役職追加の際追記
function werewolf:.system/game_end_modules/team_remove/tags/jinrou
function werewolf:.system/game_end_modules/team_remove/tags/mura
function werewolf:.system/game_end_modules/team_remove/tags/other

tag @s remove no_jinrou
tag @s remove camp_red
tag @s remove camp_green
tag @s remove camp_pink

tag @s remove lovers
tag @s remove lovers_1
tag @s remove lovers_2

tag @s remove saibankan_1

tag @s remove jinrou_dummy
tag @s remove wanashi_dummy
tag @s remove uranai_dummy
tag @s remove reinou_dummy
tag @s remove kishi_dummy
tag @s remove hoankan_dummy
tag @s remove ojousama_dummy
tag @s remove saibankan_dummy

tag @e remove be_written_jinrou
tag @e remove be_written_comuner
tag @e remove be_written_jackal
tag @e remove can_use_vent

# スキル関連
# スキルモードをリセット
scoreboard players set @s skill_mode 0

scoreboard players set @s fall_into_a_pitfall 0

# オーナー検知用のスコアボードリセット
scoreboard players reset @s owner


scoreboard players set @s ready 0


execute as @s run function werewolf:.system/inventory_menu/set_inventory_menu

# 終了後ワープ
tp @s @e[type=marker,tag=end,limit=1]

#設定ボスバーを表示
bossbar set minecraft:settings_bossbar visible true
scoreboard players reset @a[scores={seer_madness=0..}] seer_madness
scoreboard players reset @a[team=Serialkiller] serialkiller_countdown
scoreboard players reset @a[team=Serialkiller] serialkiller_killcooldown
scoreboard players reset @a comuner_fined
tag @a remove isFined