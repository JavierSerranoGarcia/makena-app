#!/usr/bin/env python3
"""Generates Play Store graphics: app icon (512x512) and feature graphic (1024x500)."""

from PIL import Image, ImageDraw, ImageFont
import math, os

OUT = os.path.expanduser("~/Desktop")
BG       = (31, 28, 26)       # #1F1C1A
ACCENT   = (212, 163, 150)     # #D4A396
ACCENT2  = (180, 120, 100)     # slightly deeper rose
LIGHT    = (232, 221, 216)     # #E8DDD8
MID      = (80, 65, 60)        # subtle ring colour

FONT_BOLD   = "/usr/share/fonts/opentype/urw-base35/NimbusSans-Bold.otf"
FONT_REGULAR = "/usr/share/fonts/opentype/urw-base35/NimbusSans-Regular.otf"


def draw_silhouette(draw, cx, cy, scale=1.0, color=ACCENT):
    """Draw a minimal female body silhouette centred at (cx, cy)."""
    s = scale
    # Head
    r = int(28 * s)
    draw.ellipse([cx - r, cy - int(110 * s) - r, cx + r, cy - int(110 * s) + r], fill=color)
    # Neck
    nw = int(14 * s)
    draw.rectangle([cx - nw, cy - int(110 * s) + r, cx + nw, cy - int(78 * s)], fill=color)
    # Shoulders (wide arc via polygon)
    sw = int(60 * s)
    sh = int(20 * s)
    draw.ellipse([cx - sw, cy - int(78 * s) - sh, cx + sw, cy - int(78 * s) + sh], fill=color)
    # Torso — hourglass shape via polygon
    torso = [
        (cx - int(52 * s), cy - int(78 * s)),   # shoulder L
        (cx + int(52 * s), cy - int(78 * s)),   # shoulder R
        (cx + int(38 * s), cy - int(10 * s)),   # waist R
        (cx + int(55 * s), cy + int(60 * s)),   # hip R
        (cx - int(55 * s), cy + int(60 * s)),   # hip L
        (cx - int(38 * s), cy - int(10 * s)),   # waist L
    ]
    draw.polygon(torso, fill=color)
    # Legs
    lw = int(22 * s)
    draw.rectangle([cx - int(52 * s), cy + int(60 * s), cx - int(52 * s) + lw * 2, cy + int(160 * s)], fill=color)
    draw.rectangle([cx + int(52 * s) - lw * 2, cy + int(60 * s), cx + int(52 * s), cy + int(160 * s)], fill=color)


def make_icon():
    size = 512
    img = Image.new("RGB", (size, size), BG)
    draw = ImageDraw.Draw(img)

    # Subtle radial glow behind silhouette
    for r in range(200, 0, -4):
        alpha = int(18 * (1 - r / 200))
        c = tuple(min(255, BG[i] + alpha) for i in range(3))
        draw.ellipse([size // 2 - r, size // 2 - r, size // 2 + r, size // 2 + r], fill=c)

    # Decorative ring
    draw.ellipse([size // 2 - 175, size // 2 - 175, size // 2 + 175, size // 2 + 175],
                 outline=MID, width=2)

    # Silhouette
    draw_silhouette(draw, size // 2, size // 2 + 30, scale=1.45, color=ACCENT)

    # Colour palette dots at bottom
    palette = [(212, 163, 150), (180, 140, 120), (150, 110, 95), (230, 200, 185), (100, 75, 65)]
    dot_r = 14
    total_w = len(palette) * (dot_r * 2 + 8) - 8
    sx = size // 2 - total_w // 2
    for i, col in enumerate(palette):
        x = sx + i * (dot_r * 2 + 8) + dot_r
        draw.ellipse([x - dot_r, size - 52 - dot_r, x + dot_r, size - 52 + dot_r], fill=col)

    path = os.path.join(OUT, "makena-icon-512.png")
    img.save(path)
    print(f"Icon saved → {path}")


def make_feature():
    W, H = 1024, 500
    img = Image.new("RGB", (W, H), BG)
    draw = ImageDraw.Draw(img)

    # Gradient wash left → right
    for x in range(W):
        t = x / W
        r = int(BG[0] + (45 - BG[0]) * t * 0.4)
        g = int(BG[1] + (35 - BG[1]) * t * 0.4)
        b = int(BG[2] + (30 - BG[2]) * t * 0.4)
        draw.line([(x, 0), (x, H)], fill=(r, g, b))

    # Accent arc (decorative)
    draw.arc([W - 380, -80, W + 80, H + 80], start=150, end=210, fill=MID, width=2)
    draw.arc([W - 320, -40, W + 40, H + 40], start=150, end=210, fill=(55, 45, 40), width=1)

    # Silhouette on the right
    draw_silhouette(draw, W - 200, H // 2 + 20, scale=1.6, color=(45, 38, 34))
    draw_silhouette(draw, W - 200, H // 2 + 20, scale=1.55, color=ACCENT)

    # Left side text
    try:
        font_title = ImageFont.truetype(FONT_BOLD, 92)
        font_sub   = ImageFont.truetype(FONT_REGULAR, 28)
        font_tag   = ImageFont.truetype(FONT_REGULAR, 22)
    except Exception:
        font_title = font_sub = font_tag = ImageFont.load_default()

    # App name
    draw.text((72, 120), "makena", font=font_title, fill=ACCENT)

    # Tagline
    draw.text((76, 232), "Discover your shape.", font=font_sub, fill=LIGHT)
    draw.text((76, 268), "Own your style.", font=font_sub, fill=LIGHT)

    # Colour dots row
    palette = [(212, 163, 150), (180, 140, 120), (150, 110, 95), (230, 200, 185), (100, 75, 65)]
    dot_r = 12
    sx = 76
    for i, col in enumerate(palette):
        x = sx + i * (dot_r * 2 + 10) + dot_r
        draw.ellipse([x - dot_r, 340 - dot_r, x + dot_r, 340 + dot_r], fill=col)

    # Fine separator line
    draw.line([(76, 310), (340, 310)], fill=MID, width=1)

    path = os.path.join(OUT, "makena-feature-1024x500.png")
    img.save(path)
    print(f"Feature graphic saved → {path}")


if __name__ == "__main__":
    make_icon()
    make_feature()
    print("Done.")
