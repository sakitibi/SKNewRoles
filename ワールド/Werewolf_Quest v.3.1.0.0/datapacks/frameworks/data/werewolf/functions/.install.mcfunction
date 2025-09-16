#バージョンを記録
    function werewolf:version
    # ゲームルール関連
        #ゲームフェイズ判定変数作成
            execute unless data storage sys: game_phase run data modify storage sys: game_phase set value 0
        #ゲームスタート判定変数作成
            execute unless data storage sys: game_start run data modify storage sys: game_start set value 0
        #合計人数把握のためのスコアボードの追加
            scoreboard objectives add member_count dummy
        #死亡カウントの追加
            scoreboard objectives add death deathCount
        #実績の非表示
            gamerule announceAdvancements false
        #死亡ログ非表示
            gamerule showDeathMessages false
        #コマンド実行ログ非表示
            gamerule sendCommandFeedback false
        #時間経過無し
            gamerule doDaylightCycle false
        #天候無し
            gamerule doWeatherCycle false
        #作物成長等無し
            gamerule randomTickSpeed 1
        #即時リスポーン無し
            gamerule doImmediateRespawn false
        #モブスポーン無し    
            gamerule doMobSpawning false
        #コマンド連続実行の制限緩和
            gamerule maxCommandChainLength 2147483647
        #難易度ハード
            difficulty hard
        #
            execute if data storage sys: {game_phase:0} run time set 3000

    # インベントリメニュー関連
        #初期設定
        scoreboard objectives add inventory_menu dummy
        scoreboard objectives add time_since_death minecraft.custom:minecraft.time_since_death
        #ゲーム開始のエントリー用
        scoreboard objectives add ready dummy
        #listに表示しておく
        scoreboard objectives setdisplay list ready

    # チーム関連
        #参加者チームの追加
            team add Sanka
        #不参加者チームの追加
            team add Fusanka
        #天界チームの追加
            team add Tenkai
        #赤色発光のためのチーム追加
            team add Glowing_red
            team modify Glowing_red color red

    # 時間管理のスコアボード作成
        #tickを秒に変換
        scoreboard objectives add tick_second dummy
        scoreboard players set GameManager tick_second 20
        #tickを分に変換
        scoreboard objectives add tick_minute dummy
        scoreboard players set GameManager tick_minute 1200

    # ボスバーの表示を指定
        data modify storage sys: bossbar_text set value '[{"text":"\\uF804\\uF804\\uF804\\uF804\\uF804\\uF804"},{"score":{"name":"GameManager","objective":"day"},"font":"default_negative"},{"interpret":true,"nbt":"time_text","storage":"sys:"},{"text":" ["},{"score":{"name":"GameManager","objective":"day"}},{"text":"日目]"},{"score":{"name":"GameManager","objective":"day"},"font":"default_negative"},{"text":"\\uF804\\uF804\\uF804\\uF804\\uF804\\uF804"},{"interpret":true,"nbt":"random_event.title","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.1","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.2","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.3","storage":"sys:"},{"interpret":true,"nbt":"random_event.bar","storage":"sys:"}]'

    # 昼夜サイクルの初期設定
        #日付を記録
        scoreboard objectives add day dummy
        #共通のタイマー
        scoreboard objectives add common_timer dummy
        #初日の昼時間設定/初期1分
        scoreboard objectives add set_first_daytime dummy
        execute unless score GameManager set_first_daytime matches 0.. run scoreboard players set GameManager set_first_daytime 1200
        scoreboard objectives add set_first_daytime_minutes dummy
        scoreboard players operation GameManager set_first_daytime_minutes = GameManager set_first_daytime
        scoreboard players operation GameManager set_first_daytime_minutes /= GameManager tick_minute
        #昼/初期3分
        scoreboard objectives add set_daytime dummy
        execute unless score GameManager set_daytime matches 0.. run scoreboard players set GameManager set_daytime 3600
        scoreboard objectives add set_daytime_minutes dummy
        scoreboard players operation GameManager set_daytime_minutes = GameManager set_daytime
        scoreboard players operation GameManager set_daytime_minutes /= GameManager tick_minute
        #夜/初期1分
        scoreboard objectives add set_nighttime dummy
        execute unless score GameManager set_nighttime matches 0.. run scoreboard players set GameManager set_nighttime 1200
        scoreboard objectives add set_nighttime_minutes dummy
        scoreboard players operation GameManager set_nighttime_minutes = GameManager set_nighttime
        scoreboard players operation GameManager set_nighttime_minutes /= GameManager tick_minute
    
    # 乱数調整用のスコアを設定
        scoreboard objectives add rng dummy
        scoreboard objectives add .100 dummy
        scoreboard players set GameManager .100 100

    #ランダムイベント関連
        scoreboard objectives add event_timer dummy
        scoreboard objectives add event_timer_countdown dummy
        execute unless data storage sys: event_active run data modify storage sys: event_active set value 0
        function werewolf:random_event/event_data
        #バー設定
        scoreboard objectives add event_timer_divide dummy
        scoreboard objectives add event_timer_update dummy
        scoreboard objectives add .36 dummy
        scoreboard players set GameManager .36 36

    #緊急会議関連
        scoreboard objectives add meeting_button dummy
        execute unless data storage sys: meeting.active run data modify storage sys: meeting.active set value 1

    #勝利条件モード
        execute unless data storage judge_mode: judge_mode run data modify storage judge_mode: judge_mode set value 0
    
    #タスク勝利
        execute unless data storage sys: task_win.active run data modify storage sys: task_win.active set value 1
        execute unless data storage sys: task_win.count run data modify storage sys: task_win.count set value 100

    # 右クリックの使用判定を追加
        scoreboard objectives add right_click minecraft.used:minecraft.carrot_on_a_stick
    # スニーク判定を追加
        scoreboard objectives add is_sneaking minecraft.custom:minecraft.sneak_time

    # ログイン検知用のスコアボードを追加
        scoreboard objectives add login minecraft.custom:minecraft.leave_game

    #特定の動物を子供に戻す
        execute as @e[tag=child] run data modify entity @s Age set value 3000000

    # 以下追記用
    # 役職関連
        function werewolf:role/.ini
    # スキル関連
        function werewolf:skill/.ini
    # アイテム関連
        function werewolf:item/.ini
    # タスク関連
        function werewolf:task/.ini
    # ショップ関連
        function werewolf:shop/.ini
    # アニメーション関連
        function werewolf:anim/.ini

    # 会議関連
        function werewolf:.system/vote/.ini


    # 一時的に雑に使えるscoreboardを作成
        scoreboard objectives add reserve_1 dummy
        scoreboard objectives add reserve_2 dummy
        scoreboard objectives add reserve_3 dummy
        scoreboard objectives add reserve_4 dummy
        scoreboard objectives add reserve_5 dummy
    # オーナー検知用のスコアボード作成
        scoreboard objectives add owner dummy


    # 設定表示用のボスバー作成
        bossbar add settings_bossbar ""
        bossbar set settings_bossbar color pink
        function werewolf:.settings/reload_settings
        execute if data storage sys: {game_phase:0} run bossbar set settings_bossbar players @a
    
    #店をリセット
    schedule function werewolf:shop/reset_shop 1s