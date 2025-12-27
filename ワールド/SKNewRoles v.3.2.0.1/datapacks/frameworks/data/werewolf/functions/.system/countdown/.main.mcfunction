#参加プレイヤーの人数を記録
execute store result score GameManager member_count if entity @a[team=Sanka]
#参加プレイヤーの人数が14人以上であれば強制リセットをかける
execute if score GameManager member_count matches 14.. run tellraw @a "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n[システムアナウンス] 参加人数が14人以上存在するためゲームをリセットします。"
execute if score GameManager member_count matches 14.. run function werewolf:.system/.error
execute if score result login_check matches 0 run tellraw @a "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n[システムアナウンス] SKNewRolesにログインしていない為、\nゲームを開始出来ません。"
execute if score result login_check matches 0 run function werewolf:.system/.error

# 最初にリセット
execute if score GameManager member_count matches ..12 run function werewolf:.system/.game_end

#帳尻合わせ
execute if score GameManager member_count matches ..12 run scoreboard players set @a ready 1
execute if score GameManager member_count matches ..12 run execute as @a run function werewolf:.system/inventory_menu/set_inventory_menu

execute if score GameManager member_count matches ..12 run tellraw @a "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n[システムアナウンス] 10秒後にカウントダウンが始まります。"
execute if score GameManager member_count matches ..12 run tellraw @a "[システムアナウンス] F3+D でチャットログをリセットできます。"
# ゲームスタート
execute if score GameManager member_count matches ..12 run data modify storage sys: game_start set value 1
# タイトルのフェードを一旦無しに
execute if score GameManager member_count matches ..12 run title @a times 0 5s 0
# カウントダウン後にゲーム開始
execute if score GameManager member_count matches ..12 run schedule function werewolf:.system/countdown/3 11s
execute if score GameManager member_count matches ..12 run schedule function werewolf:.system/countdown/2 12s
execute if score GameManager member_count matches ..12 run schedule function werewolf:.system/countdown/1 13s
execute if score GameManager member_count matches ..12 run schedule function werewolf:.system/gamestart 14s