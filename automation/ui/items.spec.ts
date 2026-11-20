import { test, expect } from '@playwright/test';

const mockItems = [
  { id: 1, item_name: "Fezzwig's Ballroom", location_id: 2, bin_id: 5 },
  { id: 2, item_name: 'Garland Garland', location_id: 1, bin_id: 3 },
];

test.describe('Get All Items UI', () => {
  test('displays all items returned by the GET items endpoint', async ({ page }) => {
    await page.route('**/items', async (route) => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockItems),
      });
    });

    await page.goto('/');

    const rows = page.getByTestId('item-row');
    await expect(rows).toHaveCount(2);
    await expect(rows.first()).toContainText("Fezzwig's Ballroom");
    await expect(page.getByTestId('status-message')).toHaveText('Showing 2 item(s).');
  });

  test('filters items when typing in the search box', async ({ page }) => {
    await page.route('**/items', async (route) => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(mockItems),
      });
    });

    await page.goto('/');
    await page.getByTestId('item-search').fill('Fezzwig');

    const rows = page.getByTestId('item-row');
    await expect(rows).toHaveCount(1);
    await expect(rows).toContainText("Fezzwig's Ballroom");
  });

  test('shows an error message when the GET items request fails', async ({ page }) => {
    await page.route('**/items', async (route) => {
      await route.fulfill({ status: 500, body: 'Internal Server Error' });
    });

    await page.goto('/');

    await expect(page.getByTestId('status-message')).toContainText('Error loading items');
  });
});