from __future__ import annotations

import math
from pathlib import Path
from random import Random

from PIL import Image, ImageDraw, ImageFont


OUT = Path("amo-personal-ip-illustrations/assets/examples/03-authorized-starfish-operator.png")
SCALE = 3
W, H = 1600, 900
rng = Random(97)


def S(value: float) -> int:
    return int(round(value * SCALE))


def load_font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        "C:/Windows/Fonts/msyhbd.ttc" if bold else "C:/Windows/Fonts/msyh.ttc",
        "C:/Windows/Fonts/simhei.ttf",
        "C:/Windows/Fonts/arial.ttf",
    ]
    for path in candidates:
        if Path(path).exists():
            return ImageFont.truetype(path, S(size))
    return ImageFont.load_default()


def draw_line(draw: ImageDraw.ImageDraw, points, fill="#171717", width=4, jitter=0.0):
    pts = []
    for x, y in points:
        if jitter:
            x += rng.uniform(-jitter, jitter)
            y += rng.uniform(-jitter, jitter)
        pts.append((S(x), S(y)))
    draw.line(pts, fill=fill, width=S(width), joint="curve")


def draw_poly(draw: ImageDraw.ImageDraw, points, fill, outline="#171717", width=4):
    pts = [(S(x), S(y)) for x, y in points]
    draw.polygon(pts, fill=fill)
    draw.line(pts + [pts[0]], fill=outline, width=S(width), joint="curve")


def rounded_rect(draw, box, radius, fill, outline="#171717", width=4):
    draw.rounded_rectangle([S(v) for v in box], radius=S(radius), fill=fill, outline=outline, width=S(width))


def text(draw, xy, content, size=32, fill="#171717", bold=False, anchor=None):
    font = load_font(size, bold=bold)
    draw.text((S(xy[0]), S(xy[1])), content, font=font, fill=fill, anchor=anchor)


def starfish_points(cx: float, cy: float, rx: float, ry: float):
    points = []
    # Smooth five-limb body. Top limb starts at -90 degrees.
    for i in range(300):
        t = -math.pi / 2 + (math.tau * i / 300)
        lobe = (1 + math.cos(5 * (t + math.pi / 2))) / 2
        waist = (1 + math.cos(10 * (t + math.pi / 2) + math.pi)) / 2
        r = 0.66 + 0.36 * lobe - 0.08 * waist
        # Slightly lengthen arms and soften lower legs.
        top_boost = math.exp(-((t + math.pi / 2) / 0.45) ** 2) * 0.10
        lower_boost = math.exp(-((abs(t - math.pi / 2) - 0.78) / 0.35) ** 2) * 0.06
        r += top_boost + lower_boost
        x = cx + rx * r * math.cos(t)
        y = cy + ry * r * math.sin(t)
        points.append((x, y))
    return points


def draw_card(draw, x, y, w, h, title, accent="#f47b20"):
    shadow = (x + 8, y + 8, x + w + 8, y + h + 8)
    rounded_rect(draw, shadow, 16, fill="#f2f2f2", outline="#f2f2f2", width=1)
    rounded_rect(draw, (x, y, x + w, y + h), 16, fill="#ffffff", outline="#171717", width=4)
    draw_line(draw, [(x + 24, y + 44), (x + w - 28, y + 44)], fill=accent, width=5, jitter=1.0)
    draw_line(draw, [(x + 26, y + 77), (x + w - 40, y + 77)], width=3, jitter=0.8)
    draw_line(draw, [(x + 26, y + 103), (x + w - 56, y + 103)], width=2, jitter=0.8)
    text(draw, (x + w / 2, y + 20), title, size=24, bold=True, anchor="mm")


