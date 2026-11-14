using Godot;
using System;

namespace SKNewRoles2.Game.Inventory.Item
{
    [GlobalClass]
    public partial class ItemData : Resource
    {
        [Export] public string ItemId { get; set; } = "";
        [Export] public string ItemName { get; set; } = "";
        [Export] public Texture2D Icon { get; set; }
        [Export] public byte MaxStack { get; set; } = 64;
        public Action<Node> OnUseAction { get; set; }

        /// <summary>
        /// アイテムを持ちながら右クリックしたときの処理テンプレート
        /// </summary>
        public void UseItem(Node user)
        {
            GD.Print($"[ItemData] {ItemName} が使用されました。");
            
            // MOD側から設定されたカスタム処理があれば実行する
            OnUseAction?.Invoke(user);
        }
    }
}