    scoreboard players remove GameManager set_nighttime 1200
    scoreboard players operation GameManager set_nighttime_minutes = GameManager set_nighttime
    scoreboard players operation GameManager set_nighttime_minutes /= GameManager tick_minute
    function werewolf:.settings/view_settings_others