#使用するスコアボードを初期化
    scoreboard players reset GameManager reserve_1
    scoreboard players reset GameManager reserve_2
    scoreboard players reset GameManager reserve_3
    scoreboard players reset GameManager reserve_4
#クールタイム更新間隔を計算
    scoreboard players set GameManager reserve_1 600
    scoreboard players operation GameManager reserve_2 = GameManager reserve_1
    scoreboard players set GameManager reserve_3 10
    #reserve_2に間隔が記録
    scoreboard players operation GameManager reserve_2 /= GameManager reserve_3

#クールタイム更新間隔を記録
scoreboard players operation GameManager cooltime_wanashi_1 = GameManager reserve_2
scoreboard players operation GameManager cooltime_wanashi_2 = GameManager reserve_2
scoreboard players operation GameManager cooltime_wanashi_3 = GameManager reserve_2
scoreboard players operation GameManager cooltime_wanashi_4 = GameManager reserve_2
scoreboard players operation GameManager cooltime_wanashi_5 = GameManager reserve_2
scoreboard players operation GameManager cooltime_wanashi_6 = GameManager reserve_2
scoreboard players operation GameManager cooltime_wanashi_7 = GameManager reserve_2
scoreboard players operation GameManager cooltime_wanashi_8 = GameManager reserve_2
scoreboard players operation GameManager cooltime_wanashi_9 = GameManager reserve_2
scoreboard players operation GameManager cooltime_wanashi_10 = GameManager reserve_2
#2
scoreboard players set GameManager reserve_4 2
scoreboard players operation GameManager cooltime_wanashi_2 *= GameManager reserve_4
#3
scoreboard players set GameManager reserve_4 3
scoreboard players operation GameManager cooltime_wanashi_3 *= GameManager reserve_4
#4
scoreboard players set GameManager reserve_4 4
scoreboard players operation GameManager cooltime_wanashi_4 *= GameManager reserve_4
#5
scoreboard players set GameManager reserve_4 5
scoreboard players operation GameManager cooltime_wanashi_5 *= GameManager reserve_4
#6
scoreboard players set GameManager reserve_4 6
scoreboard players operation GameManager cooltime_wanashi_6 *= GameManager reserve_4
#7
scoreboard players set GameManager reserve_4 7
scoreboard players operation GameManager cooltime_wanashi_7 *= GameManager reserve_4
#8
scoreboard players set GameManager reserve_4 8
scoreboard players operation GameManager cooltime_wanashi_8 *= GameManager reserve_4
#9
scoreboard players set GameManager reserve_4 9
scoreboard players operation GameManager cooltime_wanashi_9 *= GameManager reserve_4
#10
scoreboard players set GameManager reserve_4 10
scoreboard players operation GameManager cooltime_wanashi_10 *= GameManager reserve_4

#念のため使用したスコアボードを初期化
    scoreboard players reset GameManager reserve_1
    scoreboard players reset GameManager reserve_2
    scoreboard players reset GameManager reserve_3
    scoreboard players reset GameManager reserve_4