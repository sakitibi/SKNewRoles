    scoreboard players add GameManager set_first_daytime 1200
    scoreboard players operation GameManager set_first_daytime_minutes = GameManager set_first_daytime
    scoreboard players operation GameManager set_first_daytime_minutes /= GameManager tick_minute
    function werewolf:.settings/view_settings_others