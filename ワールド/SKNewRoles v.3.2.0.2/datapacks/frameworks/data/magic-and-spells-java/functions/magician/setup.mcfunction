tag @e[type=witch,tag=!chargeend] add charge
effect give @e[tag=charge] instant_health 1 255 true
effect give @e[tag=charge] resistance 30 4 true
execute at @e[tag=charge] run summon vex ~ ~ ~
execute at @e[tag=charge] run summon vex ~ ~ ~
execute at @e[tag=charge] run summon vex ~ ~ ~
scoreboard players random @e[tag=charge] witchtype 0 4
schedule function magic-and-spells-java:magician/charge_end 30s append true