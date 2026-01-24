execute if entity @a[tag=glowing_failed] run effect give @a[tag=no_jinrou,team=!Tenkai,team=!Fusanka] blindness 100 255 true
execute if entity @a[tag=glowing_failed] run effect give @a[tag=no_jinrou,team=!Tenkai,team=!Fusanka] darkness 100 255 true
execute if entity @a[tag=glowing_failed] run effect give @a[tag=no_jinrou,team=!Tenkai,team=!Fusanka] slowness 100 1 true
execute if entity @a[tag=glowing_failed] run effect give @a[tag=no_jinrou,team=!Tenkai,team=!Fusanka] wither 50 1 true
execute if entity @a[tag=glowing_failed] run kill @r[tag=no_jinrou,team=!Tenkai,team=!Fusanka]
execute if entity @a[tag=glowing_failed] run effect give @a[tag=!no_jinrou,team=!Tenkai,team=!Fusanka] regeneration 100 0 true
execute if entity @a[tag=glowing_failed] run effect give @a[tag=!no_jinrou,team=!Tenkai,team=!Fusanka] resistance 100 3 true
execute if entity @a[tag=glowing_failed] run effect give @a[tag=!no_jinrou,team=!Tenkai,team=!Fusanka] night_vision 100 0 true
execute if entity @a[tag=glowing_failed] run effect give @a[tag=!no_jinrou,team=Kyoujin,team=Kyoushin,team=Wanashi,team=!Tenkai,team=!Fusanka] strength 100 0 true
execute if entity @a[tag=glowing_failed] run effect give @a[tag=!no_jinrou,team=!Tenkai,team=!Fusanka] speed 100 4 true
execute if entity @a[tag=glowing_failed] run give @a[tag=!no_jinrou,team=Kyoujin,team=Kyoushin,team=Wanashi,team=!Tenkai,team=!Fusanka] invisibility 100 255 true
tag @a[tag=glowing_failed] remove glowing_failed