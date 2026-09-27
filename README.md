# PTR Character Templates

- AzerothCore build status as of the [latest commit](https://github.com/heyitsbench/mod-ptr-template/commit): [![core-build](https://github.com/heyitsbench/mod-ptr-template/actions/workflows/core-build.yml/badge.svg)](https://github.com/heyitsbench/mod-ptr-template/actions/workflows/core-build.yml)

This is a module for [AzerothCore](http://www.azerothcore.org/) that adds commands for creating characters from preset templates.

[Demonstration video](https://www.youtube.com/watch?v=VPczbaUCEvw) (35s)

## Important Notes

This module depends on the selection of certain template sets that have already been filled out. The sets included in this module are based on the following:

- Template characters as seen on the Classic Era, Season of Mastery, and Wrath Classic public test realms.
- Best-in-slot gear lists from Wowhead for the various phases of Classic's release.
- Premade characters used in [VMaNGOS](https://github.com/vmangos/core).

In the future, this may be expanded to include many more sets, and anyone willing is free to contribute to this module.

Check issues page for current progress on included templates.

## How to Install

For the most part, the [guide found here](https://www.azerothcore.org/wiki/installing-a-module) can be referred to. However, the SQL portion needs a bit of attention.

**This module does have certain SQL queries in automated directories.**

Queries required to use the module are automated, as well as any completed template sets. Automated template sets are enabled and available to apply by default.

Any incomplete template set queries will need to be run manually while in development. They are disabled and need to be enabled manually (by command or editing the index entry) to be available to apply.

### (Optional) Edit Module Configuration

You are also able to edit the [mod_ptr_template.conf](https://github.com/heyitsbench/mod-ptr-template/blob/master/conf/mod_ptr_template.conf.dist) to your liking. At the time of writing, you can pick and choose what parts of the template sets it should apply, whether it announces itself on login, the security level required to apply templates, and whether it can only be applied at the start level of a character.

## Usage

By default, any account can list and apply enabled templates using `.template list` and `.template apply [template index number]` respectively. Gamemaster or higher security will also have disabled templates listed with the list command. Administrators are the only ones that can apply a disabled template. Administrators and the console are also the only ones that can enable/disable templates through the `.template enable/disable [template index number]` command.

## Forgotten Land: the template kit (2026-09-28)

After talents, gear and bags a template now gives what a Forgotten Land character needs to play
right away (the operator's request; every step has its own switch in the conf):

| Step | Conf | What |
|---|---|---|
| talent ability ranks | `TemplateTalentRanks` | a talent that teaches an ability gives rank 1 only (Pyroblast, Devastate, Haunt, Holy Shock ...); the step learns its trainer ranks up to the character's level, never a further rank of the talent itself |
| Paragon floor | `TemplateParagon`, `TemplateParagon.MinLevel` (200) | mod-paragon `SetParagonLevelAtLeast`: the account's Paragon level at least 200, never lowered; runs before the gear |
| class kit | `TemplateClassKit`, `TemplateHunterPet.Entry` (26672) | a hunter's ammo (a matching arrow or bullet from the bags - a bag row is not equipped) and pet (a tamed wolf at the hunter's level, the core's `.pet create` path), a shaman's four totems (the bag cleanup deleted the ones the first login gave) |
| Paragon rolls | `TemplateParagonRolls` | mod-paragon-itemgen's Paragon enchantments on every worn item, **all cursed**, at the character's Paragon level; the template's profile in `mod_ptrtemplate_profile` (role, main stat, spec - templates 20-51) becomes the character's itemgen profile; a template without a row rolls with the character's own profile, or not at all |
| Remnants | `TemplateRemnants`, `TemplateRemnants.Pct` (75) | each of mod-forgotten-talents' five currencies topped up to 75 % of what its whole tree costs under the live conf (`Service::FullTreeCost`) |

The kit links against mod-paragon, mod-paragon-itemgen and mod-forgotten-talents (all FL modules
built with it).

## Creating Template Sets

For information on creating your own template sets (and submitting them here for others to use), please refer to the [wiki](https://github.com/heyitsbench/mod-ptr-template/wiki).

## How to Uninstall

To uninstall the module, you must remove the module from the `modules` directory of your AC source, rerun CMake steps depending on your OS, and recompile. You will also need to run the `uninstall.sql` on your world DB to remove vestigial entries and tables.

## Credits
- [acidmanifesto](https://github.com/acidmanifesto) for providing portions of the [skip-dk-starting-area module](https://github.com/azerothcore/mod-skip-dk-starting-area) as well as an example of storing SQL results into variables.
- [AnchyDev](https://github.com/AnchyDev) for pointing out some much needed info regarding item storage and TaskScheduler implementation.
- [Nyeriah](https://github.com/Nyeriah) for identifying a couple points of confusion to me, resulting in issues.
- [ratkosrb](https://github.com/ratkosrb) for creating the VMaNGOS premade character sets and allowing them to be adapted for this module.
