    execute if score GameManager set_meeting_time matches ..5999 run scoreboard players add GameManager set_meeting_time 1200
    scoreboard players operation GameManager set_meeting_time_minutes = GameManager set_meeting_time
    scoreboard players operation GameManager set_meeting_time_minutes /= GameManager tick_minute
    #function werewolf:.settings/view_settings_others
    function werewolf:.settings/view_settings_skill