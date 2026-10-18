"""Rebuild the maintained GSC follower source using free local tools.

The older authored sheet remains in Git history. This command no longer
regenerates that superseded drawing over the selected third-party GSC art.
"""
import importlib.util
import json
from pathlib import Path

root=Path(__file__).resolve().parents[1]
workspace=root.parents[2]
spec=importlib.util.spec_from_file_location('sprites',workspace/'workspace/tools/sprites.py')
sprites=importlib.util.module_from_spec(spec);spec.loader.exec_module(sprites)
project=sprites.Project(json.loads((root/'art/celebi/sprite.json').read_text()))
sheet=sprites.Image.new('RGBA',(16,96))
for i,name in enumerate(sprites.NATIVE_ORDER):sheet.paste(project.image(name),(0,i*16))
sheet.save(root/'assets/celebi.png')
