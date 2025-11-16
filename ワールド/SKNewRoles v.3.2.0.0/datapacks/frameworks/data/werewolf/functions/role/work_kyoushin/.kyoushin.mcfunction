playsound minecraft:ui.button.click master @s ~ ~100 ~ 1 1 0.3

tellraw @s[team=Kyoushin] [{"text":"今回の人狼は… "},{"selector":"@a[tag=be_written_jinrou]"},{"text":" のようだ。"}]