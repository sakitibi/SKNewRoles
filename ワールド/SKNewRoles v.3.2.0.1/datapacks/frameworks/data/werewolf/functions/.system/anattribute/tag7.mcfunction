# 人狼陣営弱体化
execute unless entity @a[tag=!7,tag=camp_red] run tag @a[tag=!7,team=Witch] add DoublekillerChange
team join Doublekiller @a[tag=DoublekillerChange]
tag @a[tag=DoublekillerChange] remove team_witch
tag @a[tag=DoublekillerChange] remove team_sorceress
tag @a[tag=DoublekillerChange] add team_doublekiller
tag @a[team=Doublekiller,tag=DoublekillerChange] remove DoublekillerChange

execute unless entity @a[tag=!7,tag=camp_red] run tag @a[tag=!7,team=Rimokon] add JinrouChange
team join Jinrou @a[tag=JinrouChange]
tag @a[tag=JinrouChange] remove team_rimokon
tag @a[tag=JinrouChange] add team_jinrou
tag @a[team=Jinrou,tag=JinrouChange] remove JinrouChange

execute unless entity @a[tag=!7,tag=camp_red] run tag @a[tag=!7,team=Kyoushin] add KyoujinChange
team join Kyoujin @a[tag=KyoujinChange]
tag @a[tag=KyoujinChange] remove team_kyoushin
tag @a[tag=KyoujinChange] add team_kyoujin
tag @a[team=Kyoujin,tag=KyoujinChange] remove KyoujinChange

# 村人陣営弱体化
execute unless entity @a[tag=!7,tag=camp_green] run tag @a[tag=!7,team=Hoankan] add MuraChange
team join Mura @a[tag=MuraChange]
tag @a[tag=MuraChange] remove team_hoankan
tag @a[tag=MuraChange] add team_mura
tag @a[team=Mura,tag=MuraChange] remove MuraChange

execute unless entity @a[tag=!7,tag=camp_green] run tag @a[tag=!7,team=Uranai] add ReinouChange
team join Reinou @a[tag=ReinouChange]
tag @a[tag=ReinouChange] remove team_uranai
tag @a[tag=ReinouChange] add team_reinou
tag @a[team=Reinou,tag=ReinouChange] remove ReinouChange

execute unless entity @a[tag=!7,tag=camp_green] run tag @a[tag=!7,team=Kishi] add KishiChange
team join Panya @a[tag=KishiChange]
tag @a[tag=KishiChange] remove team_kishi
tag @a[tag=KishiChange] add team_panya
tag @a[team=Panya,tag=KishiChange] remove KishiChange

# 第三陣営弱体化
execute unless entity @a[tag=!7,tag=camp_pink] run kill @a[tag=!7,team=Cupid]

function werewolf:.system/anattribute/itemreset