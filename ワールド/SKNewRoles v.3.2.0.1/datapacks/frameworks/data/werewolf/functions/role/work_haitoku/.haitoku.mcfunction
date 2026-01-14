playsound minecraft:ui.button.click master @s ~ ~100 ~ 1 1 0.3

execute if entity @a[tag=team_youko] run tellraw @s[team=Haitoku] [{"text":"今回の妖狐は… "},{"selector":"@a[tag=team_youko]"},{"text":" のようだ。"}]
execute unless entity @a[tag=team_youko] run tellraw @s[team=Haitoku] [{"text":"今回妖狐は居ないようだ…"}]