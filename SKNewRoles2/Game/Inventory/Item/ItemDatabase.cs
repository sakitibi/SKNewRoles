using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game.Inventory.Item
{
    [GlobalClass]
    public partial class ItemDatabase : Node
    {
        [Export] private Godot.Collections.Array<ItemData> _itemList = [];

        private readonly Dictionary<string, ItemData> _database = [];

        public override void _Ready()
        {
            foreach (var item in _itemList)
            {
                if (item != null && !string.IsNullOrEmpty(item.ItemId) && !_database.ContainsKey(item.ItemId))
                {
                    _database.Add(item.ItemId, item);
                }
            }
        }

        public ItemData GetItem(string itemId)
        {
            if (string.IsNullOrEmpty(itemId)) return null;
            return _database.TryGetValue(itemId, out var data) ? data : null;
        }
    }
}