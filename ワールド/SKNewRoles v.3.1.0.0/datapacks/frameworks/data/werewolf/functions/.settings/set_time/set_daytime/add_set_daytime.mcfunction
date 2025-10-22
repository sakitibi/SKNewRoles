    scoreboard players add GameManager set_daytime 1200
    scoreboard players operation GameManager set_daytime_minutes = GameManager set_daytime
    scoreboard players operation GameManager set_daytime_minutes /= GameManager tick_minute
    function werewolf:.settings/view_settings_others