# スキル関連
    schedule function werewolf:skill/.switch_skill/.set_skill_second_day_onwards/loot/mura 1t append false
    schedule function werewolf:skill/.switch_skill/.set_skill_second_day_onwards/loot/jinrou 1t append false
    schedule function werewolf:skill/.switch_skill/.set_skill_second_day_onwards/loot/other 1t append false
    schedule function werewolf:skill/.switch_skill/.set_skill_second_day_onwards/onwards/mura 1t append false
    schedule function werewolf:skill/.switch_skill/.set_skill_second_day_onwards/onwards/jinrou 1t append false
    schedule function werewolf:skill/.switch_skill/.set_skill_second_day_onwards/onwards/other 1t append false
#クールタイム可視化処理
    #人狼 Witch
        #咆哮
        execute if data storage sys: {time_phase:night} as @a[scores={skill_jinrou_roar_cooltime=1..},predicate=werewolf:set_skill/jinrou_roar_skill_cooltime] run function werewolf:skill/skill_jinrou/jinrou_roar_skill/cooltime/set_cooltime
        execute if data storage sys: {time_phase:night} as @a[scores={skill_witch_roar_cooltime=1..},predicate=werewolf:set_skill/witch_roar_skill_cooltime] run function werewolf:skill/skill_witch/witch_roar_skill/cooltime/set_cooltime
        execute as @a[scores={skill_sniper_cooltime=1..},predicate=werewolf:set_skill/sniper_skill_cooltime] run function werewolf:skill/skill_sniper/sniper_skill/cooltime/set_cooltime
    #罠師
    execute as @a[scores={skill_wanashi_cooltime=1..},predicate=werewolf:set_skill/wanashi_skill_cooltime] run function werewolf:skill/skill_wanashi/cooltime/set_cooltime
    #キューピット
    execute as @a[scores={skill_cupid_cooltime=1..},predicate=werewolf:set_skill/cupid_skill_cooltime] run function werewolf:skill/skill_cupid/cooltime/set_cooltime