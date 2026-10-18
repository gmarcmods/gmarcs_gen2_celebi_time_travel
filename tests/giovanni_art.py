"""Validate original editable field art and the exact shipped native sheet."""
import importlib.util
import json
from pathlib import Path
from PIL import Image
workspace=Path(__file__).resolve().parents[4]
spec=importlib.util.spec_from_file_location('sprites',workspace/'workspace/tools/sprites.py')
sprites=importlib.util.module_from_spec(spec);spec.loader.exec_module(sprites)
root=Path(__file__).resolve().parents[1]
data=json.loads((root/'art/giovanni/sprite.json').read_text())
p=sprites.Project(data)
sheet=Image.open(root/'assets/giovanni.png').convert('RGBA')
assert sheet.size==(16,96)
frames=[p.image(name) for name in sprites.NATIVE_ORDER]
assert len({frame.tobytes() for frame in frames[:3]})==3,'directions are identical'
for i,frame in enumerate(frames):
 assert frame.tobytes()==sheet.crop((0,i*16,16,(i+1)*16)).tobytes(),'shipped art differs from editable master'
 if i<3:
  assert frame.crop((0,0,16,9)).tobytes()==frames[i+3].crop((0,0,16,9)).tobytes(),'walk changed face/hat identity'
  assert frame.crop((0,12,16,16)).tobytes()!=frames[i+3].crop((0,12,16,16)).tobytes(),'legs are frozen'
 assert any(pixel[3]==0 for pixel in frame.get_flattened_data()),'opaque background'
assert data['identity']['provenance'].startswith('Original')
print('GIOVANNI ART PASS: original layered source, native export, shared head and distinct directional/walk poses')
