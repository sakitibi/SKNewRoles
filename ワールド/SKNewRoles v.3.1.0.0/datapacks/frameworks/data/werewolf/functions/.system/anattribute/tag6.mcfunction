# 村人陣営強化
tag @a[tag=6,team=Mura] add PanyaChange
team join Panya @a[tag=PanyaChange]
tag @a[tag=PanyaChange] remove team_mura
tag @a[tag=PanyaChange] add team_panya
tag @a[team=Panya,tag=PanyaChange] remove PanyaChange

# 人狼陣営強化
tag @a[tag=6,team=Kyoujin] add KyoushinChange
team join Kyoushin @a[tag=KyoushinChange]
tag @a[tag=KyoushinChange] add team_kyoushin
tag @a[tag=KyoushinChange] remove team_kyoujin
tag @a[team=Kyoushin,tag=KyoushinChange] remove KyoushinChange

tag @a[tag=6,team=Jinrou] add RimokonChange
team join Rimokon @a[tag=RimokonChange]
tag @a[tag=RimokonChange] add team_rimokon
tag @a[tag=RimokonChange] remove team_jinrou
tag @a[team=Rimokon,tag=RimokonChange] remove RimokonChange

# 第三陣営強化
tag @a[tag=6,team=Haitoku] add YoukoChange
team join Youko @a[tag=YoukoChange]
tag @a[tag=YoukoChange] add team_youko
tag @a[tag=YoukoChange] remove team_haitoku
tag @a[team=Youko,tag=YoukoChange] remove YoukoChange

function werewolf:.system/anattribute/itemreset