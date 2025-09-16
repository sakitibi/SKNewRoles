    # スキル関連
        # 人狼
            #スキルチェンジ
            execute as @a[team=Jinrou,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
            #ポンコツ用
            execute as @a[team=Ponkotsu,tag=jinrou_dummy,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air

            #クールタイム設定
            #咆哮
            execute as @a[scores={skill_jinrou_roar_cooltime=1..}] run scoreboard players remove @s skill_jinrou_roar_cooltime 1
            execute as @a[scores={skill_jinrou_roar_cooltime=1..},predicate=werewolf:set_skill/jinrou_roar_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/cooltime
            execute if data storage sys: {time_phase:day} as @a[predicate=werewolf:set_skill/jinrou_roar_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/ban
            execute if data storage sys: {time_phase:day} as @a[predicate=werewolf:set_skill/jinrou_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/ban
            execute if data storage sys: {time_phase:night} as @a[scores={skill_jinrou_roar_cooltime=..0},predicate=werewolf:set_skill/jinrou_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/
            #execute if data storage sys: {time_phase:night} as @a[scores={skill_jinrou_roar_cooltime=1..},predicate=werewolf:set_skill/jinrou_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/cooltime
            execute if data storage sys: {time_phase:night} as @a[scores={skill_jinrou_roar_cooltime=..0},predicate=werewolf:set_skill/jinrou_roar_skill_ban] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_roar_skill/
            #切り裂く
            execute as @a[scores={skill_jinrou_slash_cooltime=0},predicate=werewolf:set_skill/jinrou_slash_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_slash_skill/
            execute as @a[scores={skill_jinrou_slash_cooltime=1..},predicate=werewolf:set_skill/jinrou_slash_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/jinrou_slash_skill/cooltime
        # アサシン
            execute as @a[team=Asasine,scores={skill_jinrou_slash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/asasine_skill/
            execute as @a[team=Asasine,scores={skill_jinrou_slash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/asasine_skill/cooltime
        # Witch
        #スキルチェンジ
            execute as @a[team=Witch,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
        #クールタイム設定
        #ビーム
            execute as @a[scores={skill_witch_roar_cooltime=1..}] run scoreboard players remove @s skill_witch_roar_cooltime 1
            execute as @a[scores={skill_witch_roar_cooltime=1..},predicate=werewolf:set_skill/witch_roar_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/cooltime
            execute if data storage sys: {time_phase:day} as @a[predicate=werewolf:set_skill/witch_roar_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/ban
            execute if data storage sys: {time_phase:day} as @a[predicate=werewolf:set_skill/witch_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/ban
            execute if data storage sys: {time_phase:night} as @a[scores={skill_witch_roar_cooltime=..0},predicate=werewolf:set_skill/witch_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/
            #execute if data storage sys: {time_phase:night} as @a[scores={skill_witch_roar_cooltime=1..},predicate=werewolf:set_skill/witch_roar_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/cooltime
            execute if data storage sys: {time_phase:night} as @a[scores={skill_witch_roar_cooltime=..0},predicate=werewolf:set_skill/witch_roar_skill_ban] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_roar_skill/
        # キル
            execute as @a[team=Witch,scores={skill_witch_slash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_slash_skill/
            execute as @a[team=Witch,scores={skill_witch_slash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/witch_slash_skill/cooltime
        # リモコン
            # キル
            execute as @a[team=Rimokon,scores={skill_rimokon_slash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_slash_skill/
            execute as @a[team=Rimokon,scores={skill_rimokon_slash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_slash_skill/cooltime
            # マーキング
            execute as @a[team=Rimokon,scores={skill_rimokon_marking_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_marking_skill/
            execute as @a[team=Rimokon,scores={skill_rimokon_marking_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_marking_skill/cooltime
            # 操作
            execute as @a[team=Rimokon,scores={skill_rimokon_operation_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_operation_skill/
            execute as @a[team=Rimokon,scores={skill_rimokon_operation_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/rimokon_operation_skill/cooltime
        # ダブルキラー
            # キル
            execute as @a[team=Doublekiller,scores={skill_doublekiller_mainslash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_mainslash_skill/
            execute as @a[team=Doublekiller,scores={skill_doublekiller_mainslash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_mainslash_skill/cooltime
            execute as @a[team=Doublekiller,scores={skill_doublekiller_subslash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_subslash_skill/
            execute as @a[team=Doublekiller,scores={skill_doublekiller_subslash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/doublekiller_subslash_skill/cooltime
        # イビルゲッサー
            execute as @a[team=Evilguesser,scores={skill_evilguesser_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilguesser_skill/
            execute as @a[team=Evilguesser,scores={skill_evilguesser_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilguesser_skill/cooltime
        # スナイパー
            #クールタイム設定
            execute as @a[predicate=werewolf:set_skill/sniper_skill_ban] run loot replace entity @s hotbar.8 loot werewolf:skill/sniper_skill/
            execute as @a[scores={skill_sniper_cooltime=1..}] run scoreboard players remove @s skill_sniper_cooltime 1
            execute as @a[scores={skill_sniper_cooltime=1..},predicate=werewolf:set_skill/sniper_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/sniper_skill/cooltime
            execute as @a[scores={skill_sniper_cooltime=..0},predicate=werewolf:set_skill/sniper_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/sniper_skill/
        # イビルシーア
            #スキルチェンジ
                execute as @a[team=Evilseer,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
            # キル
                execute as @a[team=Evilseer,scores={skill_evilseer_slash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_slash_skill/
                execute as @a[team=Evilseer,scores={skill_evilseer_slash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_slash_skill/cooltime
            # サイドキック
                execute as @a[team=Evilseer,scores={skill_evilseer_sidekick_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_sidekick_skill/
                execute as @a[team=Evilseer,scores={skill_evilseer_sidekick_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/evilseer_sidekick_skill/cooltime
        # コミュナー
            execute as @a[team=Comuner,scores={skill_comuner_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/comuner_skill/
            execute as @a[team=Comuner,scores={skill_comuner_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/comuner_skill/cooltime
        # シリアルキラー
            execute as @a[team=Serialkiller,scores={skill_serialkiller_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/serialkiller_skill/
            execute as @a[team=Serialkiller,scores={skill_serialkiller_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/serialkiller_skill/cooltime
        # 罠師
            #クールタイム設定
            execute as @a[predicate=werewolf:set_skill/wanashi_skill_ban] run loot replace entity @s hotbar.8 loot werewolf:skill/wanashi_skill/
            execute as @a[scores={skill_wanashi_cooltime=1..}] run scoreboard players remove @s skill_wanashi_cooltime 1
            execute as @a[scores={skill_wanashi_cooltime=1..},predicate=werewolf:set_skill/wanashi_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/wanashi_skill/cooltime
            execute as @a[scores={skill_wanashi_cooltime=..0},predicate=werewolf:set_skill/wanashi_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/wanashi_skill/

        # 占い師
            #クールタイム設定
            execute as @a[scores={skill_uranai_cooltime=1..},predicate=werewolf:set_skill/uranai_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/uranai_skill/cooltime
            execute as @a[scores={skill_uranai_cooltime=0},predicate=werewolf:set_skill/uranai_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/uranai_skill/
        # 霊能者
            #クールタイム設定
            execute as @a[scores={skill_reinou_cooltime=1..},predicate=werewolf:set_skill/reinou_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/reinou_skill/cooltime
            execute as @a[scores={skill_reinou_cooltime=0},predicate=werewolf:set_skill/reinou_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/reinou_skill/
        # 騎士
            #クールタイム設定
            execute as @a[scores={skill_kishi_cooltime=1..},predicate=werewolf:set_skill/kishi_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/kishi_skill/cooltime
            execute as @a[scores={skill_kishi_cooltime=0},predicate=werewolf:set_skill/kishi_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/kishi_skill/
        # シェリフ
            #クールタイム設定
            execute as @a[scores={skill_hoankan_cooltime=1..},predicate=werewolf:set_skill/hoankan_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/hoankan_skill/cooltime
            execute as @a[scores={skill_hoankan_cooltime=0},predicate=werewolf:set_skill/hoankan_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/hoankan_skill/
        # オポチュニスト
            #クールタイム設定
            execute as @a[scores={skill_ojousama_cooltime=1..},predicate=werewolf:set_skill/ojousama_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/ojousama_skill/cooltime
            execute as @a[scores={skill_ojousama_cooltime=0},predicate=werewolf:set_skill/ojousama_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/ojousama_skill/
        # 裁判官
            #クールタイム設定
            execute as @a[scores={skill_saibankan_cooltime=1..},predicate=werewolf:set_skill/saibankan_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/saibankan_skill/cooltime
            execute as @a[scores={skill_saibankan_cooltime=0},predicate=werewolf:set_skill/saibankan_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/saibankan_skill/
        # ナイステレポーター
            #クールタイム設定
            execute as @a[scores={skill_niceteleporter_cooltime=1..},predicate=werewolf:set_skill/niceteleporter_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/niceteleporter_skill/cooltime
            execute as @a[scores={skill_niceteleporter_cooltime=0},predicate=werewolf:set_skill/niceteleporter_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/niceteleporter_skill/
        # さけのみこと
            #クールタイム設定
            execute as @a[scores={skill_sakenomikoto_cooltime=1..},predicate=werewolf:set_skill/sakenomikoto_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/sakenomikoto_skill/cooltime
            execute as @a[scores={skill_sakenomikoto_cooltime=0},predicate=werewolf:set_skill/sakenomikoto_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/sakenomikoto_skill/
        # 花園の女の子
            #クールタイム設定
            execute as @a[scores={skill_hanazonogirl_cooltime=1..},predicate=werewolf:set_skill/hanazonogirl_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/hanazonogirl_skill/cooltime
            execute as @a[scores={skill_hanazonogirl_cooltime=0},predicate=werewolf:set_skill/hanazonogirl_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/hanazonogirl_skill/

        # 妖狐
            execute as @a[team=Youko] run loot replace entity @s hotbar.8 loot werewolf:skill/youko_skill/cooltime
        # 死神
            #クールタイム設定
            execute as @a[scores={skill_shinigami_cooltime=1..},predicate=werewolf:set_skill/shinigami_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/shinigami_skill/cooltime
            execute as @a[scores={skill_shinigami_cooltime=0},predicate=werewolf:set_skill/shinigami_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/shinigami_skill/
        # キューピット
            #クールタイム設定
            execute as @a[predicate=werewolf:set_skill/cupid_skill_ban] if score GameManager lovers_full matches 0 run loot replace entity @s hotbar.8 loot werewolf:skill/cupid_skill/
            execute as @a[scores={skill_cupid_cooltime=1..}] if score GameManager lovers_full matches 0 run scoreboard players remove @s skill_cupid_cooltime 1
            execute as @a[scores={skill_cupid_cooltime=1..},predicate=werewolf:set_skill/cupid_skill] if score GameManager lovers_full matches 0 run loot replace entity @s hotbar.8 loot werewolf:skill/cupid_skill/cooltime
            execute as @a[scores={skill_cupid_cooltime=..0},predicate=werewolf:set_skill/cupid_skill_cooltime] if score GameManager lovers_full matches 0 run loot replace entity @s hotbar.8 loot werewolf:skill/cupid_skill/
            execute if score GameManager lovers_full matches 1 as @a[team=Cupid] run loot replace entity @s hotbar.8 loot werewolf:skill/cupid_skill/ban
        # ジャッカル
            # キル
            execute as @a[team=Jackal,scores={skill_jackal_slash_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_slash_skill/
            execute as @a[team=Jackal,scores={skill_jackal_slash_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_slash_skill/cooltime
            # サイドキック
            execute as @a[team=Jackal,scores={skill_jackal_sidekick_cooltime=0}] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_sidekick_skill/
            execute as @a[team=Jackal,scores={skill_jackal_sidekick_cooltime=1..}] run loot replace entity @s hotbar.8 loot werewolf:skill/jackal_sidekick_skill/cooltime

        # 人狼
            #人狼スキル処理
            #咆哮
            function werewolf:skill/skill_jinrou/jinrou_roar_skill/
            execute as @a[predicate=werewolf:have_skill/jinrou_roar_skill_cooltime,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute as @a[predicate=werewolf:have_skill/jinrou_roar_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute as @a[predicate=werewolf:have_skill/jinrou_roar_skill,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run function werewolf:skill/skill_jinrou/jinrou_roar_skill/shot
            #切り裂き
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jinrou_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run function werewolf:skill/skill_jinrou/jinrou_slash_skill/.jinrou_slash_result
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jinrou_slash_skill,scores={right_click=1..},predicate=!werewolf:is_sneaking] run function werewolf:skill/skill_jinrou/jinrou_slash_skill/.jinrou_slash_result
            #スキルチェンジ
            execute as @a[team=Jinrou,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
            #ポンコツ用
            execute as @a[team=Ponkotsu,tag=jinrou_dummy,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
            #アサシン用
            execute as @a[team=Asasine,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jinrou_slash_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_jinrou/jinrou_slash_skill/.jinrou_slash_result
            execute as @a[team=Asasine,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jinrou_slash_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_jinrou/jinrou_slash_skill/.jinrou_slash_result
        # Witch
            #Witchスキル処理
            #ビーム
            function werewolf:skill/skill_jinrou/jinrou_roar_skill/
            execute as @a[predicate=werewolf:have_skill/witch_roar_skill_cooltime,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute as @a[predicate=werewolf:have_skill/witch_roar_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute as @a[predicate=werewolf:have_skill/witch_roar_skill,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run function werewolf:skill/skill_witch/witch_roar_skill/shot
            #スキルチェンジ
            execute as @a[team=Witch,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
            #キル
            execute as @a[team=Witch,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/witch_slash_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_witch/witch_slash_skill/.witch_slash_result
            execute as @a[team=Witch,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/witch_slash_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_witch/witch_slash_skill/.witch_slash_result
        #リモコン
            #リモコンスキル処理
            #マーキング
            function werewolf:skill/skill_rimokon/rimokon_marking_skill/
            execute as @a[predicate=werewolf:have_skill/rimokon_marking_skill_cooltime,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute as @a[predicate=werewolf:have_skill/rimokon_marking_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute as @a[predicate=werewolf:have_skill/rimokon_marking_skill,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run function werewolf:skill/skill_rimokon/rimokon_marking_skill/rimokon_marking_skill_result
            #操作
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/rimokon_operation_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run function werewolf:skill/skill_rimokon/operation_slash_skill/.rimokon_operation_result
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/rimokon_operation_skill,scores={right_click=1..},predicate=!werewolf:is_sneaking] run function werewolf:skill/skill_rimokon/rimokon_operation_skill/.rimokon_operation_result
            #スキルチェンジ
            execute as @a[team=Rimokon,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
            #キル
            execute as @a[team=Rimokon,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/rimokon_slash_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_rimokon/rimokon_slash_skill/.rimokon_slash_result
            execute as @a[team=Rimokon,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/rimokon_slash_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_rimokon/rimokon_slash_skill/.rimokon_slash_result
        # ダブルキラー
            #ダブルキラースキル処理
            #キル
            function werewolf:skill/skill_doublekiller/doublekiller_mainslash_skill/
            execute as @a[predicate=werewolf:have_skill/doublekiller_mainslash_skill_cooltime,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute as @a[predicate=werewolf:have_skill/doublekiller_mainslash_skill,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run function werewolf:skill/skill_doublekiller/doublekiller_mainslash_skill/doublekiller_mainslash_skill_result
            #スキルチェンジ
            execute as @a[team=Doublekiller,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
            #キル
            execute as @a[team=Doublekiller,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/doublekiller_subslash_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_doublekiller/doublekiller_subslash_skill/.doublekiller_subslash_result
            execute as @a[team=Doublekiller,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/doublekiller_subslash_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_doublekiller/doublekiller_subslash_skill/.doublekiller_subslash_result
        # イビルゲッサー
            #イビルゲッサースキル処理
            #キル
            execute as @a[team=Evilguesser,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/evilguesser_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_evilguesser/.evilguesser_result
            execute as @a[team=Evilguesser,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/evilguesser_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_evilguesser/.evilguesser_result
        # イビルシーア
            #イビルシーアスキル処理
            #キル
            function werewolf:skill/skill_evilseer/evilseer_slash_skill/
            execute as @a[predicate=werewolf:have_skill/evilseer_slash_skill_cooltime,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute as @a[predicate=werewolf:have_skill/evilseer_slash_skill,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run function werewolf:skill/skill_evilseer/evilseer_slash_skill/evilseer_slash_skill_result
            #スキルチェンジ
            execute as @a[team=Evilseer,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
            #サイドキック
            execute as @a[team=Evilseer,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/evilseer_sidekick_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_evilseer/evilseer_sidekick_skill/.evilseer_sidekick_result
            execute as @a[team=Evilseer,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/evilseer_sidekick_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_evilseer/evilseer_sidekick_skill/.evilseer_sidekick_result
        # コミュナー
            #コミュナースキル処理
            execute as @a[team=Comuner,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/comuner_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_comuner/.comuner_result
            execute as @a[team=Comuner,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/comuner_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_comuner/.comuner_result
        # 罠師
            #罠設置処理
            execute as @a[predicate=werewolf:have_skill/wanashi_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_wanashi/.main
            execute as @a[predicate=werewolf:have_skill/wanashi_skill,scores={right_click=1..}] run function werewolf:skill/skill_wanashi/.main
        # マッドシーア
            #マッドシーアスキル処理
            #サイドキック
            execute as @a[team=Madseer,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/madseer_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_madseer/.madseer_result
            execute as @a[team=Madseer,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/madseer_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_madseer/.madseer_result
        
        # 占い師
            #占い処理
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/uranai_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_uranai/.uranai_result
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/uranai_skill,scores={right_click=1..}] run function werewolf:skill/skill_uranai/.uranai_result
        # 霊能者
            #霊能処理
            execute as @a[predicate=werewolf:look_at/look_at_grave,predicate=werewolf:have_skill/reinou_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_reinou/.reinou_result
            execute as @a[predicate=werewolf:look_at/look_at_grave,predicate=werewolf:have_skill/reinou_skill,scores={right_click=1..}] run function werewolf:skill/skill_reinou/.reinou_result
        # 騎士
            #守護処理
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/kishi_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_kishi/.kishi_result
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/kishi_skill,scores={right_click=1..}] run function werewolf:skill/skill_kishi/.kishi_result
        # シェリフ
            #シェリフ処理
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/hoankan_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_hoankan/.hoankan_result
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/hoankan_skill,scores={right_click=1..}] run function werewolf:skill/skill_hoankan/.hoankan_result
        # 裁判官
            #裁判官処理
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/saibankan_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_saibankan/.saibankan_result
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/saibankan_skill,scores={right_click=1..}] run function werewolf:skill/skill_saibankan/.saibankan_result
            #裁判官補佐処理
            execute as @a[tag=saibankan_1,predicate=werewolf:look_at/look_at_meeting_button] run function werewolf:skill/skill_saibankan/.successor_result
        # ナイステレポーター
            #ナイステレポーター処理
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/niceteleporter_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_niceteleporter/.niceteleporter_result
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/niceteleporter_skill,scores={right_click=1..}] run function werewolf:skill/skill_niceteleporter/.niceteleporter_result
        # さけのみこと
            #さけのみこと処理
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/sakenomikoto_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_sakenomikoto/.sakenomikoto_result
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/sakenomikoto_skill,scores={right_click=1..}] run function werewolf:skill/skill_sakenomikoto/.sakenomikoto_result
        # 花園の女の子
            #花園の女の子処理
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/hanazonogirl_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_hanazonogirl/.hanazonogirl_result
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/hanazonogirl_skill,scores={right_click=1..}] run function werewolf:skill/skill_hanazonogirl/.hanazonogirl_result
        
        # 死神
            #死神処理
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/shinigami_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_shinigami/.shinigami_result
            execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/shinigami_skill,scores={right_click=1..}] run function werewolf:skill/skill_shinigami/.shinigami_result
        # オポチュニスト
            #オポチュニスト処理
            execute as @a[predicate=werewolf:have_skill/ojousama_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_ojousama/.ojousama_result
            execute as @a[predicate=werewolf:have_skill/ojousama_skill,scores={right_click=1..}] run function werewolf:skill/skill_ojousama/.ojousama_result
        # キューピット
            #ラバーズの人数確認
            execute if entity @a[team=Cupid] if entity @a[tag=lovers] if score GameManager lovers_full matches 0 run function werewolf:skill/skill_cupid/lovers_judge
            #キューピット処理
            function werewolf:skill/skill_cupid/
            execute as @a[predicate=werewolf:have_skill/cupid_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute if score GameManager lovers_full matches 0 as @a[predicate=werewolf:have_skill/cupid_skill_ban,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute if score GameManager lovers_full matches 0 as @a[predicate=werewolf:have_skill/cupid_skill,scores={right_click=1..}] run function werewolf:skill/skill_cupid/shot
            execute if score GameManager lovers_full matches 1 as @a[predicate=werewolf:have_skill/cupid_skill_ban,scores={right_click=1..}] run tellraw @s {"text":"このスキルはもう使えない。"}
        # ジャッカル
            #ダブルキラースキル処理
            #キル
            function werewolf:skill/skill_jackal/jackal_slash_skill/
            execute as @a[predicate=werewolf:have_skill/jackal_slash_skill_cooltime,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
            execute as @a[predicate=werewolf:have_skill/jackal_slash_skill,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run function werewolf:skill/skill_jackal/jackal_slash_skill/jackal_slash_skill_result
            #スキルチェンジ
            execute as @a[team=Jackal,predicate=werewolf:is_sneaking,scores={right_click=1..}] run item replace entity @s weapon.mainhand with air
            #キル
            execute as @a[team=Jackal,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jackal_sidekick_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_jackal/jackal_sidekick_skill/.jackal_sidekick_result
            execute as @a[team=Jackal,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jackal_sidekick_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_jackal/jackal_sidekick_skill/.jackal_sidekick_result

    #クールタイム可視化処理
        #人狼 Witch
            #咆哮
            execute if data storage sys: {time_phase:night} as @a[scores={skill_jinrou_roar_cooltime=1..},predicate=werewolf:set_skill/jinrou_roar_skill_cooltime] run function werewolf:skill/skill_jinrou/jinrou_roar_skill/cooltime/set_cooltime
            execute if data storage sys: {time_phase:night} as @a[scores={skill_witch_roar_cooltime=1..},predicate=werewolf:set_skill/witch_roar_skill_cooltime] run function werewolf:skill/skill_witch/witch_roar_skill/cooltime/set_cooltime
            execute as @a[scores={skill_sniper_cooltime=1..},predicate=werewolf:set_skill/sniper_skill_cooltime] run function werewolf:skill/skill_sniper/sniper_skill/cooltime/set_cooltime

        #罠師
        execute as @a[scores={skill_wanashi_cooltime=1..},predicate=werewolf:set_skill/wanashi_skill_cooltime] run function werewolf:skill/skill_wanashi/cooltime/set_cooltime
        #キューピット
        execute as @a[scores={skill_cupid_cooltime=1..},predicate=werewolf:set_skill/cupid_skill_cooltime] run function werewolf:skill/skill_cupid/cooltime/set_cooltime