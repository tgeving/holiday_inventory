export class ApiClient {
  private readonly baseUrl: string;

  constructor(baseUrl: string = 'http://localhost:8001') {
    this.baseUrl = baseUrl.replace(/\/$/, '');
  }

  async getList<T>(endpoint: string): Promise<T[]> {
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'GET',
      headers: {
        Accept: 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`GET ${endpoint} failed with status ${response.status}`);
    }

    const payload: T[] | { items?: T[]; data?: T[] } = await response.json();

    // Handles both plain arrays `[...]` and wrapped objects `{ items: [...] }` or `{ data: [...] }`
    if (Array.isArray(payload)) {
      return payload;
    }
    if (Array.isArray(payload.items)) {
      return payload.items;
    }
    if (Array.isArray(payload.data)) {
      return payload.data;
    }

    return [];
  }

  // Example endpoint #1: Get All Items
  getAllItems(): Promise<import('./type').Item[]> {
    return this.getList('/items'); // Change to '/api/items' if your route has an /api prefix
  }
}