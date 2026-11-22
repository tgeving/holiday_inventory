import { test, expect } from "@playwright/test";

const pages = [
  { name: "Items", path: "/index.html" },
  { name: "Themes", path: "/themes.html" },
];

for (const { name, path } of pages) {
  test.describe(`${name} table`, () => {
    test(`Does not render "undefined" in any table cell`, async ({ page }) => {
      await page.goto(path);

      const rows = page.locator("tbody tr");
      await expect(rows.first()).toBeVisible();

      const undefinedCells = page.locator("tbody td").filter({ hasText: /undefined/i });
      const count = await undefinedCells.count();
      const badTexts = await undefinedCells.allTextContents();

      expect(
        count,
        `Found ${count} table cell(s) on ${path} rendering "undefined": ${JSON.stringify(badTexts)}`
      ).toBe(0);
    });
  });
}
