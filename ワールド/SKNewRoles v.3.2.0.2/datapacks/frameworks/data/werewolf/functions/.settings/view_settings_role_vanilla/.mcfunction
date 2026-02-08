#コマンド表示オフ
    gamerule sendcommandfeedback false

#上段調節
    tellraw @s {"text":"\n\n\n\n\n\n\n\n\n\n\n\n\n\n[Settings]"}

#人数設定
        tellraw @s {"text":" [役職人数]"}
        schedule function werewolf:.settings/view_settings_role_vanilla/mura 1t append false
        schedule function werewolf:.settings/view_settings_role_vanilla/jinrou 1t append false
        schedule function werewolf:.settings/view_settings_role_vanilla/other 1t append false
    tellraw @s [{"text":"← 戻る","color":"green","clickEvent":{"action":"run_command","value":"/function werewolf:.settings/view_settings"}}]

    #設定を更新
        function werewolf:.settings/reload_settings

#人狼
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"狼(人狼)","color":"red"},{"text":"\nスキル: \n > 切り裂く - 目の前の相手を一撃でキルすることができる\n > 咆哮(夜限定) - 直線上の相手を一撃でキルすることができる\n特殊能力:\n > 誰が人狼か知ることができる(役職本から確認可能)\n > 転移の炎(ワープポイント)を使用できる"}]}
#アサシン
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"狼(人狼)","color":"red"},{"text":"\nスキル: \n > 切り裂く - 目の前の相手を一撃でキルすることができる\n特殊能力:\n > 誰が人狼か知ることができる(役職本から確認可能)\n > 転移の炎(ワープポイント)を使用できる\n > スキルで相手をキルすると一定時間透明になる"}]}

#狂人
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"狼(狂人)","color":"red"},{"text":"\nスキル: \n > なし"}]}
#狂信者
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"狼(狂人)","color":"red"},{"text":"\nスキル: \n > なし\n特殊能力:\n > 誰が人狼か知ることができる(役職本から確認可能)"}]}
#罠師
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"狼(狂人)","color":"red"},{"text":"\nスキル: \n > 落とし穴 - 足元に狼陣営のみ視認可能な罠を設置する"}]}
#占い師
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"村","color":"green"},{"text":"\nスキル: \n > 占い - 相手が人狼か否かを確認できる"}]}
#霊能者
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"村","color":"green"},{"text":"\nスキル: \n > 霊能 - 墓となったプレイヤーが人狼であったか確認できる"}]}
#騎士
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"村","color":"green"},{"text":"\nスキル: \n > 守護 - 相手を人狼のスキルから護ることができる"}]}
#シェリフ
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"村","color":"green"},{"text":"\nスキル: \n > 正義執行 - 相手が狼陣営ならキルできる\n          その他陣営なら自身が死亡する"}]}
#妖狐
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"第三陣営","color":"aqua"},{"text":"\nスキル: \n > サイドキック(初日の昼のみ) - 相手を1人従えることができる\n特殊能力:\n > 人狼のスキルによって倒されない\n > 占われると死亡する\n勝利条件:\n >他陣営が勝利条件を満たす＋妖狐陣営の生存"}]}
#死神
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"第三陣営","color":"aqua"},{"text":"\nスキル: \n > 憑依 - 相手をキルしてその役職になり替わる"}]}
#キューピット
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"第三陣営","color":"aqua"},{"text":"\nスキル: \n > 縁結び - 直線上の相手をラバーズにする\n        ラバーズが2人になった時からスキルが封印される\n勝利条件:\n > ①村陣営または狼陣営が全滅＋ラバーズ2人の生存\n > ②キューピットのみの生存"}]}
#共有者
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"村","color":"green"},{"text":"\nスキル: \n > なし\n特殊能力:\n > もう1人の共有者を知ることができる(役職本から確認可能)"}]}
#裁判官
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"村","color":"green"},{"text":"\nスキル: \n > 任命 - 裁判官の後任を1人任命できる\n特殊能力:\n > 裁判官が生存している限り朝に裁判が開廷される"}]}
#オポチュニスト
,"hoverEvent":{"action":"show_text","contents":[{"text":"陣営: "},{"text":"村","color":"green"},{"text":"\nスキル: \n > オポチュニストの一声 - 一度だけクエストを強制的に終了させることができる"}]}