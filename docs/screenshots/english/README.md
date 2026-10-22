# English event screenshots

These numbered pixel captures document the complete Celebi event in native
English Silver, running in the modern `gen1recomp` engine. They are in-engine
screenshots, not HGSS reference images. Each image is 960×864 pixels. The
capture uses a seeded disposable test player named ETHAN, rival SILVER, a
prepared party and the GS Ball; it does not touch a user's save. Route 22 uses
a north-shifted publishing camera to fit the speakers in frame. No pixels were
composited.

The sequence follows the event from Oak and the GS Ball through Kurt's
workshop and street departure, the Ilex shrine and Celebi catch, time travel
and the Route 22 scene, then Tohjo Falls, Giovanni's battle and the return.
Later frames show the permanent room and radio before and after completion.
The numbered order groups these story beats for reading as a short visual
record; the final images include the story's ending scenes.

Selected frames: [Kurt approaches](07-kurt-approaches.png), [Kurt walks
away](09-kurt-walks-away.png), [Silver and Giovanni](17-silver-and-giovanni.png),
and [Giovanni battle](23-giovanni-battle.png).

Capture drivers: `tests/publication_live.lua`,
`tests/publication_extras_live.lua` and `tests/kurt_street_live.lua`. The complete English run passed: real native catch, healed team, automatic
time travel, Giovanni victory and return. The focused street run checked
adjacency, item delivery, visible movement and removal only at the gate.
The extras run checked both radio states and the time-travel effect.

`index.json` contains the captions and SHA256 hashes for all 29 frames.
