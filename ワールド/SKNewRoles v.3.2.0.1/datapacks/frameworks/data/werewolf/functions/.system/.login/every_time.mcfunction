#ワールドログイン時のメッセージ
tellraw @s "ワールドにログインしました。"

execute unless entity @a[tag=admin] run tag @r add admin
execute if entity @a[tag=admin] run tag @a[tag=!admin] add member

#ゲーム中なら不参加チームに入れる
execute unless data storage sys: {game_phase:0} if entity @s[tag=!player,team=!Tenkai,team=!Fusanka] run team join Fusanka

#会議中なら会議チャットを表示
execute if data storage sys: {game_phase:99} if entity @s[tag=player,team=!Tenkai,team=!Fusanka] run function werewolf:.system/vote/vote_chat

#スコアボードを変更
scoreboard players set @s login 2

#設定用のボスバー表示
    execute if data storage sys: {game_phase:0} run bossbar set settings_bossbar players @a

#ゲーム中に落ちた人の処理
    execute if data storage sys: {game_phase:0} run team join Sanka @s[team=!Fusanka]
    execute if data storage sys: {game_phase:0} run function werewolf:.system/.game_end_only