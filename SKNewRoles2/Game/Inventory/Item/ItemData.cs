using Godot;

namespace SKNewRoles2.Game.Inventory.Item
{
    [GlobalClass]
    public partial class ItemData : Resource
    {
        [Export] public string ItemId { get; set; } = "";
        [Export] public string ItemName { get; set; } = "";
        [Export] public Texture2D Icon { get; set; }
        [Export] public byte MaxStack { get; set; } = 64;

        /// <summary>
        /// アイテムを持ちながら右クリックしたときの処理テンプレート
        /// </summary>
        public virtual void UseItem(Node user)
        {
            GD.Print($"[ItemData] {ItemName} (ID: {ItemId}) が使用されました。");
        }
    }
}