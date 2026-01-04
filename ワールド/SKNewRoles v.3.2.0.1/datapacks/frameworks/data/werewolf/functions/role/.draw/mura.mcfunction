# 参加者全員を村人に
#team join Mura @a[team=Sanka]
# FFを有効化
team modify Mura friendlyFire true
# ネームタグ不可視
team modify Mura nametagVisibility never
# 透明化不可視
team modify Mura seeFriendlyInvisibles false
# 死亡ログ非表示
team modify Mura deathMessageVisibility never
# 結果出力用の役職タグを付与
tag @a[team=Mura] add team_mura
# 陣営タグを付与
tag @a[team=Mura] add camp_green