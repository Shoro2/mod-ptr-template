# Data structure

| Path | What |
|---|---|
| `README.md` | upstream description and usage, plus the FL template kit section |
| `conf/mod_ptr_template.conf.dist` | every key below |
| `src/ptr_template_loader.h` | includes (core, mod-paragon, mod-paragon-itemgen, mod-forgotten-talents), the global `TaskScheduler scheduler`, enums (check codes, `module_string` ids, mail ids, item cleanup, `APPLY_DELAY` 25 / `APPLY_RATE` 50 ms), `SHAMAN_TOTEMS`, `Addmod_ptr_templateScripts()` |
| `src/ptr_template.cpp` | the scripts, the apply steps, the kit, the commands |
| `data/sql/db-world/structure.sql` | the eleven upstream tables (CREATE IF NOT EXISTS, no DROP since 2026-07-16) |
| `data/sql/db-world/2026_09_20_00_classmask_int_for_coa_classes.sql` | widens `RaceMask` / `ClassMask` to INT UNSIGNED on nine tables, each ALTER guarded on `information_schema` |
| `data/sql/db-world/2026_09_28_00_template_profile.sql` | FL: `mod_ptrtemplate_profile` + its 32 rows (templates 20-51) |
| `data/sql/db-world/command.sql` | the four `command` rows |
| `data/sql/db-world/string.sql` | `module_string` / `module_string_locale` (module `ptr-template`), `mailtemplate_dbc` 344 and 403 |
| `data/sql/db-world/template-wotlk-p4-bis.sql` | **generated** (workspace kit `tools\ptr-p4bis`): templates 20-51 |
| `data/sql/db-world/template-wotlk-fresh80.sql` | template 3, extracted from the blizzlike file |
| `data/sql/db-world/template-blizzlike.sql` | upstream's templates 1, 2, 3 and 6 (Season of Mastery 60, Wrath Classic 70 / 80, Classic Era PvP 60) |
| `data/sql/uninstall.sql` | manual: drops the eleven upstream tables, deletes the `command` rows, `acore_string` 40000-40020 (an older upstream layout; the `module_string` rows stay) and `mailtemplate_dbc` 344 / 403; `mod_ptrtemplate_profile` is not in it |
| `data/sql/blizzlike/`, `data/sql/wowhead/`, `data/sql/world-optional/` | upstream source sets and optional NPC / vendor SQL; outside the updater's path, applied by hand only |
| `.github/workflows/core-build.yml` | upstream's CI (AzerothCore reusable module build) |
| `icon.png`, `LICENSE`, `.editorconfig`, `.git_commit_template.txt` | upstream files |

## Tables (world database)

| Table | Key / columns |
|---|---|
| `mod_ptrtemplate_index` | `ID` (TINYINT, PK), level, Alliance / Horde position and homebind, taxi masks, `Enable`, `Comment` |
| `mod_ptrtemplate_inventory` | `ID`, `RaceMask`, `ClassMask`, `BagID`, `SlotID`, `ItemID`, `Quantity`, `Enchant0-6` |
| `mod_ptrtemplate_spells` / `_talents` | `ID`, masks, `SpellID` (talents: the final-rank talent spell) |
| `mod_ptrtemplate_glyphs` | `ID`, masks, `Slot` 0-5, `GlyphID` (GlyphProperties) |
| `mod_ptrtemplate_skills` | `ID`, masks, `SkillID`, `Value`, `Max` |
| `mod_ptrtemplate_reputations` | `ID`, masks, `FactionID`, `Standing` |
| `mod_ptrtemplate_achievements` / `_quests` | `ID`, masks, `AchievementID` / `QuestID` |
| `mod_ptrtemplate_action` | `ID`, masks, `Button`, `Action`, `Type` |
| `mod_ptrtemplate_locale` | `ID` (PK), template names in eight locales |
| `mod_ptrtemplate_profile` (FL) | `ID` + `ClassMask` (PK), `Role` (0 tank, 1 damage, 2 healer), `MainStat` (1 str, 2 agi, 3 int, 4 spi), `SpecID` (mod-paragon-itemgen `ParagonSpec`) |

A template applies to a character when any of the nine masked tables has a row for its `ID` whose
`RaceMask` and `ClassMask` match (`1 << (race - 1)`, `1 << (class - 1)`).

## Config keys (`mod_ptr_template.conf`)

| Key | Default | Meaning |
|---|---|---|
| `AnnounceEnable` | true | login message that the module runs |
| `TemplateEnable` | true | templates can be applied at all |
| `LevelEnable` | true | any level; false = only at the start level |
| `TemplateAchievements`, `TemplateBagGear`, `TemplateDK`, `TemplateEquipGear`, `TemplateHomebind`, `TemplateHotbar`, `TemplateLevel`, `TemplateReputation`, `TemplateResources`, `TemplateSkills`, `TemplateSpells`, `TemplateTalents`, `TemplateTaximask`, `TemplateTeleport` | true | one switch per apply step |
| `TemplateQuests` | false | quest step |
| `TemplateTalentRanks` | true | FL kit: trainer ranks of talent abilities |
| `TemplateParagon`, `TemplateParagon.MinLevel` | true, 200 | FL kit: Paragon floor (never lowered) |
| `TemplateClassKit`, `TemplateHunterPet.Entry` | true, 26672 | FL kit: proficiencies, hunter ammo and pet, shaman totems |
| `TemplateParagonRolls` | true | FL kit: all-cursed Paragon rolls on worn gear |
| `TemplateRemnants`, `TemplateRemnants.Pct` | true, 75 | FL kit: Remnants topped up to Pct % of the tree's price |
| `DeleteItems` | true | old items are deleted (false: mailed back) |
| `LoginTemplateIndex` | 0 | template applied at a character's first login; 0 = none |
| `MaintainImprovedValues` | true | keep a character's higher skill / reputation values |
| `EnableApplySecurity` / `DisableApplySecurity` | 0 / 3 | minimum security to apply enabled / disabled templates |
| `EnableListSecurity` / `DisableListSecurity` | 0 / 2 | minimum security to list them |
| `StatusSecurityText` | 2 | minimum security to see Enabled / Disabled in the list |
| `ListFilterByClass` | true | players list only their class's templates |

Deployed (2026-10-09): the workbench conf has every default, `EnableApplySecurity = 0`; the host conf (nightly
backup copy) has `EnableApplySecurity = 2`.
