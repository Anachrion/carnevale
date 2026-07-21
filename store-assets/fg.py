from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os
HOME = os.path.expanduser("~")
W, H = 1024, 500
NAVY = (2, 31, 73); GOLD = (238, 190, 79)
RIGHT = W - 70          # safe right margin

base = Image.new("RGB", (W, H), NAVY)
glow = Image.new("L", (W, H), 0)
ImageDraw.Draw(glow).ellipse([-120, -220, 760, 720], fill=70)
glow = glow.filter(ImageFilter.GaussianBlur(150))
base = Image.composite(Image.new("RGB", (W, H), (16, 58, 118)), base, glow)

mark = Image.open(f"{HOME}/Workspace/carnevale/assets/icon/carnevale_foreground.png").convert("RGBA")
ms = 250
mark = mark.resize((ms, ms), Image.LANCZOS)
MX = 92
base.paste(mark, (MX, (H - ms) // 2), mark)

d = ImageDraw.Draw(base)
X = MX + ms + 62                     # text column start
AVAIL = RIGHT - X

def spaced_w(txt, font, track):
    return sum(d.textlength(c, font=font) for c in txt) + track * (len(txt) - 1)

def fit(txt, track, start, weight=None):
    """largest size whose letterspaced width fits AVAIL"""
    for s in range(start, 8, -1):
        f = ImageFont.truetype("Cinzel.ttf", s)
        if weight:
            try: f.set_variation_by_axes([weight])
            except Exception: pass
        if spaced_w(txt, f, track) <= AVAIL:
            return f
    raise SystemExit("no fit")

def draw_spaced(txt, font, track, x, y, fill):
    for c in txt:
        d.text((x, y), c, font=font, fill=fill)
        x += d.textlength(c, font=font) + track

WORD, WTRACK = "CARNEVALE", 6
TAG, TTRACK = "GANG BUILDER & CARD REFERENCE", 3
tf = fit(WORD, WTRACK, 92, weight=700)
sf = fit(TAG, TTRACK, 26)

tw = spaced_w(WORD, tf, WTRACK)
sw = spaced_w(TAG, sf, TTRACK)
rule_w = max(tw, sw)

ty = 186
draw_spaced(WORD, tf, WTRACK, X, ty, GOLD)
ry = ty + tf.size + 22
d.line([(X, ry), (X + rule_w, ry)], fill=(150, 122, 60), width=2)
draw_spaced(TAG, sf, TTRACK, X, ry + 22, (214, 225, 240))

base.save("play-feature-1024x500.png", "PNG")
print(f"text col x={X} avail={AVAIL} title={tf.size}px w={tw:.0f} tag={sf.size}px w={sw:.0f}")