def main():
    img = Image.new("RGB", (S(W), S(H)), "white")
    draw = ImageDraw.Draw(img)

    # Gentle hand-drawn ground.
    draw_line(draw, [(110, 760), (1480, 760)], width=3, jitter=1.0)

    # Right-side multi-platform cards.
    draw_card(draw, 940, 260, 170, 132, "Codex", "#f47b20")
    draw_card(draw, 1148, 310, 170, 132, "Hermes", "#2f80ed")
    draw_card(draw, 1032, 510, 170, 132, "Claude", "#d84a35")
    draw_card(draw, 1265, 500, 160, 132, "GEO", "#7a4ec2")

    # Orange path connecting the workflow.
    draw_line(
        draw,
        [(645, 555), (810, 445), (935, 325), (1138, 375), (1260, 560), (1430, 560)],
        fill="#f47b20",
        width=7,
        jitter=1.6,
    )

    # Soft content papers on the left.
    for i in range(5):
        x = 170 + i * 20
        y = 535 - i * 18
        paper = [(x, y), (x + 190, y - 14), (x + 210, y + 72), (x + 16, y + 90)]
        draw_poly(draw, paper, fill="#ffffff", outline="#171717", width=3)
        draw_line(draw, [(x + 32, y + 28), (x + 160, y + 16)], width=2, jitter=1.0)
        draw_line(draw, [(x + 38, y + 54), (x + 140, y + 45)], width=2, jitter=1.0)
    text(draw, (185, 475), "真实经验", size=30, fill="#2f80ed", bold=True)

    # Rounded authorized starfish character.
    cx, cy = 560, 455
    body = starfish_points(cx, cy, 275, 315)
    draw_poly(draw, body, fill="#f5a0ad", outline="#171717", width=7)

    # Freckles / soft spots.
    for x, y, r in [(460, 350, 7), (650, 340, 6), (438, 474, 5), (690, 505, 8), (585, 285, 5)]:
        draw.ellipse([S(x - r), S(y - r), S(x + r), S(y + r)], fill="#e47c8c")

    # Shorts with softer shape.
    shorts = [(410, 560), (705, 545), (740, 635), (645, 695), (565, 640), (490, 698), (386, 635)]
    draw_poly(draw, shorts, fill="#79b956", outline="#171717", width=6)
    draw_line(draw, [(425, 570), (535, 596), (700, 555)], fill="#4b9238", width=5, jitter=1.2)
    for x, y in [(492, 610), (598, 592), (665, 640)]:
        draw.ellipse([S(x - 17), S(y - 12), S(x + 17), S(y + 12)], fill="#8f5ac7", outline="#171717", width=S(3))

    # Friendly face, closer to public-facing IP.
    for ex in [510, 600]:
        draw.ellipse([S(ex - 28), S(cy - 130), S(ex + 28), S(cy - 62)], fill="#ffffff", outline="#171717", width=S(5))
        draw.ellipse([S(ex - 5), S(cy - 97), S(ex + 9), S(cy - 72)], fill="#171717")
    draw_line(draw, [(522, 455), (563, 472), (623, 448)], width=5, jitter=0.8)
    draw_line(draw, [(505, 315), (540, 300)], width=4, jitter=0.8)
    draw_line(draw, [(590, 300), (633, 312)], width=4, jitter=0.8)

    # Arms interacting with workflow.
    draw_line(draw, [(372, 505), (315, 560), (292, 610)], width=10, jitter=1.0)
    draw_line(draw, [(704, 405), (805, 385), (888, 330)], width=10, jitter=1.0)
    draw.ellipse([S(875), S(312), S(920), S(350)], fill="#f5a0ad", outline="#171717", width=S(5))

    # Small stamp in hand.
    rounded_rect(draw, (850, 220, 935, 275), 14, fill="#171717", outline="#171717", width=3)
    rounded_rect(draw, (872, 272, 913, 330), 8, fill="#f5f5f5", outline="#171717", width=4)
    draw.rectangle([S(840), S(328), S(945), S(355)], fill="#171717")
    text(draw, (915, 202), "压成资产", size=26, fill="#d84a35", bold=True)

    # Warning tag on the papers, less ugly than v1 but still functional.
    tag = [(350, 620), (408, 632), (394, 705), (332, 690)]
    draw_poly(draw, tag, fill="#d84a35", outline="#171717", width=4)
    draw_line(draw, [(370, 646), (370, 675)], fill="#ffffff", width=5)
    draw.ellipse([S(365), S(684), S(376), S(696)], fill="#ffffff")

    # Clean title notes.
    text(draw, (950, 710), "多平台可用", size=30, fill="#171717", bold=True)
    draw_line(draw, [(948, 750), (1150, 750)], fill="#f47b20", width=5, jitter=1.2)
    text(draw, (1218, 710), "LLM 可发现", size=30, fill="#2f80ed", bold=True)

    # Tiny spark lines around final output.
    for angle in [0, 55, 110, 180, 250, 305]:
        x = 1438 + math.cos(math.radians(angle)) * 36
        y = 560 + math.sin(math.radians(angle)) * 34
        draw_line(draw, [(x, y), (x + math.cos(math.radians(angle)) * 18, y + math.sin(math.radians(angle)) * 18)], width=3)

    img = img.resize((W, H), Image.Resampling.LANCZOS)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    img.save(OUT)
    print(OUT)


if __name__ == "__main__":
    main()
