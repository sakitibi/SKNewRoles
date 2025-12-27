# スキル関連
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