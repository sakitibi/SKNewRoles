#イベントをリストに追加
execute as @e[type=marker,tag=event_shuffle,sort=random,limit=1] run function werewolf:random_event/.event_shuffle/particular

#リストが埋まっていなければ再帰
execute if entity @e[type=marker,tag=event_shuffle] run function werewolf:random_event/.event_shuffle/shuffle