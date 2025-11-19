# スキル関連
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