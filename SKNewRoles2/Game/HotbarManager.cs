using Godot;
using System;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;

namespace SKNewRoles2.Game
{
    public partial class HotbarManager(MainGameScene scene) : Node
    {
        private Node _hotbarCppNode;
        private int _currentSlotIndex = 0;

        public void Initialize(Node hotbarCppNode)
        {
            _hotbarCppNode = hotbarCppNode;

            // C++ノードからのシグナル接続
            if (_hotbarCppNode != null && IsInstanceValid(_hotbarCppNode))
            {
                if (_hotbarCppNode.HasSignal("slot_changed"))
                {
                    _hotbarCppNode.Connect("slot_changed", Callable.From<int>(OnSlotChanged));
                }
                if (_hotbarCppNode.HasSignal("item_changed"))
                {
                    _hotbarCppNode.Connect("item_changed", Callable.From<int, int, int>(OnItemChanged));
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
            if (_hotbarCppNode != null && IsInstanceValid(_hotbarCppNode) && _hotbarCppNode.HasMethod("select_slot"))
            {
                _hotbarCppNode.Call("select_slot", index);
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
            // スロット内のアイテム変更を他プレイヤーへ同期
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