#ワールド初回ログイン時のメッセージ
tellraw @s "生き残るために闘うおとぎ話"
tellraw @s [{"text":"SKNewRolesの世界へようこそ","color":"green"}]
tellraw @s [{"text":"利用規約はこちら","color":"green","clickEvent":{"action":"open_url","value":"https://sakitibi.github.io/selects/534b4e6577526f6c65735465726d73"},"hoverEvent":{"action":"show_text","contents":{"text":"クリック"}}}]
tellraw @s "詳しいゲーム説明は同梱のReadme.htmlをご覧ください"
tellraw @s [{"text":"CopyRight 2023 13ninstudio, Inc","color":"green"}]

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

#門前にtp
tp @s -90 -2 -150