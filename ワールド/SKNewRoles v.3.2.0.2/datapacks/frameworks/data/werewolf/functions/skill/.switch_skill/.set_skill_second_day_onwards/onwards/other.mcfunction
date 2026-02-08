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
# あられ少女
    #あられ少女処理
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/araregirl_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_araregirl/.araregirl_result
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/araregirl_skill,scores={right_click=1..}] run function werewolf:skill/skill_araregirl/.araregirl_result