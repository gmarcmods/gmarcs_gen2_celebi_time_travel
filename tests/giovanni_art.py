"""The requested original overworld and portrait are physically in mod files."""
import hashlib
import json
from pathlib import Path
from PIL import Image
root=Path(__file__).resolve().parents[1]
records=json.loads((root/'art/giovanni/source.json').read_text())
for name,size in [('overworld',(16,96)),('battle',(56,56))]:
 record=records[name];path=root/record['file']
 assert path.is_file()and not path.is_symlink(),'art must be saved in mod files'
 assert hashlib.sha256(path.read_bytes()).hexdigest()==record['sha256'],'update source record when deliberately editing art'
 image=Image.open(path).convert('RGBA');assert image.size==size
 assert len({pixel for pixel in image.get_flattened_data()})>1,'blank asset'
 if name=='overworld':
  frames=[image.crop((0,i*16,16,(i+1)*16))for i in range(6)]
  assert len({frame.tobytes()for frame in frames[:3]})==3
  for idle,step in zip(frames[:3],frames[3:]):assert idle.tobytes()!=step.tobytes(),'walking is frozen'
print('GIOVANNI ART PASS: original local six-pose overworld and 56x56 battle portrait, recorded sources')
