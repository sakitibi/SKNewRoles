#エメラルドの納品
data modify storage wolf_data: delivery_emerald.title set value '[{"interpret":true,"nbt":"quest_type.3","storage":"wolf_data:"},{"text":"新月の夜\\uF806\\uF806\\uF806\\uF806","font":"quest_title"}]'
data modify storage wolf_data: delivery_emerald.content.1 set value '[{"text":"目標: エメラルド10個の納品\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806","font":"quest_content1"}]'
data modify storage wolf_data: delivery_emerald.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
data modify storage wolf_data: delivery_emerald.content.3 set value '[{"text":"失敗: 盲目(村/第三陣営)\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803","font":"quest_content3"}]'
data modify storage wolf_data: delivery_emerald.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生: 新月の夜"}]'
data modify storage wolf_data: delivery_emerald.announce.start.2 set value '[{"text":"[システムアナウンス] 夜になるタイミングで発光ツールを使用しろ"}]'
data modify storage wolf_data: delivery_emerald.announce.end.1 set value '[{"text":"盲目を無事乗り切ったようだ"}]'
data modify storage wolf_data: delivery_emerald.announce.success.1 set value '[{"text":"[システムアナウンス] クエスト達成: 無事盲目にならなかった","color":"green"}]'
data modify storage wolf_data: delivery_emerald.announce.failed.1 set value '[{"text":"[システムアナウンス] クエスト失敗: 今夜は盲目になるようだ…","color":"red"}]'

#テンプレート
#画面左アナウンス
#data modify storage wolf_data: x.title set value '[{"interpret":true,"nbt":"quest_type.x","storage":"wolf_data:"},{"text":"","font":"quest_title"}]'
#data modify storage wolf_data: x.content.1 set value '[{"text":"目標: \\uF806\\uF806\\uF806","font":"quest_content1"}]'
#data modify storage wolf_data: x.content.2 set value '[{"text":"報酬:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content2"}]'
#data modify storage wolf_data: x.content.3 set value '[{"text":"失敗:  -\\uF806\\uF806\\uF806\\uF806","font":"quest_content3"}]'
#チャットアナウンス
#data modify storage wolf_data: x.announce.start.1 set value '[{"text":"[システムアナウンス] クエスト発生:"}]'
#data modify storage wolf_data: x.announce.start.2 set value '[{"text":""}]'
#data modify storage wolf_data: x.announce.end.1 set value '[{"text":"[システムアナウンス] クエスト終了:"}]'
#data modify storage wolf_data: x.announce.end.2 set value '[{"text":"[システムアナウンス] ペナルティ終了:"}]'
#data modify storage wolf_data: x.announce.success.1 set value '[{"text":"[システムアナウンス] クエスト達成:"}]'
#data modify storage wolf_data: x.announce.success.2 set value '[{"text":""}]'
#data modify storage wolf_data: x.announce.failed.1 set value '[{"text":"[システムアナウンス] クエスト失敗:"}]'
#data modify storage wolf_data: x.announce.failed.2 set value '[{"text":"[システムアナウンス] ペナルティ発生:"}]'