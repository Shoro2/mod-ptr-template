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
-- WHY EVERY ALTER IS GUARDED. The database updater collects every update file
-- of the core and of every module into ONE set and orders it by file NAME
-- alone (`UpdateFetcher::PathCompare`, src/server/database/Updater/
-- UpdateFetcher.cpp:521-524; the module directories are added at :177-181).
-- '2' sorts before 's', so on a FRESH world database this file runs BEFORE the
-- module's own `structure.sql` - the nine tables do not exist yet, a bare ALTER
-- would fail with MySQL 1146, `DBUpdater<T>::ApplyFile` would throw and the
-- worldserver would refuse to start. The `information_schema` guard makes the
-- file a no-op in that case: `structure.sql` then creates both columns as INT
-- directly, so a fresh install needs nothing from this file. On an existing
-- database - the workbench, the production host - the tables are there and the
-- widening runs. Guarding rather than renaming keeps the file correct whatever
-- else lands in the update set later.
--
-- Idempotent: MODIFY COLUMN restates the definition, so re-applying this file
-- (which the updater does whenever its hash changes) is a no-op.
--
-- NOT part of this change: template rows FOR classes 12-32. `.template list`
-- keeps answering "no template info available" for a CoA class until those
-- rows are authored - the column can hold them now, that is all.

-- mod_ptrtemplate_achievements
SET @ddl := IF(
	(SELECT COUNT(*) FROM `information_schema`.`TABLES`
	 WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_ptrtemplate_achievements') > 0,
	'ALTER TABLE `mod_ptrtemplate_achievements`
		MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable races (1 << race-1; races reach 21)'',
		MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)''',
	'DO 0');
PREPARE `ptrtemplate_widen` FROM @ddl;
EXECUTE `ptrtemplate_widen`;
DEALLOCATE PREPARE `ptrtemplate_widen`;

-- mod_ptrtemplate_action
SET @ddl := IF(
	(SELECT COUNT(*) FROM `information_schema`.`TABLES`
	 WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_ptrtemplate_action') > 0,
	'ALTER TABLE `mod_ptrtemplate_action`
		MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable races (1 << race-1; races reach 21)'',
		MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)''',
	'DO 0');
PREPARE `ptrtemplate_widen` FROM @ddl;
EXECUTE `ptrtemplate_widen`;
DEALLOCATE PREPARE `ptrtemplate_widen`;

-- mod_ptrtemplate_inventory
SET @ddl := IF(
	(SELECT COUNT(*) FROM `information_schema`.`TABLES`
	 WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_ptrtemplate_inventory') > 0,
	'ALTER TABLE `mod_ptrtemplate_inventory`
		MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable races (1 << race-1; races reach 21)'',
		MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)''',
	'DO 0');
PREPARE `ptrtemplate_widen` FROM @ddl;
EXECUTE `ptrtemplate_widen`;
DEALLOCATE PREPARE `ptrtemplate_widen`;

-- mod_ptrtemplate_quests
SET @ddl := IF(
	(SELECT COUNT(*) FROM `information_schema`.`TABLES`
	 WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_ptrtemplate_quests') > 0,
	'ALTER TABLE `mod_ptrtemplate_quests`
		MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable races (1 << race-1; races reach 21)'',
		MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)''',
	'DO 0');
PREPARE `ptrtemplate_widen` FROM @ddl;
EXECUTE `ptrtemplate_widen`;
DEALLOCATE PREPARE `ptrtemplate_widen`;

-- mod_ptrtemplate_reputations
SET @ddl := IF(
	(SELECT COUNT(*) FROM `information_schema`.`TABLES`
	 WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_ptrtemplate_reputations') > 0,
	'ALTER TABLE `mod_ptrtemplate_reputations`
		MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable races (1 << race-1; races reach 21)'',
		MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)''',
	'DO 0');
PREPARE `ptrtemplate_widen` FROM @ddl;
EXECUTE `ptrtemplate_widen`;
DEALLOCATE PREPARE `ptrtemplate_widen`;

-- mod_ptrtemplate_skills
SET @ddl := IF(
	(SELECT COUNT(*) FROM `information_schema`.`TABLES`
	 WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_ptrtemplate_skills') > 0,
	'ALTER TABLE `mod_ptrtemplate_skills`
		MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable races (1 << race-1; races reach 21)'',
		MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)''',
	'DO 0');
PREPARE `ptrtemplate_widen` FROM @ddl;
EXECUTE `ptrtemplate_widen`;
DEALLOCATE PREPARE `ptrtemplate_widen`;

-- mod_ptrtemplate_spells
SET @ddl := IF(
	(SELECT COUNT(*) FROM `information_schema`.`TABLES`
	 WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_ptrtemplate_spells') > 0,
	'ALTER TABLE `mod_ptrtemplate_spells`
		MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable races (1 << race-1; races reach 21)'',
		MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)''',
	'DO 0');
PREPARE `ptrtemplate_widen` FROM @ddl;
EXECUTE `ptrtemplate_widen`;
DEALLOCATE PREPARE `ptrtemplate_widen`;

-- mod_ptrtemplate_talents
SET @ddl := IF(
	(SELECT COUNT(*) FROM `information_schema`.`TABLES`
	 WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_ptrtemplate_talents') > 0,
	'ALTER TABLE `mod_ptrtemplate_talents`
		MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable races (1 << race-1; races reach 21)'',
		MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)''',
	'DO 0');
PREPARE `ptrtemplate_widen` FROM @ddl;
EXECUTE `ptrtemplate_widen`;
DEALLOCATE PREPARE `ptrtemplate_widen`;

-- mod_ptrtemplate_glyphs
SET @ddl := IF(
	(SELECT COUNT(*) FROM `information_schema`.`TABLES`
	 WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'mod_ptrtemplate_glyphs') > 0,
	'ALTER TABLE `mod_ptrtemplate_glyphs`
		MODIFY COLUMN `RaceMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable races (1 << race-1; races reach 21)'',
		MODIFY COLUMN `ClassMask` INT UNSIGNED NOT NULL DEFAULT ''0'' COMMENT ''Bitmask for applicable classes (1 << class-1; class 32 is bit 31 = 2147483648)''',
	'DO 0');
PREPARE `ptrtemplate_widen` FROM @ddl;
EXECUTE `ptrtemplate_widen`;
DEALLOCATE PREPARE `ptrtemplate_widen`;
