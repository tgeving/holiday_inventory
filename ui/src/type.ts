export interface Item {
  item_id: number;
  item_name: string;
  category_id?: number | null;
  bin_id?: number | null;
  location_id?: number | null;
  created_at?: string;
}

export interface ApiListResponse<T> {
  items?: T[];
  data?: T[];
}