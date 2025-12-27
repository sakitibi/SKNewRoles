    execute store result score GameManager reserve_1 run data get storage sys: task_win.count
    execute if score GameManager reserve_1 matches 10.. run scoreboard players remove GameManager reserve_1 10
    execute store result storage sys: task_win.count int 1 run scoreboard players get GameManager reserve_1
    
    function werewolf:.settings/view_settings_others