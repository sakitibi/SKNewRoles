# モンスター強化
effect give @e[family=monster] strength 1 2 true
effect give @e[family=monster] speed 1 2 true

# 人狼陣営(狂人除く)を強化
effect give @a[tag=!no_jinrou] strength 1 2 true
effect give @a[tag=!no_jinrou] saturation 1 0 true
effect clear @a[tag=!no_jinrou] slowness