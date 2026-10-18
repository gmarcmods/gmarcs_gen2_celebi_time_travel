"""Author a 16x16 four-shade GSC-style radio; no source game art is copied."""
from pathlib import Path
from PIL import Image

# Transparent background, housing, speaker grille, dial, split aerial and
# a dark indicator. Keep the pixels explicit so the asset can be revised.
PIXELS = [
    '................',
    '..........3.....',
    '.........3......',
    '........3.......',
    '.....333........',
    '..333333333333..',
    '.31111111111113.',
    '.31222223333313.',
    '.31232323000313.',
    '.31223223101313.',
    '.31232323333313.',
    '.31223223133113.',
    '.31232323103113.',
    '.31111111111113.',
    '..333333333333..',
    '...33......33...',
]
COLORS = {'.': (0, 0, 0, 0), '0': (255, 255, 255, 255),
          '1': (170, 170, 170, 255), '2': (85, 85, 85, 255),
          '3': (0, 0, 0, 255)}
assert len(PIXELS) == 16 and all(len(row) == 16 for row in PIXELS)
image = Image.new('RGBA', (16, 16))
image.putdata([COLORS[pixel] for row in PIXELS for pixel in row])
image.save(Path(__file__).resolve().parents[1] / 'assets/broken-radio.png')
