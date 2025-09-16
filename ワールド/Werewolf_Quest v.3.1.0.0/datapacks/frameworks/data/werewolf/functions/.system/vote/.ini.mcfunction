scoreboard objectives add can_convence dummy

scoreboard objectives add can_vote dummy
scoreboard objectives add vote_checker dummy

scoreboard objectives add votes dummy
scoreboard objectives add vote_skip dummy

scoreboard objectives add meeting_timer dummy

scoreboard objectives add set_meeting_time dummy
execute unless score GameManager set_meeting_time matches 0.. run scoreboard players set GameManager set_meeting_time 1200
scoreboard objectives add set_meeting_time_minutes dummy
scoreboard players operation GameManager set_meeting_time_minutes = GameManager set_meeting_time
scoreboard players operation GameManager set_meeting_time_minutes /= GameManager tick_minute