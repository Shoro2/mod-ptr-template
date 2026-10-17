# Functions

## Scripts

| Script | Type and hook | What |
|---|---|---|
| `createPTR` | `WorldScript`, `OnBeforeWorldInitialized()` | counts `mod_ptrtemplate_index` and logs `>> Loaded <n> templates in <ms> ms.`; then `TemplateFit::Load()` logs `>> Template armor types of the CoA classes: 12=leather ...` |
| `schedulediff` | `WorldScript`, `OnUpdate(uint32 diff)` | drives the global `TaskScheduler scheduler` that runs the apply steps |
| `createTemplate` | plain helper class, all methods static (was a hookless PlayerScript until 2026-10-17; its function-local statics registered in ScriptMgr and crashed the stop) | `HandleApply`, `CheckTemplateQualifier` and the `AddTemplate*` steps |
| `announce` | `PlayerScript`, `OnPlayerLogin(Player*)` | the module message (`AnnounceEnable`); on a first login (`AT_LOGIN_FIRST`) applies `LoginTemplateIndex` when it is not 0 |
| `ptr_template_commandscript` | `CommandScript` | the `.template` commands |

## Whose rows a character reads (`TemplateFit`, FL 2026-10-17)

Every masked query (the qualifier, the steps, the list) reads with `TemplateFit::RaceMask(player)` and
`TemplateFit::ClassMask(player, index)` instead of the raw masks:

| Helper | What |
|---|---|
| `RaceMask(Player*)` | the character's race bit plus its donor race's bit (`sRaceMgr->GetDonorRace`, worldserver.conf `Races.Donors`: Goblin 9 -> Orc 2, Worgen 12 -> Human 1). The template rows carry stock race masks only (the P4 rows 1791) |
| `IsBorrowed(Player*)` | the character is a CoA class (12-32, `IsAscensionClass`): it borrows another class's template |
| `Load()` | armor tier per class: the stock classes fixed (plate warrior / paladin / death knight, mail hunter / shaman, leather rogue / druid, cloth priest / mage / warlock); a CoA class the best armor proficiency spell it is created with in `playercreateinfo_spell_custom` (750 plate, 8737 mail, 9077 leather, 9078 cloth; none = cloth) |
| `Load()` (stat fit) | when no template of a CoA class's tier has its main stat (`ascension_custom_class.primary_stat` against `mod_ptrtemplate_profile.MainStat`), the class moves to the best lower tier that has one and borrows only templates with that stat (the operator, 2026-10-17: Reaper and Wildwalker, agility on plate, get the agility mail templates: hunter and Enhancement shaman). Spirit (Chronomancer) matches no template and keeps its tier unfiltered |
| `ArmorGroupMask(classId)` | the stock classes with that class's (stat-fitted) tier |
| `ClassMask(Player*, index)` | a stock class: its own mask. A CoA class: the one stock class of its armor group that the template's inventory rows are for; 0 (the template does not apply) when none or several (the generic template 3), or when the class is stat-filtered and the template's profile has another main stat |

