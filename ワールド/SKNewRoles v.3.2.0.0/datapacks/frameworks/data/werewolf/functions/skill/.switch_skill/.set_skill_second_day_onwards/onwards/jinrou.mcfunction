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
# 魔女
    #魔女スキル処理
    #ビーム
    function werewolf:skill/skill_witch/witch_roar_skill/
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
    execute as @a[team=Madseer,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/madseer_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_madseer/.madseer_result
    execute as @a[team=Madseer,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/madseer_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_madseer/.madseer_result
# しろいぬ
    #しろいぬスキル処理
    execute as @a[team=Shiroinu,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/shiroinu_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_shiroinu/.shiroinu_result
    execute as @a[team=Shiroinu,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/shiroinu_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_shiroinu/.shiroinu_result