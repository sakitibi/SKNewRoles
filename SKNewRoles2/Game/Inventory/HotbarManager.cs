using Godot;
using System;
using System.Collections.Generic;
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

        // 選択中スロットのアイテム情報キャッシュ
        private readonly Dictionary<int, (string ItemId, int Count)> _slotCache = [];

        public void Initialize(MainGameScene scene, Node hotbarNode)
        {
            _scene = scene;
            _hotbarNode = hotbarNode;

            if (_hotbarNode != null && IsInstanceValid(_hotbarNode))
            {
                GD.Print("✅ [HotbarManager] C++ Hotbar ノードとの連携を開始しました。");

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
            // 1〜9キーでスロット切り替え / スロット入替
            for (byte i = 0; i < 9; i++)
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
                    return;
                }
            }

            // 右クリック（アイテム使用）の検知
            if (@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed && mouseEvent.ButtonIndex == MouseButton.Right)
            {
                TryUseCurrentSelectedItem();
            }
        }

        /// <summary>
        /// 現在選択中のスロットにあるアイテムを使用します
        /// </summary>
        private void TryUseCurrentSelectedItem()
        {
            if (_slotCache.TryGetValue(_currentSlotIndex, out var itemDataTuple))
            {
                string itemId = itemDataTuple.ItemId;
                if (string.IsNullOrEmpty(itemId)) return;

                ItemData itemData = _itemDatabase?.GetItem(itemId);
                if (itemData != null)
                {
                    GD.Print($"🖱️ [HotbarManager] スロット {_currentSlotIndex} のアイテム「{itemId}」を使用します。");
                    
                    Node playerNode = GetPlayerNode();
                    itemData.UseItem(playerNode);
                }
            }
        }

        /// <summary>
        /// Hotbar側だけで完結するプレイヤーノードの自動取得メソッド
        /// </summary>
        private Node GetPlayerNode()
        {
            if (_scene != null && IsInstanceValid(_scene))
            {
                Node player = _scene.FindChild("Player", true, false);
                if (player != null && IsInstanceValid(player))
                {
                    return player;
                }
            }

            var rootPlayer = GetTree()?.Root.FindChild("Player", true, false);
            if (rootPlayer != null && IsInstanceValid(rootPlayer))
            {
                return rootPlayer;
            }

            GD.PrintErr("⚠️ [HotbarManager] プレイヤーノードが見つかりませんでした。");
            return this;
        }

        public void SwapSlots(int slotA, int slotB)
        {
            if (slotA == slotB || slotA < 0 || slotA >= 9 || slotB < 0 || slotB >= 9) return;

            if (_hotbarNode != null && IsInstanceValid(_hotbarNode) && _hotbarNode.HasMethod("swap_slots"))
            {
                _hotbarNode.Call("swap_slots", slotA, slotB);
                
                if (_slotCache.TryGetValue(slotA, out var dataA) && _slotCache.TryGetValue(slotB, out var dataB))
                {
                    _slotCache[slotA] = dataB;
                    _slotCache[slotB] = dataA;
                }
                else if (_slotCache.TryGetValue(slotA, out dataA))
                {
                    _slotCache[slotB] = dataA;
                    _slotCache.Remove(slotA);
                }
                else if (_slotCache.TryGetValue(slotB, out dataB))
                {
                    _slotCache[slotA] = dataB;
                    _slotCache.Remove(slotB);
                }
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
            if (index >= 9) return;
            _currentSlotIndex = index;

            if (_hotbarNode != null && IsInstanceValid(_hotbarNode) && _hotbarNode.HasMethod("select_slot"))
            {
                _hotbarNode.Call("select_slot", index);
            }
        }

        private void OnSlotChanged(int newIndex)
        {
            _currentSlotIndex = newIndex;
            _uiController?.UpdateSelectedSlot(newIndex);
            _ = SendHotbarSlotAsync(newIndex);
        }

        private void OnItemChanged(int slotIndex, string itemId, int count)
        {
            if (string.IsNullOrEmpty(itemId) || count <= 0)
            {
                _slotCache.Remove(slotIndex);
            }
            else
            {
                _slotCache[slotIndex] = (itemId, count);
            }

            ItemData data = _itemDatabase?.GetItem(itemId);
            Texture2D iconTexture = data?.Icon;

            _uiController?.UpdateSlotItem(slotIndex, iconTexture, count);
            _ = SendHotbarItemAsync(slotIndex, itemId, (ushort)count);
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