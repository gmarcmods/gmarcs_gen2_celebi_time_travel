"""Hand-authored GSC-scale Celebi: front/back/side and two wing positions.

No HGSS bitmap is used. Shades 1/2/3 are remapped by Celebi's native Pokémon
palette. Shade zero is deliberately absent: native OBJ color zero is clear.
"""
from pathlib import Path
from PIL import Image

FRONT = [
    '.......3........',
    '......313.......',
    '.....31113......',
    '....3111113.....',
    '...311111113....',
    '..31131131113...',
    '..31131131113...',
    '...311221113....',
    '....3111113.....',
    '..33.32223.33...',
    '.3113311133113..',
    '.3111311131113..',
    '..33331113333...',
    '.....32223......',
    '....313.313.....',
    '.....3...3......',
]
BACK = [
    '.......3........',
    '......313.......',
    '.....31113......',
    '....3111113.....',
    '...311111113....',
    '..31111111113...',
    '..31111111113...',
    '...312222213....',
    '....3222223.....',
    '..33.32223.33...',
    '.3113311133113..',
    '.3111311131113..',
    '..33331213333...',
    '.....32223......',
    '....323.323.....',
    '.....3...3......',
]
SIDE = [
    '.........3......',
    '........313.....',
    '......33113.....',
    '....3311113.....',
    '...311111113....',
    '..31131111113...',
    '..31131111113...',
    '...311122213....',
    '....3112223.....',
    '.....32223.33...',
    '....3111333113..',
    '...31111311113..',
    '....311133333...',
    '.....32223......',
    '....313.323.....',
    '.....3...3......',
]
COLORS = {'.': (0, 0, 0, 0), '1': (170, 170, 170, 255),
          '2': (85, 85, 85, 255), '3': (0, 0, 0, 255)}

def flap(rows, side=False):
    result = rows.copy()
    # Wings lift beside the neck, then fold into narrower lower silhouettes.
    if side:
        result[8] = '....311222333...'
        result[9] = '.....322231113..'
        result[10] = '....3111331113..'
        result[11] = '...3111133333...'
        result[12] = '....31113.......'
    else:
        result[8] = '..33311111333...'
        result[9] = '.3113322233113..'
        result[10] = '.3113311133113..'
        result[11] = '..33331113333...'
        result[12] = '.....31113......'
    return result

frames = [FRONT, BACK, SIDE, flap(FRONT), flap(BACK), flap(SIDE, True)]
image = Image.new('RGBA', (16, 96))
for index, rows in enumerate(frames):
    assert len(rows) == 16 and all(len(row) == 16 for row in rows)
    frame = Image.new('RGBA', (16, 16))
    frame.putdata([COLORS[p] for row in rows for p in row])
    image.paste(frame, (0, index * 16))
image.save(Path(__file__).resolve().parents[1] / 'assets/celebi.png')
