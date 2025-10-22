    # インベントリ関連
        #持ち物所持上限を制限する
            execute as @a[predicate=!werewolf:have_item/ban_slot,scores={time_since_death=4..}] run function werewolf:.system/ban_slot
        #スキルを設定する
            execute as @a[tag=player,predicate=!werewolf:have_item/role_skill] run function werewolf:skill/.s_skill/.set_skill
        #役職本を設置する
            execute as @a[tag=player,predicate=!werewolf:have_item/role_book] run function werewolf:role/.set_role_book

    # 一般
        #ゲーム開始時に死亡判定を開始
            execute as @a[scores={death=1..}] at @s run function werewolf:.system/death
        
        #チェスト内のアイテム置き換え
            execute as @e[type=marker,tag=chest_point] at @s if entity @a[distance=..8] run function werewolf:.system/chest/item_replace_in_chest
    # 昼夜サイクル
        schedule function werewolf:.system/.playing/cycle 1t append false
    # 役職関連
        schedule function werewolf:.system/.playing/roles 1t append false
    # スキル関連
        schedule function werewolf:.system/.playing/skill 1t append false
    # アイテム関連
        schedule function werewolf:.system/.playing/items 1t append false
    # 施設関連
        schedule function werewolf:.system/.playing/shisetsu 1t append false
        # 緊急会議関連
            execute if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 unless data storage sys: {item_phase:1} as @a[predicate=werewolf:look_at/look_at_grave,predicate=werewolf:is_sneaking,predicate=!werewolf:have_skill/reinou_skill,predicate=!werewolf:have_skill/reinou_skill_cooltime] run function werewolf:.system/vote/convene_report

        # 天界チームをスペクテイターモードに
            execute as @a[team=Tenkai] run gamemode spectator
        # 不参加チームをスペクテイターモードに
            execute as @a[team=Fusanka] run gamemode spectator
        # actionbar関連
            schedule function werewolf:.system/.playing/actionbar
        # タスク勝利関連のアナウンス
            execute as @a[predicate=werewolf:look_at/look_at_task_win_chest] run title @s actionbar [{"text":"エメラルドを納品する (\uE501右クリック)"}]

        # 状態異常
            #満腹度が1の時に空腹の状態異常をクリア
            execute as @a[tag=!camp_red,predicate=werewolf:is_effects/hunger,nbt={foodLevel:1}] run effect clear @s hunger

        scoreboard players add @a[tag=warlock_curse,tag=!hanazonogirl_unlocked_curse] warlock_curse 1
        function werewolf:.system/warlock_curse
        function werewolf:.system/hanazonogirl_curse_unlocked
        execute unless entity @a[team=Witch,tag=Warlock] run tag @a remove warlock_curse
        execute unless entity @a[team=Witch,tag=Warlock] run scoreboard players reset @a warlock_curse
    # チームWitchに所属しているプレイヤーを対象にループ
        schedule function werewolf:.system/.playing/roles/witch_loop 1t append false
    # コミュナー用
        schedule function werewolf:.system/.playing/roles/comuner 1t append false
    # シリアルキラー用
        schedule function werewolf:.system/.playing/roles/serialkiller 1t append false
    # しろくま用
        execute as @a[team=Polerbear] run schedule function werewolf:.system/.playing/roles/polerbear 1t append false
    # 以下デバッグ用