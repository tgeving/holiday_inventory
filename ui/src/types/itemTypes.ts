export interface Item {
  item_id: number;
  item_name: string;
  manufacturer_id?: number | null;
  manufacturer_name?: string | null;
  collection_id?: number | null;
  collection_name?: string | null;
  category_id?: number | null;
  category_name?: string | null;
  bin_id?: number | null;
  created_at?: string;
}

export interface ApiListResponse<T> {
  items?: T[];
  data?: T[];
}
