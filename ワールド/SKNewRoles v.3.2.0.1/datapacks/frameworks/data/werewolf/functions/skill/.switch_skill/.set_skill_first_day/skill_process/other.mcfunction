#役職スキル処理
# オポチュニスト
    execute as @a[predicate=werewolf:have_skill/ojousama_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# 死神
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/shinigami_skill_cooltime,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# キューピット
    execute as @a[predicate=werewolf:have_skill/cupid_skill_ban,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# ジャッカル
    #キル
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jackal_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
    #サイドキック
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jackal_sidekick_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# あられ少女
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/araregirl_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}

#役職例外
# 妖狐
    #背徳者処理
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/youko_skill_cooltime,scores={right_click=1..}] run function werewolf:skill/skill_youko/.youko_result
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/youko_skill,scores={right_click=1..}] run function werewolf:skill/skill_youko/.youko_result
    #クールタイム設定
        execute as @a[scores={skill_youko_cooltime=1..},predicate=werewolf:set_skill/youko_skill] run loot replace entity @s hotbar.8 loot werewolf:skill/youko_skill/cooltime
        execute as @a[scores={skill_youko_cooltime=0},predicate=werewolf:set_skill/youko_skill_cooltime] run loot replace entity @s hotbar.8 loot werewolf:skill/youko_skill/