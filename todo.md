# Todo

- (high) Host: the race and CoA template fit of 2026-10-17 rides the Chronicle host window (vault MIG-164).
- (low) Own CoA templates: CoA classes borrow the stock templates of their armor type that CoA's item rules
  let them wear since 2026-10-17. Own CoA lists would be a generated per-role kit (operator to decide).
- (low) Template 3's race masks are the stock race/class pairs (druid spells only Night Elf and Tauren); a
  pair FL opened later (a Human druid, a Goblin mage) gets template 3's gear but not its class spells.
- (low) `data/sql/db-world/template-blizzlike.sql` still inserts templates 1, 2, 3 and 6 (2 and 3 enabled).
  The workbench holds only 3 and 20-51 because the old `structure.sql` once dropped the tables and the
  2026-07-16 rework restored only template 3 (`template-wotlk-fresh80.sql`); a fresh database would get
  1, 2 and 6 back. Decide whether FL wants them; if not, trim the file. The host's index is not verified.
- (low) `.github/workflows/core-build.yml` builds against stock AzerothCore without mod-paragon,
  mod-paragon-itemgen and mod-forgotten-talents, whose headers the kit includes since `04ce9e8`; it cannot
  pass (CI results not checked). Disable or adapt it.
