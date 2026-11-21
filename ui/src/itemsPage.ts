import { ApiClient } from './apiClient';
import { Item } from './type';

const api = new ApiClient(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8001');

const searchInput = document.querySelector<HTMLInputElement>('[data-testid="item-search"]');
const statusEl = document.querySelector<HTMLParagraphElement>('[data-testid="status-message"]');
const tbodyEl = document.querySelector<HTMLTableSectionElement>('[data-testid="items-tbody"]');

let allItems: Item[] = [];

function renderItems(items: Item[]): void {
  if (!tbodyEl || !statusEl) return;

  tbodyEl.innerHTML = '';
  statusEl.classList.remove('error');

  if (items.length === 0) {
    statusEl.textContent = 'No items found.';
    return;
  }

  statusEl.textContent = `Showing ${items.length} item(s).`;

  for (const item of items) {
    const row = document.createElement('tr');
    row.dataset.testid = 'item-row';

    const idCell = document.createElement('td');
    idCell.textContent = String(item.item_id)

    const nameCell = document.createElement('td');
    nameCell.textContent = item.item_name;

    const locationCell = document.createElement('td');
    locationCell.textContent = item.location_id != null ? String(item.location_id) : '—';

    const binCell = document.createElement('td');
    binCell.textContent = item.bin_id != null ? String(item.bin_id) : '—';

    row.append(idCell, nameCell, locationCell, binCell);
    tbodyEl.appendChild(row);
  }
}

async function initItemsPage(): Promise<void> {
  try {
    allItems = await api.getAllItems();
    renderItems(allItems);
  } catch (err) {
    if (statusEl) {
      statusEl.classList.add('error');
      statusEl.textContent =
        err instanceof Error ? `Error loading items: ${err.message}` : 'Error loading items.';
    }
  }
}

searchInput?.addEventListener('input', () => {
  const query = searchInput.value.trim().toLowerCase();
  const filtered = query
    ? allItems.filter((item) => item.item_name.toLowerCase().includes(query))
    : allItems;
  renderItems(filtered);
});

void initItemsPage();
