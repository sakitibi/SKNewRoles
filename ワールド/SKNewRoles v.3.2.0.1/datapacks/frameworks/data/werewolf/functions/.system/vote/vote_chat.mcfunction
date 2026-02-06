#投票用チャットを表示
tellraw @a "\n\n\n\n\n\n\n\n\n\n\n\n\n\n[緊急会議]"
tellraw @a [{"interpret":true,"nbt":"meeting.convener","storage":"sys:"},{"text":"が招集"}]
tellraw @a [{"text":"招集方法: "},{"interpret":true,"nbt":"meeting.cause","storage":"sys:"}]
execute unless data storage sys: meeting.dead run tellraw @a [{"text":"新たな死亡プレイヤー: "},{"text":"なし","color":"green"}]
execute if data storage sys: meeting.dead run tellraw @a [{"text":"新たな死亡プレイヤー: "},{"interpret":true,"nbt":"meeting.dead[]","storage":"sys:","color":"red"}]
execute if entity @a[tag=warlock_curse] run tellraw @a[team=Witch] [{"text":"現在魔法にかかっているプレイヤー: "},{"interpret":true,"selector":"@a[tag=warlock_curse]","color":"red"}]
execute unless entity @a[tag=warlock_curse] run tellraw @a[team=Witch] [{"text":"現在魔法にかかっているプレイヤー: "},{"text":"なし","color":"green"}]

tellraw @a[team=!Tenkai,team=!Fusanka] "\n[投票用チャット]"
execute if entity @a[team=!Tenkai,tag=1] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=1]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/1"}}]
execute if entity @a[team=!Tenkai,tag=2] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=2]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/2"}}]
execute if entity @a[team=!Tenkai,tag=3] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=3]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/3"}}]
execute if entity @a[team=!Tenkai,tag=4] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=4]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/4"}}]
execute if entity @a[team=!Tenkai,tag=5] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=5]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/5"}}]
execute if entity @a[team=!Tenkai,tag=6] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=6]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/6"}}]
execute if entity @a[team=!Tenkai,tag=7] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=7]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/7"}}]
execute if entity @a[team=!Tenkai,tag=8] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=8]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/8"}}]
execute if entity @a[team=!Tenkai,tag=9] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=9]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/9"}}]
execute if entity @a[team=!Tenkai,tag=10] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=10]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/10"}}]
execute if entity @a[team=!Tenkai,tag=11] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=11]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/11"}}]
execute if entity @a[team=!Tenkai,tag=12] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=12]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/12"}}]
execute if entity @a[team=!Tenkai,tag=12] run tellraw @a[team=!Tenkai,team=!Fusanka] [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=13]"},{"text":" "},{"text":" <投票する> ","color":"red","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/13"}}]
tellraw @a[team=!Tenkai,team=!Fusanka] [{"text":" <投票をスキップ> ","color":"green","clickEvent":{"action":"run_command","value":"/function werewolf:.system/vote/paticular/skip"}}]
