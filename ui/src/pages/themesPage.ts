import { ApiTheme } from '../api/apiThemes'
import { Theme } from '../types/themeTypes';

const api = new ApiTheme(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8001');

const searchInput = document.querySelector<HTMLInputElement>('[data-testid="themes-search"]');
const statusEl = document.querySelector<HTMLParagraphElement>('[data-testid="status-message"]');
const tbodyEl = document.querySelector<HTMLTableSectionElement>('[data-testid="themes-tbody"]');

let allThemes: Theme[] = [];

function renderItems(themes: Theme[]): void {
  if (!tbodyEl || !statusEl) return;

  tbodyEl.innerHTML = '';
  statusEl.classList.remove('error');

  if (themes.length === 0) {
    statusEl.textContent = 'No themes found.';
    return;
  }

  statusEl.textContent = `Showing ${themes.length} theme(s).`;

  for (const theme of themes) {
    const row = document.createElement('tr');
    row.dataset.testid = 'theme-row';

    const idCell = document.createElement('td');
    idCell.id = `theme_id_${theme.theme_id}`
    idCell.textContent = String(theme.theme_id)

    const manufacturerCell = document.createElement('td');
    manufacturerCell.id = `manufacturer_name${theme.manufacturer_name}`
    manufacturerCell.textContent = String(theme.manufacturer_name)

    const collectionCell = document.createElement('td');
    collectionCell.id = `collection_name${theme.collection_name}`
    collectionCell.textContent = String(theme.collection_name)

    const categoryCell = document.createElement('td');
    categoryCell.id = `category_name${theme.category_name}`
    categoryCell.textContent = String(theme.category_name)

    row.append(idCell)
    const tbody = document.querySelector('tbody')
    tbody?.appendChild(row)

    const yearCell = document.createElement('td');
    yearCell.id = `theme_year${theme.theme_year}`
    yearCell.textContent = String(theme.theme_year)

    const nameCell = document.createElement('td');
    nameCell.id = `theme_name${theme.theme_name}`
    nameCell.textContent = String(theme.theme_name)

    const binCell = document.createElement('td');
    binCell.textContent = theme.bin_id != null ? String(theme.bin_id) : '—';

    row.append(idCell, nameCell, yearCell, manufacturerCell, collectionCell, categoryCell, binCell);
    tbodyEl.appendChild(row);
  }
}

async function initThemesPage(): Promise<void> {
  try {
    allThemes = await api.getAllThemes();
    renderItems(allThemes);
  } catch (err) {
    if (statusEl) {
      statusEl.classList.add('error');
      statusEl.textContent =
        err instanceof Error ? `Error loading themes: ${err.message}` : 'Error loading themes.';
    }
  }
}

searchInput?.addEventListener('input', () => {
  const query = searchInput.value.trim().toLowerCase();
  const filtered = query
    ? allThemes.filter((theme) => theme.theme_name.toLowerCase().includes(query))
    : allThemes;
  renderItems(filtered);
});

void initThemesPage();
