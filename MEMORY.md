# 🌑 UMBERHOLD MEMORY LOG
**Current Phase:** Phase 2: The Tactical Grid & Navigation (Calibration)
**Date:** Day 2 - Wrap Up (2026-03-27)

## ✅ COMPLETED
- **Environment Setup:** `WorldGenerator.gd` now auto-spawns `DirectionalLight3D` and `WorldEnvironment` (Procedural Sky) to eliminate "Gray Screen" issues.
- **Visual Tactical Grid:** Generated a 20x20 grid with random colors and **Label3D** coordinate markers (A1, B5, etc.) for spatial orientation.
- **Physics Core:** - Implemented 2.0m thick collision boxes for tiles to prevent "Tunneling" (falling through floors).
    - Verified real-time XYZ coordinate changes in the **Remote** tree.
- **First-Person Controller:**
    - Fully functional **Mouse Look** with 89-degree Pitch/Yaw clamping.
    - Calibrated **WASD** movement (Fixed A/D strafe inversion).
    - Integrated **Gravity** and **Jump** (Spacebar) mechanics.
- **Data Flow:** Verified `JSONDataManager.gd` (Autoload) correctly reads `player_stats.json`.

## 🎯 CURRENT GOALS (Phase 3)
- **Raycasting:** Implement "Mouse Pick" to detect and highlight the tile the player is looking at.
- **HUD/UI:** Add a central 2D crosshair and a label showing the "Current Hovered Tile."
- **Interaction:** Enable tile selection or "Unit Placement" logic via mouse click.

## 🐛 KNOWN ISSUES & RESOLUTIONS
- **Resolved:** Fixed the "OverrideCamera3D" bug where the editor camera blocked the player's view.
- **Resolved:** Fixed the "Gray Screen" by forcing `cam.make_current()` during the player spawn sequence.
- **Resolved:** Fixed the "Falling Forever" bug by thickening tile collision and setting player spawn to Y=5.0.

## 📂 PROJECT STRUCTURE
- `/src`: `WorldGenerator.gd`, `PlayerController.gd`, `JSONDataManager.gd`
- `/data`: `player_stats.json`