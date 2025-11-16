    # スキル関連
        #スキル切り替え設定
            scoreboard players add @a skill_mode 0

        # 人狼の切り裂き設定/使用前:0 使用後:1      
            scoreboard players add @a skill_jinrou_slash_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            execute unless score GameManager skill_jinrou_slash_limit matches 0.. run scoreboard players set GameManager skill_jinrou_slash_limit 0
        #回復タイミングを指定(n/日)
            execute unless score GameManager skill_jinrou_slash_frequency matches 0.. run scoreboard players set GameManager skill_jinrou_slash_frequency 1
        # 人狼の咆哮設定
            scoreboard players add @a skill_jinrou_roar_cooltime 0
        
        # Witchのキル設定/使用前:0 使用後:1      
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_witch_slash_limit dummy
            execute unless score GameManager skill_witch_slash_limit matches 0.. run scoreboard players set GameManager skill_witch_slash_limit 0
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_jinrou_slash_frequency dummy
            execute unless score GameManager skill_witch_slash_frequency matches 0.. run scoreboard players set GameManager skill_witch_slash_frequency 1
        # Witchのビーム設定
            scoreboard players add @a skill_witch_roar_cooltime 0
        # リモコンのキル設定/使用前:0 使用後:1      
            scoreboard objectives add skill_rimokon_slash_cooltime dummy
            scoreboard players add @a skill_rimokon_slash_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_rimokon_slash_limit dummy
            execute unless score GameManager skill_rimokon_slash_limit matches 0.. run scoreboard players set GameManager skill_rimokon_slash_limit 0
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_rimokon_slash_frequency dummy
            execute unless score GameManager skill_rimokon_slash_frequency matches 0.. run scoreboard players set GameManager skill_rimokon_slash_frequency 1
        
        # リモコンのマーキング設定/使用前:0 使用後:1      
            scoreboard objectives add skill_rimokon_marking_cooltime dummy
            scoreboard players add @a skill_rimokon_marking_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_rimokon_marking_limit dummy
            execute unless score GameManager skill_rimokon_marking_limit matches 0.. run scoreboard players set GameManager skill_rimokon_marking_limit 0
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_rimokon_marking_frequency dummy
            execute unless score GameManager skill_rimokon_marking_frequency matches 0.. run scoreboard players set GameManager skill_rimokon_marking_frequency 1
        
        # リモコンの操作設定/使用前:0 使用後:1      
            scoreboard objectives add skill_rimokon_operation_cooltime dummy
            scoreboard players add @a skill_rimokon_operation_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_rimokon_operation_limit dummy
            execute unless score GameManager skill_rimokon_operation_limit matches 0.. run scoreboard players set GameManager skill_rimokon_operation_limit 0
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_rimokon_operation_frequency dummy
            execute unless score GameManager skill_rimokon_operation_frequency matches 0.. run scoreboard players set GameManager skill_rimokon_operation_frequency 1
        
        # ダブルキラーのキル設定/使用前:0 使用後:1      
            scoreboard objectives add skill_doublekiller_mainslash_cooltime dummy
            scoreboard players add @a skill_doublekiller_mainslash_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_doublekiller_mainslash_limit dummy
            execute unless score GameManager skill_doublekiller_mainslash_limit matches 0.. run scoreboard players set GameManager skill_doublekiller_mainslash_limit 0
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_doublekiller_mainslash_frequency dummy
            execute unless score GameManager skill_doublekiller_mainslash_frequency matches 0.. run scoreboard players set GameManager skill_doublekiller_mainslash_frequency 1
        
        # ダブルキラーのキル設定/使用前:0 使用後:1      
            scoreboard objectives add skill_doublekiller_subslash_cooltime dummy
            scoreboard players add @a skill_doublekiller_subslash_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_doublekiller_subslash_limit dummy
            execute unless score GameManager skill_doublekiller_subslash_limit matches 0.. run scoreboard players set GameManager skill_doublekiller_subslash_limit 0
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_doublekiller_subslash_frequency dummy
            execute unless score GameManager skill_doublekiller_subslash_frequency matches 0.. run scoreboard players set GameManager skill_doublekiller_subslash_frequency 1
        # イビルゲッサーのキル設定/使用前:0 使用後:1      
            scoreboard objectives add skill_evilguesser_cooltime dummy
            scoreboard players add @a skill_evilguesser_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_evilguesser_limit dummy
            execute unless score GameManager skill_evilguesser_limit matches 0.. run scoreboard players set GameManager skill_evilguesser_limit 1
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_evilguesser_frequency dummy
            execute unless score GameManager skill_evilguesser_frequency matches 0.. run scoreboard players set GameManager skill_evilguesser_frequency 1
        # スナイパーの射撃設定
            scoreboard players add @a skill_sniper_cooltime 0
        # イビルシーアのキル設定/使用前:0 使用後:1      
            scoreboard players add @a skill_evilseer_slash_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            execute unless score GameManager skill_evilseer_slash_limit matches 0.. run scoreboard players set GameManager skill_evilseer_slash_limit 0
        #回復タイミングを指定(n/日)
            execute unless score GameManager skill_evilseer_slash_frequency matches 0.. run scoreboard players set GameManager skill_evilseer_slash_frequency 1

        # イビルシーアのサイドキック設定/使用前:0 使用後:1      
            scoreboard players add @a skill_evilseer_sidekick_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            execute unless score GameManager skill_evilseer_sidekick_limit matches 0.. run scoreboard players set GameManager skill_evilseer_sidekick_limit 0
        #回復タイミングを指定(n/日)
            execute unless score GameManager skill_evilseer_sidekick_frequency matches 0.. run scoreboard players set GameManager skill_evilseer_sidekick_frequency 1
        
        # コミュナーのキル設定/使用前:0 使用後:1      
            scoreboard players add @a skill_comuner_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            execute unless score GameManager skill_comuner_limit matches 0.. run scoreboard players set GameManager skill_comuner_limit 1
        #回復タイミングを指定(n/日)
            execute unless score GameManager skill_comuner_frequency matches 0.. run scoreboard players set GameManager skill_comuner_frequency 1
        # シリアルキラーのキル設定/使用前:0 使用後:1      
            scoreboard players add @a skill_serialkiller_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            execute unless score GameManager skill_serialkiller_limit matches 0.. run scoreboard players set GameManager skill_serialkiller_limit 1
        #回復タイミングを指定(n/日)
            execute unless score GameManager skill_serialkiller_frequency matches 0.. run scoreboard players set GameManager skill_serialkiller_frequency 1
        # 罠師スキル
            scoreboard objectives add skill_wanashi_cooltime dummy
            scoreboard players add @a skill_wanashi_cooltime 0
        #罠の同時設置数を設定   
            scoreboard objectives add pitfall_max_count dummy
            execute unless score GameManager pitfall_max_count matches 0.. run scoreboard players set GameManager pitfall_max_count 4
        #罠にかかっているか
            scoreboard objectives add fall_into_a_pitfall dummy
        
        # マッドシーア設定/使用前:0 使用後:1      
            scoreboard players add @a skill_madseer_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            execute unless score GameManager skill_madseer_limit matches 0.. run scoreboard players set GameManager skill_madseer_limit 0
        #回復タイミングを指定(n/日)
            execute unless score GameManager skill_madseer_frequency matches 0.. run scoreboard players set GameManager skill_madseer_frequency 1
        
        # しろいぬ設定/使用前:0 使用後:1      
            scoreboard players add @a skill_shiroinu_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            execute unless score GameManager skill_shiroinu_limit matches 0.. run scoreboard players set GameManager skill_shiroinu_limit 0
        #回復タイミングを指定(n/日)
            execute unless score GameManager skill_shiroinu_frequency matches 0.. run scoreboard players set GameManager skill_shiroinu_frequency 1
        
        # 占いスキル
            scoreboard objectives add skill_uranai_cooltime dummy
            scoreboard players add @a skill_uranai_cooltime 0
        #占い最大回数を指定(0なら無制限)
            scoreboard objectives add skill_uranai_limit dummy
            execute unless score GameManager skill_uranai_limit matches 0.. run scoreboard players set GameManager skill_uranai_limit 0
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_uranai_frequency dummy
            execute unless score GameManager skill_uranai_frequency matches 0.. run scoreboard players set GameManager skill_uranai_frequency 1


        # 霊能スキル
            scoreboard objectives add skill_reinou_cooltime dummy
            scoreboard players add @a skill_reinou_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_reinou_limit dummy
            execute unless score GameManager skill_reinou_limit matches 0.. run scoreboard players set GameManager skill_reinou_limit 0
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_reinou_frequency dummy
            execute unless score GameManager skill_reinou_frequency matches 0.. run scoreboard players set GameManager skill_reinou_frequency 1

            
        # 騎士スキル
            scoreboard objectives add skill_kishi_cooltime dummy
            scoreboard players add @a skill_kishi_cooltime 0
            #守護判定
            scoreboard objectives add skill_kishi_protected dummy
            scoreboard objectives add skill_kishi_protected_dummy dummy
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_kishi_limit dummy
            execute unless score GameManager skill_kishi_limit matches 0.. run scoreboard players set GameManager skill_kishi_limit 0
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_kishi_frequency dummy
            execute unless score GameManager skill_kishi_frequency matches 0.. run scoreboard players set GameManager skill_kishi_frequency 1


        # シェリフスキル
            scoreboard objectives add skill_hoankan_cooltime dummy
            scoreboard players add @a skill_hoankan_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_hoankan_limit dummy
            execute unless score GameManager skill_hoankan_limit matches 0.. run scoreboard players set GameManager skill_hoankan_limit 0
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_hoankan_frequency dummy
            execute unless score GameManager skill_hoankan_frequency matches 0.. run scoreboard players set GameManager skill_hoankan_frequency 1

        # 裁判官スキル
            scoreboard objectives add skill_saibankan_cooltime dummy
            scoreboard players add @a skill_saibankan_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_saibankan_limit dummy
            execute unless score GameManager skill_saibankan_limit matches 0.. run scoreboard players set GameManager skill_saibankan_limit 1
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_saibankan_frequency dummy
            execute unless score GameManager skill_saibankan_frequency matches 0.. run scoreboard players set GameManager skill_saibankan_frequency 1
        
        # ナイステレポータースキル
            scoreboard objectives add skill_niceteleporter_cooltime dummy
            scoreboard players add @a skill_niceteleporter_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_nicetereporter_limit dummy
            execute unless score GameManager skill_niceteleporter_limit matches 0.. run scoreboard players set GameManager skill_niceteleporter_limit 1
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_niceteleporter_frequency dummy
            execute unless score GameManager skill_niceteleporter_frequency matches 0.. run scoreboard players set GameManager skill_niceteleporter_frequency 1
        # さけのみことスキル
            scoreboard players add @a skill_sakenomikoto_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            execute unless score GameManager skill_sakenomikoto_limit matches 0.. run scoreboard players set GameManager skill_sakenomikoto_limit 1
        #回復タイミングを指定(n/日)
            execute unless score GameManager skill_sakenomikoto_frequency matches 0.. run scoreboard players set GameManager skill_sakenomikoto_frequency 1
        # 花園の女の子スキル
            scoreboard players add @a skill_hanazonogirl_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            execute unless score GameManager skill_hanazonogirl_limit matches 0.. run scoreboard players set GameManager skill_hanazonogirl_limit 1
        #回復タイミングを指定(n/日)
            execute unless score GameManager skill_hanazonogirl_frequency matches 0.. run scoreboard players set GameManager skill_hanazonogirl_frequency 1
        # 森スキル
            scoreboard players add @a skill_forest_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            execute unless score GameManager skill_forest_limit matches 0.. run scoreboard players set GameManager skill_forest_limit 1
        #回復タイミングを指定(n/日)
            execute unless score GameManager skill_forest_frequency matches 0.. run scoreboard players set GameManager skill_forest_frequency 1 

        # ポンコツのダミー役職モード
            execute unless data storage sys: ponkotsu_mode run data modify storage sys: ponkotsu_mode set value 0


        # 妖狐スキル
            scoreboard objectives add skill_youko_cooltime dummy
            scoreboard players add @a skill_youko_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_youko_limit dummy
            execute unless score GameManager skill_youko_limit matches 0.. run scoreboard players set GameManager skill_youko_limit 1
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_youko_frequency dummy
            execute unless score GameManager skill_youko_frequency matches 0.. run scoreboard players set GameManager skill_youko_frequency 1

        # ジャッカルのキル設定/使用前:0 使用後:1      
            scoreboard objectives add skill_jackal_slash_cooltime dummy
            scoreboard players add @a skill_jackal_slash_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_jackal_slash_limit dummy
            execute unless score GameManager skill_jackal_slash_limit matches 0.. run scoreboard players set GameManager skill_jackal_slash_limit 1
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_jackal_slash_frequency dummy
            execute unless score GameManager skill_jackal_slash_frequency matches 0.. run scoreboard players set GameManager skill_jackal_slash_frequency 1

        # ジャッカルのサイドキック設定/使用前:0 使用後:1      
            scoreboard objectives add skill_jackal_sidekick_cooltime dummy
            scoreboard players add @a skill_jackal_sidekick_cooltime 0
        #スキル最大回数を指定(0なら無制限)
            scoreboard objectives add skill_jackal_sidekick_limit dummy
            execute unless score GameManager skill_jackal_sidekick_limit matches 0.. run scoreboard players set GameManager skill_jackal_sidekick_limit 1
        #回復タイミングを指定(n/日)
            scoreboard objectives add skill_jackal_sidekick_frequency dummy
            execute unless score GameManager skill_jackal_sidekick_frequency matches 0.. run scoreboard players set GameManager skill_jackal_sidekick_frequency 1
        
        #死神スキル(一応)
            scoreboard players add @a skill_shinigami_cooltime 0

        # キューピットスキル
            scoreboard players add @a skill_cupid_cooltime 0