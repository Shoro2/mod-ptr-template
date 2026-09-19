-- mod-ptr-template: widen the nine RaceMask/ClassMask pairs from SMALLINT to INT.
--
-- Why: the module compares its columns against Player::getClassMask(), which is
-- 1 << (class - 1) as a uint32. With the 21 Chapters-of-Azeroth classes (ids
-- 12-32) live, class 17 is already bit 16 = 65536 and class 32 is bit 31 =
-- 2147483648, so a SMALLINT UNSIGNED column (16 bits, max 65535) cannot hold a
-- row for any class from 17 upwards and `ClassMask & 65536` can never be true.
-- RaceMask has the same 16-bit ceiling and the race enum now reaches 21
-- (bit 20 = 524288), so both columns move together.
--
-- Effect on existing rows: none. Every stored value is <= 1024 (the ten stock
-- class bits) or <= 1023 (the ten stock race bits); widening an unsigned
-- integer column preserves every value exactly and changes no row. The nine
-- tables carry no index or foreign key on either column.
--
-- Idempotent: MODIFY COLUMN restates the definition, so re-applying this file
-- is a no-op. structure.sql now creates the columns as INT directly, for a
-- fresh install that never sees this file.
--
-- NOT part of this change: template rows FOR classes 12-32. `.template list`
-- keeps answering "no template info available" for a CoA class until those
-- rows are authored - the column can hold them now, that is all.

ALTER TABLE `mod_ptrtemplate_achievements`
	MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable races (1 << race-1; races reach 21)',
	MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)';

ALTER TABLE `mod_ptrtemplate_action`
	MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable races (1 << race-1; races reach 21)',
	MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)';

ALTER TABLE `mod_ptrtemplate_inventory`
	MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable races (1 << race-1; races reach 21)',
	MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)';

ALTER TABLE `mod_ptrtemplate_quests`
	MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable races (1 << race-1; races reach 21)',
	MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)';

ALTER TABLE `mod_ptrtemplate_reputations`
	MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable races (1 << race-1; races reach 21)',
	MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)';

ALTER TABLE `mod_ptrtemplate_skills`
	MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable races (1 << race-1; races reach 21)',
	MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)';

ALTER TABLE `mod_ptrtemplate_spells`
	MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable races (1 << race-1; races reach 21)',
	MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)';

ALTER TABLE `mod_ptrtemplate_talents`
	MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable races (1 << race-1; races reach 21)',
	MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)';

ALTER TABLE `mod_ptrtemplate_glyphs`
	MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable races (1 << race-1; races reach 21)',
	MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)';
