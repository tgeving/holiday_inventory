import os
import httpx
import requests


class Categories:
    def __init__(self):
        """Initializes the Categories with a base URL for the API.

        Args:
            base_url: The base URL of the API. If not provided, it will be read
                from the environment variable 'API_BASE_URL'.
        """
        self.base_url = os.getenv("API_BASE_URL", "http://127.0.0.1:8001")
        self.endpoint = f"{self.base_url}/categories/"
        self._status_code = None
        
    @property
    def status_code(self) -> int | None:
        """Returns the HTTP status code of the last API response."""
        return self._status_code

    def get_all_categories(
        self,
        search= None,
        sort_by= None,
        order= None,
        limit = 0,
        offset= 0
    ) -> httpx.Response:
        """Fetch holiday inventory categories with optional filtering, sorting, and pagination.

        Args:
            search: Partial keyword to match across category name
            sort_by: Column name to sort results by (e.g., "created_at", "item_name").
            order: Sort direction, either "asc" or "desc".
            limit: Maximum number of items to return per page.
            offset: Number of items to skip before returning results.

        Returns:
            An httpx.Response object containing the HTTP status code and JSON list of items.
        """
        raw_params = {}

        if search is not None:
            raw_params["search"] = search
        if sort_by is not None:
            raw_params["sort_by"] = sort_by
        if order is not None:
            raw_params["order"] = order
        if limit > 0: 
            raw_params["limit"] = int(limit)
        if offset > 0:
            raw_params["offset"] = int(offset)

        req = httpx.get(self.endpoint, params=raw_params, timeout=30.0)
        self._status_code = req.status_code
        if req.status_code == requests.codes.OK:
            return req.json() 
        return req
