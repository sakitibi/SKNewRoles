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

            if (_hotbarNode != null && IsInstanceValid(_hotbarNode))
            {
                GD.Print("✅ [HotbarManager] Hotbar ノードとの連携を開始しました。");

                if (_hotbarNode.HasSignal("slot_changed"))
                {
                    if (!_hotbarNode.IsConnected("slot_changed", Callable.From<ushort>(OnSlotChanged)))
                        _hotbarNode.Connect("slot_changed", Callable.From<ushort>(OnSlotChanged));
                }
                if (_hotbarNode.HasSignal("item_changed"))
                {
                    if (!_hotbarNode.IsConnected("item_changed", Callable.From<int, string, ushort>(OnItemChanged)))
                        _hotbarNode.Connect("item_changed", Callable.From<int, string, ushort>(OnItemChanged));
                }
            }
            else
            {
                GD.PrintErr("❌ [HotbarManager] Hotbar ノードが null です。接続に失敗しました。");
            }
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            for (ushort i = 0; i < 9; i++)
            {
                if (@event.IsActionPressed($"hotbar_slot_{i + 1}"))
                {
                    bool isShiftPressed = Input.IsKeyPressed(Key.Shift);

                    if (isShiftPressed)
                    {
                        SwapSlots(_currentSlotIndex, i);
                    }
                    else
                    {
                        SelectSlot(i);
                    }
                    break;
                }
            }
        }

        public void SwapSlots(int slotA, int slotB)
        {
            if (slotA == slotB) return;
            if (slotA < 0 || slotA >= 9 || slotB < 0 || slotB >= 9) return;

            if (_hotbarNode != null && IsInstanceValid(_hotbarNode) && _hotbarNode.HasMethod("swap_slots"))
            {
                _hotbarNode.Call("swap_slots", slotA, slotB);
            }
            else if (_hotbarNode != null && IsInstanceValid(_hotbarNode) &&
                _hotbarNode.HasMethod("get_item") && _hotbarNode.HasMethod("set_item"))
            {
                Variant itemA = _hotbarNode.Call("get_item", slotA);
                Variant itemB = _hotbarNode.Call("get_item", slotB);

                _hotbarNode.Call("set_item", slotA, itemB);
                _hotbarNode.Call("set_item", slotB, itemA);
            }
        }

        public bool PickupItem(string itemId, ushort count = 1)
        {
            if (_hotbarNode != null && IsInstanceValid(_hotbarNode) && _hotbarNode.HasMethod("add_item"))
            {
                Variant result = _hotbarNode.Call("add_item", itemId, count);
                return (bool)result;
            }
            return false;
        }

        public void SelectSlot(ushort index)
        {
            if (index < 0 || index >= 9) return;
            _currentSlotIndex = index;

            if (_hotbarNode != null && IsInstanceValid(_hotbarNode) && _hotbarNode.HasMethod("select_slot"))
            {
                _hotbarNode.Call("select_slot", index);
            }
        }

        private void OnSlotChanged(ushort newIndex)
        {
            _currentSlotIndex = newIndex;
            _uiController?.UpdateSelectedSlot(newIndex);
            _ = SendHotbarSlotAsync(newIndex);
        }

        private void OnItemChanged(int slotIndex, string itemId, ushort count)
        {
            ItemData data = _itemDatabase?.GetItem(itemId);
            Texture2D iconTexture = data?.Icon;

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
                GD.PrintErr($"⚠️ [Hotbar] スロット送信エラー: {ex.Message}");
            }
        }

        private async Task SendHotbarItemAsync(int slotIndex, string itemId, ushort count)
        {
            try
            {
                if (_scene == null) return;
                string userId = MainGameScene.GetMyUserId();
                await RealtimeBroadcaster.SendHotbarItemAsync(_scene.Connection, userId, slotIndex, itemId, count);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Hotbar] アイテム送信エラー: {ex.Message}");
            }
        }
    }
}