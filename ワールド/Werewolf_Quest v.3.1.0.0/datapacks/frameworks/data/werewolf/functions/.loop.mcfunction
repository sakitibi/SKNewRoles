    # ログイン検知
        execute as @a run scoreboard players add @s login 0
        execute as @a[scores={login=0}] run function werewolf:.system/.login/first_time
        execute as @a[scores={login=3..}] run function werewolf:.system/.login/every_time

    # ゲーム開始前
        execute if data storage sys: {game_phase:0} run schedule function werewolf:.system/.standby 1t append true
    # ゲーム中
        execute if data storage sys: {game_phase:1} run schedule function werewolf:.system/.playing 1t append true
    # 会議中
        execute if data storage sys: {game_phase:99} run schedule function werewolf:.system/.meeting 1t append true
    # ゲームフェイズを監視
        execute unless data storage sys: {game_phase:0} unless data storage sys: {game_phase:99} run schedule function werewolf:.system/.victory 1t append true

    #経験値オーブのキル
        kill @e[type=experience_orb]
    #ゲーム開始後アイテムドロップの防止
        kill @e[type=item,nbt={Item:{tag:{Tags:["no_drop"]}}}]
    #アイテム
        schedule function werewolf:item/smoke_bomb/ 1t append true
        schedule function werewolf:item/tnt_bomb/ 1t append true

    # 最終処理
        #右クリック判定リセット
            scoreboard players set @a[scores={right_click=1..}] right_click 0
        #スニーク判定リセット
            scoreboard players set @a[scores={is_sneaking=1..},predicate=!werewolf:is_sneaking] is_sneaking 0
    #要注意人物バン
        ban water_challenge すまない先生許せない
        ban NMNGyuri 名前は長い方が有利許せない
        kill @a[name=NMNGyuri]
        kill @a[name=water_challenge]

    execute store result storage comuner: counter value int 1 run scoreboard players get GameManager comuner_counter
    execute store result score GameManager comuner_counter run data get storage comuner: counter value