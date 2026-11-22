export interface Theme {
  theme_id: number;
  theme_name: string;
  theme_year: number;
  line_no: number;
  location_id?: number | null;
  location_name?: string | null;
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
  themes?: T[];
  data?: T[];
}
