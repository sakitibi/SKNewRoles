# スキル関連
    # 人狼の切り裂き設定/使用前:0 使用後:1      
        scoreboard players add @a skill_jinrou_slash_cooltime 0
    #スキル最大回数を指定(0なら無制限)
        execute unless score GameManager skill_jinrou_slash_limit matches 0.. run scoreboard players set GameManager skill_jinrou_slash_limit 0
    #回復タイミングを指定(n/日)
        execute unless score GameManager skill_jinrou_slash_frequency matches 0.. run scoreboard players set GameManager skill_jinrou_slash_frequency 1
    # 人狼の咆哮設定
        scoreboard players add @a skill_jinrou_roar_cooltime 0
    
    # 魔女のキル設定/使用前:0 使用後:1      
    #スキル最大回数を指定(0なら無制限)
        scoreboard objectives add skill_witch_slash_limit dummy
        execute unless score GameManager skill_witch_slash_limit matches 0.. run scoreboard players set GameManager skill_witch_slash_limit 0
    #回復タイミングを指定(n/日)
        scoreboard objectives add skill_witch_slash_frequency dummy
        execute unless score GameManager skill_witch_slash_frequency matches 0.. run scoreboard players set GameManager skill_witch_slash_frequency 1
    # 魔女のビーム設定
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
    
    # 狂人薬師の治癒設定/使用前:0 使用後:1      
        scoreboard players add @a skill_kyoujinkusushi_health_cooltime 0
    #スキル最大回数を指定(0なら無制限)
        execute unless score GameManager skill_kyoujinkusushi_health_limit matches 0.. run scoreboard players set GameManager skill_kyoujinkusushi_health_limit 0
    #回復タイミングを指定(n/日)
        execute unless score GameManager skill_kyoujinkusushi_health_frequency matches 0.. run scoreboard players set GameManager skill_kyoujinkusushi_health_frequency 1

    # 狂人薬師の寛解設定/使用前:0 使用後:1      
        scoreboard players add @a skill_kyoujinkusushi_kankai_cooltime 0
    #スキル最大回数を指定(0なら無制限)
        execute unless score GameManager skill_kyoujinkusushi_kankai_limit matches 0.. run scoreboard players set GameManager skill_kyoujinkusushi_kankai_limit 0
    #回復タイミングを指定(n/日)
        execute unless score GameManager skill_kyoujinkusushi_kankai_frequency matches 0.. run scoreboard players set GameManager skill_kyoujinkusushi_kankai_frequency 1

    # ポイゾナーの毒/使用前:0 使用後:1      
        scoreboard players add @a skill_poisoner_cooltime 0
    #スキル最大回数を指定(0なら無制限)
        execute unless score GameManager skill_poisoner_limit matches 0.. run scoreboard players set GameManager skill_poisoner_limit 0
    #回復タイミングを指定(n/日)
        execute unless score GameManager skill_poisoner_frequency matches 0.. run scoreboard players set GameManager skill_poisoner_frequency 1
    # 黒雪少女スキル
        scoreboard players add @a skill_blacksnowgirl_cooltime 0
    #スキル最大回数を指定(0なら無制限)
        execute unless score GameManager skill_blacksnowgirl_limit matches 0.. run scoreboard players set GameManager skill_blacksnowgirl_limit 1
    #回復タイミングを指定(n/日)
        execute unless score GameManager skill_blacksnowgirl_frequency matches 0.. run scoreboard players set GameManager skill_blacksnowgirl_frequency 1 
    
    # 自爆魔のキル設定/使用前:0 使用後:1      
        scoreboard players add @a skill_jibakuma_slash_cooltime 0
    #スキル最大回数を指定(0なら無制限)
        execute unless score GameManager skill_jibakuma_slash_limit matches 0.. run scoreboard players set GameManager skill_jibakuma_slash_limit 0
    #回復タイミングを指定(n/日)
        execute unless score GameManager skill_jibakuma_slash_frequency matches 0.. run scoreboard players set GameManager skill_jibakuma_slash_frequency 1

    # 自爆魔の自爆設定/使用前:0 使用後:1      
        scoreboard players add @a skill_jibakuma_bomb_cooltime 0
    #スキル最大回数を指定(0なら無制限)
        execute unless score GameManager skill_jibakuma_bomb_limit matches 0.. run scoreboard players set GameManager skill_jibakuma_bomb_limit 0
    #回復タイミングを指定(n/日)
        execute unless score GameManager skill_jibakuma_bomb_frequency matches 0.. run scoreboard players set GameManager skill_jibakuma_bomb_frequency 1