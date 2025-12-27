# シリアルキラー
    #シリアルキラースキル処理
    execute as @a[team=Serialkiller,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/serialkiller_skill_cooltime,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_serialkiller/.serialkiller_result
    execute as @a[team=Serialkiller,predicate=werewolf:look_at/look_at_player/look_at_players,predicate=werewolf:have_skill/serialkiller_skill,scores={right_click=1..},predicate=werewolf:is_sneaking] run function werewolf:skill/skill_serialkiller/.serialkiller_result