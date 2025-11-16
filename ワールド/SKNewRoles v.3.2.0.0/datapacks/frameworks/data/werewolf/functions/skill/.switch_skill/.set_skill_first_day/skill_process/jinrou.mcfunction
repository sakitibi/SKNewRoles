#役職スキル処理
# 人狼
    #咆哮
        execute as @a[predicate=werewolf:have_skill/jinrou_roar_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
    #切り裂き
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/jinrou_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}         
# 魔女
    #ビーム
        execute as @a[predicate=werewolf:have_skill/witch_roar_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"今はまだ使えない。"}
    #切り裂き
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/witch_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}      
# リモコン
    #マーキング
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/rimokon_marking_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
    #切り裂き
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/rimokon_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
    #操作
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/rimokon_operation_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# ダブルキラー
    #キル
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/doublekiller_mainslash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}  
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/doublekiller_subslash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# イビルゲッサー
    execute as @a[predicate=werewolf:have_skill/evilguesser_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# イビルシーア
    #キル
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/evilseer_slash_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
    #サイドキック
        execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/evilseer_sidekick_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# コミュナー
    execute as @a[predicate=werewolf:have_skill/comuner_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# シリアルキラー
    execute as @a[predicate=werewolf:have_skill/serialkiller_skill_ban,predicate=!werewolf:is_sneaking,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# 罠師
    execute as @a[predicate=werewolf:have_skill/wanashi_skill_ban,scores={right_click=1..}] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# マッドシーア
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/madseer_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}
# しろいぬ
    execute as @a[predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/shiroinu_skill_cooltime,scores={right_click=1..},predicate=!werewolf:is_sneaking] run tellraw @s {"text":"初日の昼はスキルが使えない。"}