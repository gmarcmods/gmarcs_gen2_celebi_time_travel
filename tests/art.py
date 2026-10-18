from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
image = Image.open(root / 'assets/celebi.png').convert('RGBA')
assert image.size == (16, 96), 'native six-frame walker geometry required'
frames = [image.crop((0, y * 16, 16, (y + 1) * 16)) for y in range(6)]
assert len({frame.tobytes() for frame in frames[:3]}) == 3, 'directional poses must differ'
for idle, flap in zip(frames[:3], frames[3:]):
    assert idle.tobytes() != flap.tobytes(), 'wings must animate'
for frame in frames:
    pixels = list(frame.get_flattened_data())
    colors = set(pixels)
    assert (0, 0, 0, 0) in colors, 'field sprite background must be transparent'
    assert sum(pixel[3] > 0 for pixel in pixels) >= 50, 'empty sprite'
    assert all(a == 0 or (r == g == b and r in (0, 85, 170)) for r, g, b, a in colors), 'native OBJ shades only'
print('CELEBI ART PASS: six directional/wing poses, transparent background and native OBJ shades')
