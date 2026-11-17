from automation.lib.category import Categories
from requests import codes

class TestCategories:

    def test_categories_get_all_categories(self):
        """Test the get_all_categories"""

        categories = Categories()
        req = categories.get_all_categories()
        assert categories.status_code == codes.OK
        assert len(req) == 4

    def test_categories_get_all_categories_search(self):
        """Validate that when searching by category name the correct one is returned."""

        categories = Categories()

        category_name = "House"
        req = categories.get_all_categories(search=category_name)
        assert categories.status_code == codes.OK
        assert len(req) == 1
        cat_info = req[0]
        assert cat_info['category_name'] == category_name
    
    def test_categories_get_all_categories_sort_by_created_at(self):
        """Sort by DESC and then ASC and validate the the categories are sorted properly."""

        categories = Categories()
        created_at = 'created_at'
        
        asc_ord = categories.get_all_categories(sort_by=created_at, limit=10)
        assert categories.status_code == codes.ok
        assert len(asc_ord) >=2 
        values_asc = [item[created_at] for item in asc_ord]

        desc_ord = categories.get_all_categories(sort_by=created_at, order='desc', limit=10)
        assert categories.status_code == codes.ok
        assert len(desc_ord) >=2
        values_desc = [item[created_at] for item in desc_ord]
    
        expected_asc = sorted(values_asc, key=lambda x: (x is None, x))
        assert values_asc == expected_asc, f"Ascending sort failed for column: {created_at}"

        expected_desc = sorted(values_desc, key=lambda x: (x is None, x), reverse=True)
        assert values_desc == expected_desc, f"Descending sort failed for column: {created_at}"


    def test_categories_get_all_categories_reverse_sort_on_term(self):
        """Verify that sorting ASC and then DESC returns inverse/mirrored results for a search query."""

        categories = Categories()
        
        search_term = "Accessories"
        
        categories_asc = categories.get_all_categories(search=search_term, sort_by="category_name", order="asc")
        assert categories.status_code == codes.ok

        categories_desc = categories.get_all_categories(search=search_term, sort_by="category_name", order="desc")
        assert categories.status_code == codes.ok
        
        if len(categories_asc) > 1:
            # The first item of the ASC list should roughly align with the last item of the DESC list
            assert categories_asc[0]["category_id"] != categories_desc[0]["item_id"], "ASC and DESC datasets are identical, sorting failed to change order."
            
            # Check reverse symmetry explicitly by IDs or item names
            asc_names = [i["category_name"] for i in categories_asc]
            desc_names = [i["category_name"] for i in categories_desc]
            
            assert desc_names == list(reversed(asc_names)), "Descending list is not the exact reverse of the Ascending list."
    
    def test_categories_get_all_categories_pagination(self):
        """Validate that when setting an offset and a limit that records load properly on the correct page"""

        categories = Categories()

        # show 25 records max on the first page
        page1 = categories.get_all_categories(limit=2, offset=0)
        assert categories.status_code == codes.OK
        assert len(page1)==2
        page_1_ids = {category["id"] for category in page1}

        # show 25 records max on the second page
        page2 = categories.get_all_categories(limit=2, offset=2)
        assert categories.status_code == codes.OK
        assert len(page2)==2
        page_2_ids = {category["id"] for category in page2}
    
        intersection = page_1_ids.intersection(page_2_ids)
        assert len(intersection) == 0, f"Offset failed! Overlapping category IDs found between page 1 and page 2: {intersection}"

        # 3. Direct position check: The first item of page 2 should match the third item of a larger limit fetch
        large_page = categories.get_all_categories(limit=2, offset=0)
        if len(large_page) >= 3:
            assert page2[0]["category_id"] == large_page[2]["category_id"], (
                "Offset mismatch: Category at offset 2 does not match the 3rd category of the non-offset dataset."
            )

    def test_offset_out_of_bounds(self):
        """Verify that a high offset beyond total record count safely returns an empty list."""
        # Using an unreasonably high offset
        categories = Categories()
        empty_page = categories.get_all_categories(limit=10, offset=999999)
        
        assert isinstance(empty_page, list), "Expected a list return type."
        assert len(empty_page) == 0, "Expected an empty list when offset exceeds total records."
