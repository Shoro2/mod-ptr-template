# Todo

- (high) Host: ship the `.template apply` rules of 2026-10-09 (`5651edd`) with HOST11 (vault MIG-111).
- (medium) Templates for the CoA classes 12-32: masks fit since 2026-09-20, but no rows exist and
  `.template list` answers "no template info" (vault `12-server-todo.md` §2 row "Our modules' class limits
  for ids 12-32").
- (low) `data/sql/db-world/template-blizzlike.sql` still inserts templates 1, 2, 3 and 6 (2 and 3 enabled).
  The workbench holds only 3 and 20-51 because the old `structure.sql` once dropped the tables and the
  2026-07-16 rework restored only template 3 (`template-wotlk-fresh80.sql`); a fresh database would get
  1, 2 and 6 back. Decide whether FL wants them; if not, trim the file. The host's index is not verified.
- (low) `.github/workflows/core-build.yml` builds against stock AzerothCore without mod-paragon,
  mod-paragon-itemgen and mod-forgotten-talents, whose headers the kit includes since `04ce9e8`; it cannot
  pass (CI results not checked). Disable or adapt it.
