// 共通で使用する変数を定義
const INTERVAL_SEC = 1;
/**
 * @param name
 * @return nameにテレポートする
 */
const name = [
    "water_challenge",
    "NMNGyuri"
];
const helpMessages = [
    "§aあなたたちには\n§9恐ろしい悪魔の病などをかける魔女§aになって\n監視人物を気付かれ無いようにこっそり\n殺したり、操ったりして下さい!",
    "§a注意 ベータ版 Script APIを入れてください\nベータ版 Script APIを入れないと正しく動作しません",
    "§a/sda:warp で監視人物にワープします",
    "§a/sda:help でヘルプメッセージを表示します",
    "§a/sda:fp で監視人物に毒を付与する魔法をかけます",
    "§a/sda:testfor で監視人物がワールドに居るか確かめます",
    "§aあとはREADME.htmlをご覧下さい"
];
// 変数をエクスポート
export { name, INTERVAL_SEC, helpMessages };