A borrowed template applies level, taxi, homebind, achievements, quests, reputations, Paragon floor, gear,
bag items, Paragon rolls (the lender's profile row), Remnants, position and resources. Skipped: spells (8),
talents and glyphs (9, so no `resetTalents`), the hotbar (17). Skills (7): only skills the character
already has, plus secondary skills and professions. Gear (12): a paper-doll piece goes on only when
`CanUseItem(ItemTemplate*)` is OK and its skill is one the character holds (`CanWearBorrowedItem`); the
rest is left out with one chat line, because CoA keeps each class's proficiency set and the login would
mail such a piece away. `applyTemplate` tells the invoker first that the template is another class's.

Loader: `Addmod_ptr_templateScripts()` -> `Add_ptr_template()` + `AddSC_ptr_template_commandscript()`.

## Commands

| Command | Security (code / `command` row) | Handler |
|---|---|---|
| `.template apply [player] <index>` | `SEC_PLAYER` / 0, not from the console | `applyTemplate(ChatHandler*, Optional<PlayerIdentifier>, uint32 index)`: the named player, else the selected player, else the invoker. The target must be online ("Player not found!" otherwise), and another character than the invoker's own needs a GameMaster ("You have low security level for this.", FL 2026-10-09); then `CheckTemplateQualifier` with the invoker's account level and `HandleApply` |
| `.template list` | `SEC_PLAYER` / 0, console too | `listTemplate`: enabled templates from `EnableListSecurity`, disabled ones from `DisableListSecurity`, the status text from `StatusSecurityText`; with `ListFilterByClass` a player sees only templates whose inventory rows match `TemplateFit::ClassMask` (a CoA class: the templates of its armor group, FL 2026-10-17) |
| `.template enable <index>` / `disable <index>` | `SEC_ADMINISTRATOR` / 3, console too | `UPDATE mod_ptrtemplate_index SET Enable = 1 / 0` |

## Qualification (`CheckTemplateQualifier(Player*, uint32 index, uint8 enable, uint8 security)`)

In this order, each with its own `module_string` answer:
1. Security (`security` = the invoker's account level): below both `EnableApplySecurity` and `DisableApplySecurity` ->
   `INSUFFICIENT_SECURITY_LEVEL`.
2. A disabled template below `DisableApplySecurity` -> `TEMPLATE_DISABLED_LOCAL`.
3. No row for the index with the character's race and class bits (`TemplateFit`, see above) in any of the nine masked tables ->
   `MISSING_TEMPLATE_INFO` ("does not apply to you").
4. Not at the start level (heroic start level for a death knight) while `LevelEnable = false` ->
   `NOT_INITIAL_LEVEL`.
5. `TemplateEnable = false` -> `TEMPLATE_DISABLED_GLOBAL`.

## The apply steps (`HandleApply(Player*, uint32 index, uint32 delayMultiplier = 1)`)

One scheduled task: the first step after `25 ms x delayMultiplier` (5 at a first login), then one step every
50 ms; each step runs only when its conf key is true and saves the character (`SaveToDB`). `DeleteItems`
picks the cleanup method: delete (true) or mail the old items back (false).

| Step | Key | What |
|---:|---|---|
| 0 | `TemplateDK` | item cleanup (bags and / or worn, by the two gear keys); a death knight gets its starting-area quests rewarded (from mod-skip-dk-starting-area), their reward items deleted |
| 1 | `TemplateLevel` | `GiveLevel(index.Level)` |
| 2 | `TemplateTaximask` | the faction's taxi mask from the index |
| 3 | `TemplateHomebind` | the faction's homebind from the index |
| 4 | `TemplateAchievements` | `CompletedAchievement` per row |
| 5 | `TemplateQuests` | quests set complete (off by default) |
| 6 | `TemplateReputation` | standings; a higher value stays with `MaintainImprovedValues` |
| 7 | `TemplateSkills` | skill value and max; higher values stay with `MaintainImprovedValues` |
| 8 | `TemplateSpells` | learns missing spells, sends a cosmetic talent reset |
| 9 | `TemplateTalents` | `resetTalents(true)`, then `LearnTalent` for each row in talent-row order, then the glyphs (`SetGlyph` + the glyph's aura); template 3 has no talent rows, so it leaves the character without talents |
| 10 | `TemplateTalentRanks` | FL kit: trainer ranks up to the character's level of every ability a learned talent teaches, never a further talent rank (`Talent.dbc` `RankID`) |
| 11 | `TemplateParagon` | FL kit: `SetParagonLevelAtLeast(player, TemplateParagon.MinLevel)` (account-wide, never lowered) |
| 12 | `TemplateEquipGear` | removes worn items, equips the template's paper-doll items, equipped (and bank) bags and ammo with their enchants and gems; each item in the character's own faction's version (`player_factionchange_items`) |
| 13 | `TemplateBagGear` | bag contents (bag n = inventory slot `INVENTORY_SLOT_BAG_START + n - 1`, read from memory), item 8 = money, overflow mailed |
| 14 | `TemplateClassKit` | FL kit: missing proficiencies of worn gear (`CanUseItem(Item*, false)` -> `LearnDefaultSkill`), shaman totems 5175-5178, hunter ammo matching the ranged weapon and a tamed pet of `TemplateHunterPet.Entry` (must be tameable; `CreatePet`) |
| 15 | `TemplateParagonRolls` | FL kit: the `mod_ptrtemplate_profile` row becomes the itemgen profile (`ParagonItemGenSetProfile`), then `ParagonItemGenRollCursed` on every worn item |
| 16 | `TemplateRemnants` | FL kit: each Remnant topped up to `ceil(FullTreeCost()[tier] x Pct / 100)` |
| 17 | `TemplateHotbar` | clears the action bars, sets the template's buttons |
| 18 | `TemplateTeleport` | the faction's position from the index |
| 19 | `TemplateResources` | full health, full mana or energy; the task ends |

## Known traps

- Gear the template equips but the core refuses at the next login is mailed away (`_LoadInventory`): no
  proficiency, the other faction's item, a unique-equipped gem twice. The class kit, the faction twin and the
  generator's one-unique-gem rule (`d7a653b`) cover the known cases (vault `forgotten-land/14-ptr-bis-templates.md`).
- A test bot that already wears its template skips it in the runner, so it lacks kit steps added later;
  re-apply by hand (vault `testing/01-test-bots.md`).
- The passive pool of the cursed rolls stacks (one aura per item); the operator keeps that (2026-09-28).

## Config

Keys and defaults: [data_structure.md](data_structure.md).
