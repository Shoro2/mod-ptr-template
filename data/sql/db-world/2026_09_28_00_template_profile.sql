-- The roll profile of a template for mod-paragon-itemgen (the operator, 2026-09-28: a template's
-- gear carries cursed Paragon stats): the role, the main stat and the spec its character plays.
-- The template writes it as the character's itemgen profile before the rolls; a template without
-- a row here (a generic one, like 3) rolls with the character's own profile.
-- Role: ParagonRole (0 tank, 1 damage, 2 healer). MainStat: ParagonStatIndex (1 strength,
-- 2 agility, 3 intellect, 4 spirit). SpecID: ParagonSpec (mod-paragon-itemgen src/ParagonItemGen.h).
CREATE TABLE IF NOT EXISTS `mod_ptrtemplate_profile` (
  `ID` TINYINT UNSIGNED NOT NULL,
  `ClassMask` INT UNSIGNED NOT NULL,
  `Role` TINYINT UNSIGNED NOT NULL,
  `MainStat` TINYINT UNSIGNED NOT NULL,
  `SpecID` TINYINT UNSIGNED NOT NULL,
  `Comment` TEXT,
  PRIMARY KEY (`ID`, `ClassMask`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- The Wrath P4 BiS templates 20-51 (template-wotlk-p4-bis.sql), one spec each.
DELETE FROM `mod_ptrtemplate_profile` WHERE `ID` BETWEEN 20 AND 51;
INSERT INTO `mod_ptrtemplate_profile` (`ID`, `ClassMask`, `Role`, `MainStat`, `SpecID`, `Comment`) VALUES
(20,   32, 1, 1,  7, 'Death Knight - Blood DPS'),
(21,   32, 1, 1,  8, 'Death Knight - Frost DPS'),
(22,   32, 1, 1,  9, 'Death Knight - Unholy DPS'),
(23,   32, 0, 1,  7, 'Death Knight - Blood Tank'),
(24, 1024, 1, 3, 16, 'Druid - Balance'),
(25, 1024, 1, 2, 19, 'Druid - Feral DPS (Cat)'),
(26, 1024, 0, 2, 18, 'Druid - Feral Tank (Bear)'),
(27, 1024, 2, 3, 17, 'Druid - Restoration'),
(28,    4, 1, 2, 13, 'Hunter - Beast Mastery'),
(29,    4, 1, 2, 14, 'Hunter - Marksmanship'),
(30,    4, 1, 2, 15, 'Hunter - Survival'),
(31,  128, 1, 3, 23, 'Mage - Arcane'),
(32,  128, 1, 3, 24, 'Mage - Fire'),
(33,  128, 1, 3, 25, 'Mage - Frost'),
(34,    2, 2, 3,  4, 'Paladin - Holy'),
(35,    2, 0, 1,  5, 'Paladin - Protection'),
(36,    2, 1, 1,  6, 'Paladin - Retribution'),
(37,   16, 2, 3, 29, 'Priest - Discipline'),
(38,   16, 2, 3, 30, 'Priest - Holy'),
(39,   16, 1, 3, 31, 'Priest - Shadow'),
(40,    8, 1, 2, 20, 'Rogue - Assassination'),
(41,    8, 1, 2, 21, 'Rogue - Combat'),
(42,    8, 1, 2, 22, 'Rogue - Subtlety'),
(43,   64, 1, 3, 10, 'Shaman - Elemental'),
(44,   64, 1, 2, 11, 'Shaman - Enhancement'),
(45,   64, 2, 3, 12, 'Shaman - Restoration'),
(46,  256, 1, 3, 26, 'Warlock - Affliction'),
(47,  256, 1, 3, 27, 'Warlock - Demonology'),
(48,  256, 1, 3, 28, 'Warlock - Destruction'),
(49,    1, 1, 1,  1, 'Warrior - Arms'),
(50,    1, 1, 1,  2, 'Warrior - Fury'),
(51,    1, 0, 1,  3, 'Warrior - Protection');
