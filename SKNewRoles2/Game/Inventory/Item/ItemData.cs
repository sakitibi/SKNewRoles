using Godot;

namespace SKNewRoles2.Game.Inventory.Item
{
    [GlobalClass]
    public partial class ItemData : Resource
    {
        [Export] public string ItemId { get; set; } = "";
        [Export] public string ItemName { get; set; } = "";
        [Export] public Texture2D Icon { get; set; }
        [Export] public int MaxStack { get; set; } = 64;
    }
}