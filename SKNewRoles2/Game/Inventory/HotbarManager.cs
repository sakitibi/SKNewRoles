using Godot;
using System;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Game.Inventory.Item;

namespace SKNewRoles2.Game.Inventory
{
    [GlobalClass]
    public partial class HotbarManager : Node
    {
        private MainGameScene _scene;
        private Node _hotbarNode;
        private int _currentSlotIndex = 0;

        [Export] private ItemDatabase _itemDatabase;
        [Export] private HotbarUIController _uiController;

        public void Initialize(MainGameScene scene, Node hotbarNode)
        {
            _scene = scene;
            _hotbarNode = hotbarNode;

            // C++ノードからのシグナル接続
            if (_hotbarNode != null && IsInstanceValid(_hotbarNode))
            {
                GD.Print("✅ [HotbarManager] Hotbar ノードとの連携を開始しました。");

                if (_hotbarNode.HasSignal("slot_changed"))
                {
                    if (!_hotbarNode.IsConnected("slot_changed", Callable.From<int>(OnSlotChanged)))
                        _hotbarNode.Connect("slot_changed", Callable.From<int>(OnSlotChanged));
                }
                if (_hotbarNode.HasSignal("item_changed"))
                {
                    if (!_hotbarNode.IsConnected("item_changed", Callable.From<int, string, int>(OnItemChanged)))
                        _hotbarNode.Connect("item_changed", Callable.From<int, string, int>(OnItemChanged));
                }
            }
            else
            {
                GD.PrintErr("❌ [HotbarManager] Hotbar ノードが null です。接続に失敗しました。");
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

        /// <summary>
        /// アイテム入手・配布時に外部から呼び出す処理
        /// </summary>
        public bool PickupItem(string itemId, int count = 1)
        {
            if (_hotbarNode != null && IsInstanceValid(_hotbarNode) && _hotbarNode.HasMethod("add_item"))
            {
                Variant result = _hotbarNode.Call("add_item", itemId, count);
                return (bool)result;
            }
            return false;
        }

        public void SelectSlot(int index)
        {
            if (index < 0 || index >= 9) return;
            _currentSlotIndex = index;

            // C++ 側のスロット選択メソッドを呼び出し
            if (_hotbarNode != null && IsInstanceValid(_hotbarNode) && _hotbarNode.HasMethod("select_slot"))
            {
                _hotbarNode.Call("select_slot", index);
            }
        }

        private void OnSlotChanged(int newIndex)
        {
            _currentSlotIndex = newIndex;

            // UI 側のハイライト表示を更新
            _uiController?.UpdateSelectedSlot(newIndex);

            // 選択変更を他プレイヤーへ送信
            _ = SendHotbarSlotAsync(newIndex);
        }

        private void OnItemChanged(int slotIndex, string itemId, int count)
        {
            GD.Print($"📦 [HotbarManager] ItemChanged 受信: Slot={slotIndex}, Item={itemId}, Count={count}");

            ItemData data = _itemDatabase?.GetItem(itemId);
            Texture2D iconTexture = data?.Icon;

            if (data == null && !string.IsNullOrEmpty(itemId))
            {
                GD.PrintErr($"⚠️ [HotbarManager] ItemDatabase に '{itemId}' のデータが存在しません。");
            }

            _uiController?.UpdateSlotItem(slotIndex, iconTexture, count);
            _ = SendHotbarItemAsync(slotIndex, itemId, count);
        }

        private async Task SendHotbarSlotAsync(int slotIndex)
        {
            try
            {
                if (_scene == null) return;
                string userId = MainGameScene.GetMyUserId();
                await RealtimeBroadcaster.SendHotbarSlotAsync(_scene.Connection, userId, slotIndex);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Hotbar] スロット同期送信エラー: {ex.Message}");
            }
        }

        private async Task SendHotbarItemAsync(int slotIndex, string itemId, int count)
        {
            try
            {
                if (_scene == null) return;
                string userId = MainGameScene.GetMyUserId();
                await RealtimeBroadcaster.SendHotbarItemAsync(_scene.Connection, userId, slotIndex, itemId, count);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Hotbar] アイテム更新送信エラー: {ex.Message}");
            }
        }
    }
}