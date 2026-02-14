# スコア：add_randomを作成
scoreboard objectives add add_random dummy
# add_randomに0~40000までの乱数を設定
scoreboard players random 13ninAddManager add_random 0 40000
# {AddDebug}が1ならsidebarにスコアを表示
execute if data storage 13ninAddManager: {AddDebug:1} run scoreboard objectives setdisplay sidebar add_random