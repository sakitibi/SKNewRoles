#投票していない人をスキップに強制投票
execute as @a[team=!Tenkai,team=!Fusanka,scores={can_vote=0}] run function werewolf:.system/vote/paticular/skip

#投票結果を表示-1
tellraw @a "\n\n\n\n\n\n\n\n\n\n\n\n\n\n[投票結果]"
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=1] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=1]"},{"text":" "},{"score":{"name":"@a[tag=1,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=2] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=2]"},{"text":" "},{"score":{"name":"@a[tag=2,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=3] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=3]"},{"text":" "},{"score":{"name":"@a[tag=3,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=4] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=4]"},{"text":" "},{"score":{"name":"@a[tag=4,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=5] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=5]"},{"text":" "},{"score":{"name":"@a[tag=5,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=6] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=6]"},{"text":" "},{"score":{"name":"@a[tag=6,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=7] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=7]"},{"text":" "},{"score":{"name":"@a[tag=7,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=8] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=8]"},{"text":" "},{"score":{"name":"@a[tag=8,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=9] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=9]"},{"text":" "},{"score":{"name":"@a[tag=9,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=10] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=10]"},{"text":" "},{"score":{"name":"@a[tag=10,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=11] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=11]"},{"text":" "},{"score":{"name":"@a[tag=11,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=12] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=12]"},{"text":" "},{"score":{"name":"@a[tag=12,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=13] run tellraw @a [{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=13]"},{"text":" "},{"score":{"name":"@a[tag=13,limit=1]","objective":"votes"},"color":"white"},{"text":"票"}]

tellraw @a [{"text":"投票スキップ "},{"score":{"name":"GameManager","objective":"vote_skip"},"color":"white"},{"text":"票"}]

#誰が吊り対象か判定
function werewolf:.system/vote/vote_check

#投票結果を表示-2
execute if entity @a[team=!Tenkai,team=!Fusanka,tag=hang] run tellraw @a [{"text":"\n"},{"selector":"@a[team=!Tenkai,team=!Fusanka,tag=hang]","color":"red"},{"text":" "},{"text":"が処刑されます","color":"red"}]
execute unless entity @a[team=!Tenkai,team=!Fusanka,tag=hang] run tellraw @a [{"text":"\n"},{"text":"今回は誰も処刑されません","color":"green"}]

