#上段調節
    tellraw @s {"text":"\n\n\n\n\n\n\n\n\n\n\n[Debug_Settings]"}

#役職設定
        tellraw @s {"text":" [役職変更]"}
        function werewolf:.debug_modules/mura
        function werewolf:.debug_modules/jinrou
        function werewolf:.debug_modules/other
        tellraw @s {"text":" [その他]"}
        tellraw @s [{"text":"  ゲームを強制終了          ","color":"white"},{"text":"<実行>","color":"green","clickEvent":{"action":"run_command","value":"/function werewolf:.reset"}}]
        tellraw @s [{"text":"  コマンドログを表示        ","color":"white"},{"text":"<実行>","color":"green","clickEvent":{"action":"run_command","value":"/function werewolf:.settings/.debug/debug_command_output_true"}}]
        tellraw @s [{"text":"  コマンドログを非表示      ","color":"white"},{"text":"<実行>","color":"green","clickEvent":{"action":"run_command","value":"/function werewolf:.settings/.debug/debug_command_output_false"}}]


#memo
#execute at @e[type=minecraft:marker,tag=gate] positioned ~ ~4 ~ run summon minecraft:block_display ~ ~ ~ {block_state:{Name:"minecraft:iron_bars",Properties:{north:"true",south:"true",east:"false",west:"false"}},Tags:["test"]}




#/bossbar set time_bossbar name [{"interpret":true,"nbt":"time_text","storage":"sys:"},{"interpret":true,"nbt":"random_event.title","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.1","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.2","storage":"sys:"}]

#役職本テンプレ
#[{"text":"\uF831[本icon]\uF830,"font":"quest_title"}]


#左揃え、全角は右に-6 \uF806　半角は-3 \uF803
#[{"text":"[テキスト][文字分negative]","font":"x"}]


#イベント詳細を設定
#data modify storage sys: random_event.title set value ''
#data modify storage sys: random_event.content.1 set value ''
#data modify storage sys: random_event.content.2 set value ''
#ボスバー名を更新
#bossbar set time_bossbar name [{"interpret":true,"nbt":"time_text","storage":"sys:"},{"interpret":true,"nbt":"random_event.title","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.1","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.2","storage":"sys:"}]

#execute unless entity @e[type=minecraft:frog,team=Uranai] run summon minecraft:frog ~ ~0.5 ~ {Team:Uranai,Tags:["1","player","team_uranai","camp_green"],NoAI:true,Silent:true}
#execute unless entity @e[type=minecraft:frog,team=Jinrou] run summon minecraft:frog ~ ~0.5 ~ {Team:Jinrou,Tags:["1","player","team_jinrou","camp_red"],NoAI:true,Silent:true}


#give @p written_book{title:"",author:"",HideFlags:32,pages:['[[{"text":"\\uF821\\uF80A\\uF828\\uE100\\uF826\\uE101\\uF80B\\uF826","color":"white","font":"role_book"}],[{"text":"\\uE102\\uF80C\\uF803","color":white,"font":"role_book"}]]']}


#give @p written_book{title:"",author:"",HideFlags:32,pages:['[[{"text":"\\uF830\\uE100\\uF826\\uE105\\uF832","color":"white","font":"role_book"}],[{"text":"\\uE106\\uF833","color":white,"font":"role_book"}],[{"text":"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n","color":white,"font":"role_book"}],[{"text":"ああああああああああああ\\nあ　ああああああああああ","color":white,"font":"role_book"}]]']}

#give @p written_book{title:"",author:"",HideFlags:32,pages:['[[{"text":"\\uF830\\uE100\\uF826\\uE105\\uF832","color":"white","font":"role_book"}],[{"text":"\\uE106\\uF833","color":"white","font":"role_book"}]]']}
#give @p written_book{title:"",author:"",HideFlags:32,pages:['[[{"text":"\\uF830\\uE100\\uF826\\uE105\\uF832","color":"white","font":"role_book"}],[{"text":"\\uE106\\uF833","color":"white","font":"role_book"}],[{"text":"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n","font":"role_book"}],[{"text":"　","font":"role_book"}],[{"text":"　　　　　　　　　　　　","clickEvent":{"action":"run_command","value":"/function werewolf:.settings/view_settings"},"font":"role_book"}]]']}