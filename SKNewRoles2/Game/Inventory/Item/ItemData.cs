using Godot;

namespace SKNewRoles2.Game.Inventory.Item
{
    [GlobalClass]
    public partial class ItemData : Resource
    {
        [Export] public int ItemId { get; set; } = 0;
        [Export] public string ItemName { get; set; } = "";
        [Export] public Texture2D Icon { get; set; }
        [Export] public int MaxStack { get; set; } = 64;
    }
}