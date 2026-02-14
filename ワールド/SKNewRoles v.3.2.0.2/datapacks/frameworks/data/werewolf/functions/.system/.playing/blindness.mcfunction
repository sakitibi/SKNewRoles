execute unless score GameManager glowing_successed matches 1 run execute if data storage sys: random_event.13{active:1} run execute if data storage sys: {time_query:15000} run effect give @s[team=!Yakousei] blindness 1 255 true
execute unless score GameManager glowing_successed matches 1 run execute if data storage sys: random_event.13{active:1} run execute if data storage sys: {time_query:15000} run effect give @s[team=!Yakousei] darkness 1 255 true
execute unless score GameManager glowing_successed matches 1 run execute if data storage sys: random_event.13{active:1} run execute if data storage sys: {time_query:15000} run effect give @s[team=!Yakousei] slowness 1 1 true
execute unless score GameManager glowing_successed matches 1 run execute if data storage sys: random_event.13{active:1} run execute if data storage sys: {time_query:15000} run effect give @s[team=Yakousei] night_vision 1 1 true
execute unless score GameManager glowing_successed matches 1 run execute if data storage sys: {time_query:6000} run effect clear @s blindness
execute unless score GameManager glowing_successed matches 1 run execute if data storage sys: {time_query:6000} run effect clear @s darkness
execute unless score GameManager glowing_successed matches 1 run execute if data storage sys: {time_query:6000} run effect clear @s slowness
execute if score GameManager glowing_successed matches 1 run coreboard players set GameManager event_timer_countdown 0
execute if score GameManager glowing_successed matches 1 run schedule function werewolf:.system/random_event/shingetsu_night/end 1t append false
execute if data storage sys: {time_query:6000} run scoreboard players set GameManager event_timer_countdown 0
execute if data storage sys: random_event.13{active:1} run execute if score GameManager event_timer_countdown matches 0 run execute if data storage sys: {time_query:6000} run schedule function werewolf:.system/random_event/shingetsu_night/end 1t append false