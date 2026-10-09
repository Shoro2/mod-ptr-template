# mod-ptr-template

Forgotten Land's copy of the AzerothCore module mod-ptr-template (upstream `azerothcore/mod-ptr-template`
by heyitsbench, imported 2026-07-13 at an older revision): `.template apply <index>` turns a character into
a preset one - level, gear with enchants and gems, talents, glyphs, spells, skills, reputations, position.
FL uses it as a test tool: 32 WotLK Phase-4 (ICC 25 heroic) BiS spec templates plus FL's template kit
(Paragon floor, cursed Paragon rolls, class kit, Remnants, trainer ranks), so a GM's test character or a test
bot is ready to play at once. On the host only GMs may apply templates. Full description: [README.md](README.md).

## Ids and tables

| What | Id / name |
|---|---|
| Templates | **3** "Wrath Classic Level 80" (generic, gear per class, no talents) · **20-51** "Wrath P4 BiS - <class> - <spec>", one per spec (DK 20-23, Druid 24-27, Hunter 28-30, Mage 31-33, Paladin 34-36, Priest 37-39, Rogue 40-42, Shaman 43-45, Warlock 46-48, Warrior 49-51). The workbench index holds exactly these (measured 2026-10-09) |
| World tables (upstream) | `mod_ptrtemplate_index`, `_achievements`, `_action`, `_inventory`, `_locale`, `_quests`, `_reputations`, `_skills`, `_spells`, `_talents`, `_glyphs` (`ID` TINYINT; `RaceMask` / `ClassMask` INT UNSIGNED since 2026-09-20 for races up to 21 and classes 12-32) |
| World table (FL) | `mod_ptrtemplate_profile`: role, main stat and spec per template 20-51 for the cursed Paragon rolls |
| Other world rows | `command` `template apply` / `list` (security 0), `template enable` / `disable` (3); `module_string` module `ptr-template` 0-19 (+ `module_string_locale`); `mailtemplate_dbc` 344, 403 |
| Commands | `.template apply [player] <index>`, `.template list`, `.template enable <index>`, `.template disable <index>` |
| C++ scripts | `createPTR`, `schedulediff` (WorldScripts), `createTemplate`, `announce` (PlayerScripts), `ptr_template_commandscript` |
| Kit links | mod-paragon (`SetParagonLevelAtLeast`, `GetParagonLevel`), mod-paragon-itemgen (`ParagonItemGenSetProfile`, `ParagonItemGenRollCursed`), mod-forgotten-talents (`Service::FullTreeCost`, Remnants 920105-920109); hunter pet creature 26672, shaman totems 5175-5178 |
| Config | `mod_ptr_template.conf` |
| Used by | mod-fl-testbots: `template=<index>` on a bot (vault `testing/01-test-bots.md`) |

## Status and progress

- Where it runs: workbench, built from `azerothcore-wotlk/modules/mod-ptr-template` (`main` `d7a653b`); boot
  of 2026-10-09 "Loaded 33 templates"; live conf: every kit step on, `EnableApplySecurity = 0` (any account).
  Host: P4 templates since MIG-001 (applied 2026-07-25); `d7a653b` since the joint window MIG-051
  (2026-10-03, carrying MIG-028 and MIG-042); MIG-096 (HOST10, 2026-10-09) added two missing conf keys. Host
  conf `EnableApplySecurity = 2` (operator 2026-10-03: GMs only), so players may list but not apply.
- Evidence: **T2** on the host 2026-10-03 (MIG-042: `.template apply` as a GM works, a player is refused);
  T1 2026-09-28 by the S10 reference raid's ten bots (vault `forgotten-land/14-ptr-bis-templates.md`).
- Done:
  - 32 P4 BiS spec templates with gems, enchants, 71-point talents, glyphs and Ashen Verdict reputation;
    generic template 3; class-filtered `.template list` (2026-07-16).
  - Race/class masks widened to INT for the CoA classes 12-32, guarded for a fresh database (2026-09-20).
  - FL template kit (2026-09-28): talent-ability trainer ranks, Paragon floor 200, hunter ammo and pet,
    shaman totems, missing gear proficiencies, all-cursed Paragon rolls, Remnants at 75 % of the tree's
    price, each faction's own version of faction-bound items, the bag step read from memory.
  - `.template apply` (2026-10-09): only an online target; another character than the invoker's own needs a
    GameMaster; the rights check uses the invoker's account; the apply task looks the character up on every
    step. Bot scenario `tests/ptr_template_apply_guard.tbs`.

## Next steps

1. Host: the `.template apply` target and rights rules of 2026-10-09 (`5651edd`, T1 on the workbench: bot run 575 of `tests/ptr_template_apply_guard.tbs`) reach the host with HOST11 (vault MIG-111).
2. Templates for the CoA classes 12-32: the masks fit them, but no rows exist (`.template list` answers
   "no template info"; vault `12-server-todo.md` §2 row "Our modules' class limits for ids 12-32").
3. Decide what a fresh database should get from `template-blizzlike.sql` (templates 1, 2, 6 that the
   workbench does not hold; todo, low).
4. The inherited upstream CI cannot build the kit's FL includes (todo, low).

Open points in full: [todo.md](todo.md).

## Working here

- Branch `claude/<topic>-<sessionId>`, merge into `main` and push (project rule: no pull requests).
  Repository `Shoro2/mod-ptr-template`; upstream changes are not pulled automatically.
- The module builds only beside mod-paragon, mod-paragon-itemgen and mod-forgotten-talents (static
  `modules` library; it includes their headers).
- `data/sql/db-world/template-wotlk-p4-bis.sql` is generated by the workspace kit
  `C:\wowstuff\ForgottenLand2.0\tools\ptr-p4bis` (`pipeline.py` from `specs_input.json`; read its
  `RESUME.md` first). Never hand-edit it; `verify_unchanged.py` proves untouched specs stay byte-identical.
- The DB updater orders all update files by file name, so a dated file runs before `structure.sql` on a
  fresh database: guard every ALTER on `information_schema` (as `2026_09_20_00_*` does).
- Tests: test bots with `template=<index>` (TBOT accounts only; a bot that already wears its template does
  not get newer kit steps - re-apply with `as gm .template apply <bot> <index>`); the client probe with
  CRTEST1-4 only. Build tree `C:\wowstuff\dcore_bin`; restart only with `scripts\worldserver_restart.ps1`
  under `tools\shared.lock` (vault `13-bug-report-playbook.md` §3).
- Host-relevant changes (code, SQL, conf) need a MIG entry in share-public
  `docs/World of Warcraft/forgotten-land/15-host-migration-log.md`.
- Vault (`share-public/docs/World of Warcraft/`): `forgotten-land/14-ptr-bis-templates.md`,
  `forgotten-land/15-host-migration-log.md` (MIG-028, MIG-042, MIG-051, MIG-096), `testing/01-test-bots.md`,
  `12-server-todo.md`.
- Doc set: INDEX.md, CLAUDE.md, data_structure.md, functions.md, log.md (newest first), todo.md.
