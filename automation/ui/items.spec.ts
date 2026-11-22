import { test, expect, type Page } from '@playwright/test';


test.describe('Holiday Inventory table', () => {
  test('Does not render "undefined" in any table cell', async ({ page }) => {
    await page.goto('http://localhost:5173');
    await page.locator('tbody tr').first().waitFor({ state: 'visible' });

    const cellTexts = await page.locator('tbody td').allTextContents();
    expect(cellTexts.length).toBeGreaterThan(0);

    const invalidCells = cellTexts
      .map((text) => text.trim().toLowerCase()) // clean up data one by one
      .filter((text) => text.includes('undefined')); // keep 'undefined', if any, remove the rest
    expect(invalidCells,
       `Expected no table cells to contain "undefined", but found: ${JSON.stringify(invalidCells)}`)
       .toEqual([]);
  });
});
