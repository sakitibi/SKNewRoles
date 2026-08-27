using Godot;
using System;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Game.Inventory.Item;

namespace SKNewRoles2.Game.Inventory
{
    public partial class HotbarManager(MainGameScene scene) : Node
    {
        private Node _HotbarNode;
        private int _currentSlotIndex = 0;
        [Export] private ItemDatabase _itemDatabase;
        [Export] private HotbarUIController _uiController;

        public void Initialize(Node HotbarNode)
        {
            _HotbarNode = HotbarNode;

            // C++ノードからのシグナル接続
            if (_HotbarNode != null && IsInstanceValid(_HotbarNode))
            {
                if (_HotbarNode.HasSignal("slot_changed"))
                {
                    _HotbarNode.Connect("slot_changed", Callable.From<int>(OnSlotChanged));
                }
                if (_HotbarNode.HasSignal("item_changed"))
                {
                    _HotbarNode.Connect("item_changed", Callable.From<int, int, int>(OnItemChanged));
                }
            }
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            // キーボード入力（数字の 1〜9 キー）でスロット切り替え
            for (int i = 0; i < 9; i++)
            {
                if (@event.IsActionPressed($"hotbar_slot_{i + 1}"))
                {
                    SelectSlot(i);
                    break;
                }
            }
        }

        public void SelectSlot(int index)
        {
            if (index < 0 || index >= 9) return;
            _currentSlotIndex = index;

            // C++ 側のスロット選択メソッドを呼び出し
            if (_HotbarNode != null && IsInstanceValid(_HotbarNode) && _HotbarNode.HasMethod("select_slot"))
            {
                _HotbarNode.Call("select_slot", index);
            }

            // 選択変更を他プレイヤーへ送信
            _ = SendHotbarSlotAsync(index);
        }

        private void OnSlotChanged(int newIndex)
        {
            _currentSlotIndex = newIndex;
            _ = SendHotbarSlotAsync(newIndex);
        }

        private void OnItemChanged(int slotIndex, int itemId, int count)
        {
            // アイテムデータリソースからテクスチャを取得
            ItemData data = _itemDatabase?.GetItem(itemId);
            Texture2D iconTexture = data?.Icon;

            // UIを更新
            _uiController?.UpdateSlotItem(slotIndex, iconTexture, count);

            // ネットワーク同期を送信
            _ = SendHotbarItemAsync(slotIndex, itemId, count);
        }

        private async Task SendHotbarSlotAsync(int slotIndex)
        {
            try
            {
                string userId = scene.GetMyUserId();
                await RealtimeBroadcaster.SendHotbarSlotAsync(scene.Connection, userId, slotIndex);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Hotbar] スロット同期送信エラー: {ex.Message}");
            }
        }

        private async Task SendHotbarItemAsync(int slotIndex, int itemId, int count)
        {
            try
            {
                string userId = scene.GetMyUserId();
                await RealtimeBroadcaster.SendHotbarItemAsync(scene.Connection, userId, slotIndex, itemId, count);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Hotbar] アイテム更新送信エラー: {ex.Message}");
            }
        }
    }
}