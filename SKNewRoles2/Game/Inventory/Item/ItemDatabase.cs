using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game.Inventory.Item
{
    [GlobalClass]
    public partial class ItemDatabase : Node
    {
        public static ItemDatabase Instance { get; private set; }

        [Export] private Godot.Collections.Array<ItemData> _itemList = [];
        private readonly Dictionary<string, ItemData> _database = [];

        public override void _Ready()
        {
            Instance = this;

            // 初期リストの登録
            foreach (ItemData item in _itemList)
            {
                RegisterItem(item);
            }
        }

        public override void _ExitTree()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }

        /// <summary>
        /// 外部から新しいアイテムを動的に登録します
        /// </summary>
        public void RegisterItem(ItemData item)
        {
            if (item == null || string.IsNullOrEmpty(item.ItemId))
            {
                GD.PrintErr("⚠️ [ItemDatabase] 無効なアイテムデータまたはItemIdです。");
                return;
            }

            if (_database.TryGetValue(item.ItemId, out ItemData _))
            {
                GD.Print($"⚠️ [ItemDatabase] アイテムID '{item.ItemId}' は既に登録されています。上書きします。");
                _database[item.ItemId] = item;
            }
            else
            {
                _database.Add(item.ItemId, item);
                GD.Print($"✅ [ItemDatabase] MOD/外部からアイテムを登録しました: {item.ItemId} ({item.ItemName})");
            }

            GodotObject combatRegistry = ClassDB.Instantiate("CombatRegistry").AsGodotObject();
            if (combatRegistry == null)
            {
                GD.PrintErr("[ItemDatabase] Error: Failed to instantiate C++ CombatRegistry.");
                return;
            }
            else
            {
                combatRegistry.Call("register_weapon_damage", item.ItemId, item.WeaponDamage);
            }
        }

        /// <summary>
        /// 複数のアイテムをまとめて登録します
        /// </summary>
        public void RegisterItems(IEnumerable<ItemData> items)
        {
            foreach (ItemData item in items)
            {
                RegisterItem(item);
            }
        }

        public ItemData GetItem(string itemId)
        {
            if (string.IsNullOrEmpty(itemId)) return null;
            return _database.TryGetValue(itemId, out var data) ? data : null;
        }
    }
}