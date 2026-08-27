using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game.Inventory
{
    [GlobalClass]
    public partial class HotbarUIController : Control
    {
        [Export] private Control _slotContainer;
        [Export] private StyleBox _normalSlotStyle;
        [Export] private StyleBox _selectedSlotStyle;

        private readonly List<Panel> _slotPanels = [];
        private readonly List<TextureRect> _iconRects = [];
        private readonly List<Label> _countLabels = [];

        public override void _Ready()
        {
            if (_slotContainer == null) return;

            foreach (Node child in _slotContainer.GetChildren())
            {
                if (child is Panel slotPanel)
                {
                    _slotPanels.Add(slotPanel);
                    _iconRects.Add(slotPanel.GetNodeOrNull<TextureRect>("Icon"));
                    _countLabels.Add(slotPanel.GetNodeOrNull<Label>("Count"));
                }
            }

            UpdateSelectedSlot(0);
        }

        public void UpdateSelectedSlot(int selectedIndex)
        {
            for (int i = 0; i < _slotPanels.Count; i++)
            {
                if (_normalSlotStyle != null && _selectedSlotStyle != null)
                {
                    var style = (i == selectedIndex) ? _selectedSlotStyle : _normalSlotStyle;
                    _slotPanels[i].AddThemeStyleboxOverride("panel", style);
                }
            }
        }

        public void UpdateSlotItem(int slotIndex, Texture2D iconTexture, int count)
        {
            if (slotIndex < 0 || slotIndex >= _slotPanels.Count) return;

            if (_iconRects[slotIndex] != null)
            {
                _iconRects[slotIndex].Texture = iconTexture;
                _iconRects[slotIndex].Visible = iconTexture != null;
            }

            if (_countLabels[slotIndex] != null)
            {
                _countLabels[slotIndex].Text = count > 1 ? count.ToString() : "";
                _countLabels[slotIndex].Visible = count > 0;
            }
        }
    }
}