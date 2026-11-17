from automation.lib.items import Items
from requests import codes

class TestItems:

    def test_items_get_all_items(self):
        """Test the get_all_items"""

        items = Items()
        req = items.get_all_items()
        assert items.status_code == codes.OK
        assert len(req) == 156 

    def test_items_get_all_items_search(self):
        """Validate that when searching by collection name, category name or sku the correct items are returned."""

        items = Items()

        collection_name = "Heritage Village Collection"
        req = items.get_all_items(search=collection_name)
        assert items.status_code == codes.OK
        assert len(req)

        for item in req:
           assert item['item_id'] 
           assert item['manufacturer_id'] 
           assert item['category_id'] 
           assert item['collection_id'] 
           assert item['collection_name'] == collection_name

        category_name = "Trees"
        req1 = items.get_all_items(search=category_name)
        assert items.status_code == codes.OK

        for item in req1:
           assert item['item_id'] 
           assert item['manufacturer_id'] 
           assert item['category_id'] 
           assert item['category_name'] == category_name

        sku_name = 56.58723
        req2 = items.get_all_items(search=sku_name)
        assert items.status_code == codes.OK
        assert len(req2) == 1
        sku_info = req2[0]
        assert sku_info['sku'] == str(sku_name)
    
    def test_items_get_all_items_sort_by_created_at(self):
        """Sort by DESC and then ASC and validate the the items are sorted properly."""

        items = Items()
        created_at = 'created_at'
        
        asc_ord = items.get_all_items(sort_by=created_at, limit=10)
        assert items.status_code == codes.ok
        assert len(asc_ord) == 10
        values_asc = [item[created_at] for item in asc_ord]

        desc_ord = items.get_all_items(sort_by=created_at, order='desc', limit=10)
        assert items.status_code == codes.ok
        assert len(desc_ord) == 10
        values_desc = [item[created_at] for item in desc_ord]
    
        expected_asc = sorted(values_asc, key=lambda x: (x is None, x))
        assert values_asc == expected_asc, f"Ascending sort failed for column: {created_at}"

        expected_desc = sorted(values_desc, key=lambda x: (x is None, x), reverse=True)
        assert values_desc == expected_desc, f"Descending sort failed for column: {created_at}"


    def test_items_get_all_items_reverse_sort_on_term(self):
        """Verify that sorting ASC and then DESC returns inverse/mirrored results for a search query."""

        items = Items()
        
        search_term = "Heritage Village Collection"
        
        items_asc = items.get_all_items(search=search_term, sort_by="item_name", order="asc")
        assert items.status_code == codes.ok

        items_desc = items.get_all_items(search=search_term, sort_by="item_name", order="desc")
        assert items.status_code == codes.ok
        
        if len(items_asc) > 1:
            # The first item of the ASC list should roughly align with the last item of the DESC list
            assert items_asc[0]["item_id"] != items_desc[0]["item_id"], "ASC and DESC datasets are identical, sorting failed to change order."
            
            # Check reverse symmetry explicitly by IDs or item names
            asc_names = [i["item_name"] for i in items_asc]
            desc_names = [i["item_name"] for i in items_desc]
            
            assert desc_names == list(reversed(asc_names)), "Descending list is not the exact reverse of the Ascending list."
    
    def test_items_get_all_items_pagination(self):
        """Validate that when setting an offset and a limit that records load properly on the correct page"""

        items = Items()

        # show 25 records max on the first page
        page1 = items.get_all_items(limit=25, offset=0)
        assert items.status_code == codes.OK
        assert len(page1)==25
        page_1_ids = {item["item_id"] for item in page1}

        # show 25 records max on the second page
        page2 = items.get_all_items(limit=25, offset=25)
        assert items.status_code == codes.OK
        assert len(page2)==25
        page_2_ids = {item["item_id"] for item in page2}
    
        intersection = page_1_ids.intersection(page_2_ids)
        assert len(intersection) == 0, f"Offset failed! Overlapping item IDs found between page 1 and page 2: {intersection}"

        # 3. Direct position check: The first item of page 2 should match the third item of a larger limit fetch
        large_page = items.get_all_items(limit=25, offset=0)
        if len(large_page) >= 26:
            assert page2[0]["item_id"] == large_page[2]["item_id"], (
                "Offset mismatch: Item at offset 2 does not match the 3rd item of the non-offset dataset."
            )

    def test_offset_out_of_bounds(self):
        """Verify that a high offset beyond total record count safely returns an empty list."""
        # Using an unreasonably high offset
        items = Items()
        empty_page = items.get_all_items(limit=10, offset=999999)
        
        assert isinstance(empty_page, list), "Expected a list return type."
        assert len(empty_page) == 0, "Expected an empty list when offset exceeds total records."
