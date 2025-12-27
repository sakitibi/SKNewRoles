#背徳者
    execute unless entity @a[team=Youko] as @a[team=Haitoku] run function werewolf:skill/skill_youko/kill_haitoku
    execute unless entity @a[team=Jackal] as @a[team=Sidekick] run function werewolf:skill/skill_jackal/sidekick-to-jackal
#ラバーズ処理
    execute if score GameManager lovers_full matches 1 unless entity @a[tag=player,tag=lovers_1] if entity @a[tag=player,tag=lovers] run function werewolf:skill/skill_cupid/death
    execute if score GameManager lovers_full matches 1 unless entity @a[tag=player,tag=lovers_2] if entity @a[tag=player,tag=lovers] run function werewolf:skill/skill_cupid/death
#ポイゾナーバフ付与
    schedule function werewolf:.system/.playing/roles/poisoner 1t append false
#マーメイド水中呼吸
    schedule function werewolf:.system/.playing/roles/marmade 1t append false