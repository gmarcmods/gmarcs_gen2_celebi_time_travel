# HGSS — broken radio during ordinary hidden-room visits

Verified against the English message data and script in `pret/pokeheartgold`:

- [Message bank 0131, D45R0102](https://github.com/pret/pokeheartgold/blob/master/files/msgdata/msg/msg_0131_D45R0102.json)
- [Hidden-room script](https://github.com/pret/pokeheartgold/blob/master/files/fielddata/script/scr_seq/scr_seq_0114_D45R0102.s)

| State | Message id | Original English text |
| --- | --- | --- |
| Before event completion | `msg_0131_D45R0102_00020` | `There is a radio that no longer works...` |
| After event completion | `msg_0131_D45R0102_00021` | `You cannot turn on the radio.` followed by a line break, then `Giovanni must have left it here...` |

The radio interaction `scr_seq_D45R0102_003` compares `VAR_UNK_40FE` with
4: values below 4 use message 20; values greater than or equal to 4 use
message 21. The victory path sets that variable to 4. These are HGSS
reference identifiers, not GSC event flags to copy into the mod.

Recreation: ordinary exploration of the permanent Tohjo Falls hidden room
uses these messages, selected by our saved event progress. During the
time-travel cutscene, the radio instead plays the scripted Rocket broadcast.
Author a GSC-style broken radio object with collision and an examine action.
The room remains accessible after completion without restarting the event.

Keep this verified English wording in the source catalog; localized versions
can provide corresponding translations through the mod's text integration.
