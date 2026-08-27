using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game.Inventory.Item
{
    [GlobalClass]
    public partial class ItemDatabase : Node
    {
        [Export] private Godot.Collections.Array<ItemData> _itemList = [];

        private readonly Dictionary<int, ItemData> _database = [];

        public override void _Ready()
        {
            foreach (var item in _itemList)
            {
                if (item != null && !_database.ContainsKey(item.ItemId))
                {
                    _database.Add(item.ItemId, item);
                }
            }
        }

        public ItemData GetItem(int itemId)
        {
            return _database.TryGetValue(itemId, out var data) ? data : null;
        }
    }
}