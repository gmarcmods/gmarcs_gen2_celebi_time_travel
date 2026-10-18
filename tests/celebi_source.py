"""Workspace reference comparison: retain GSC follower pixels and six poses."""
import importlib.util
import json
from pathlib import Path
from PIL import Image
root=Path(__file__).resolve().parents[1]
workspace=root.parents[2]
spec=importlib.util.spec_from_file_location('sprites',workspace/'workspace/tools/sprites.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
p=module.Project(json.loads((root/'art/celebi/sprite.json').read_text()))
source=Image.open(workspace/'mods/gen1/overworld-spawn-mod/assets/enhanced_overworld/poke_followers/follower_251_normal.png').convert('RGBA')
shipped=Image.open(root/'assets/celebi.png').convert('RGBA')
remap={(238,246,238):(170,170,170,255),(115,189,16):(85,85,85,255),(0,0,0):(0,0,0,255)}
expected=[remap[pixel[:3]] if pixel[3]else(0,0,0,0) for pixel in source.get_flattened_data()]
assert list(shipped.get_flattened_data())==expected,'Celebi silhouette or frame layout changed from the GSC pack'
for i,name in enumerate(module.NATIVE_ORDER):
 assert p.image(name).tobytes()==shipped.crop((0,i*16,16,(i+1)*16)).tobytes(),'editable art and native export differ'
print('CELEBI SOURCE PASS: exact GSC follower shape, pose order and editable native source')
