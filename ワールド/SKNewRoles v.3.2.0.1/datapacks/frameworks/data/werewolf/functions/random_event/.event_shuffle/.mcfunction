#イベントリストをリセット
data remove storage sys: random_event.shuffle

#一応使用するマーカーをキル
kill @e[type=marker,tag=event_shuffle]

#マーカーを召喚
function werewolf:random_event/.event_shuffle/summon_marker

#シャッフル処理
function werewolf:random_event/.event_shuffle/shuffle