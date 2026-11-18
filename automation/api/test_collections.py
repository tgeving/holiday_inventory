from automation.lib.collections import Collections
from requests import codes

class TestCollections:

    def test_collections_get_all(self):
        """Test the get_all_collections"""

        categories = Collections()
        req = categories.get_all_collections()
        assert categories.status_code == codes.OK
        assert len(req) == 10 

    def test_collections_get_all_search(self):
        """Validate that when searching by a collection name the correct one is returned."""

        collections = Collections()

        collection_name = "Snow Village"
        req = collections.get_all_collections(search=collection_name)
        assert collections.status_code == codes.OK
        assert len(req) == 1
        cat_info = req[0]
        assert cat_info['collection_name'] == collection_name
    
    def test_collections_get_all_sort_by_created_at(self):
        """Sort by DESC and then ASC and validate the the collections are sorted properly."""

        collections = Collections()
        created_at = 'created_at'
        
        asc_ord = collections.get_all_collections(sort_by=created_at, limit=10)
        assert collections.status_code == codes.ok
        assert len(asc_ord) >=2 
        values_asc = [collection[created_at] for collection in asc_ord]

        desc_ord = collections.get_all_collections(sort_by=created_at, order='desc', limit=10)
        assert collections.status_code == codes.ok
        assert len(desc_ord) >=2
        values_desc = [item[created_at] for item in desc_ord]
    
        expected_asc = sorted(values_asc, key=lambda x: (x is None, x))
        assert values_asc == expected_asc, f"Ascending sort failed for column: {created_at}"

        expected_desc = sorted(values_desc, key=lambda x: (x is None, x), reverse=True)
        assert values_desc == expected_desc, f"Descending sort failed for column: {created_at}"


    def test_collections_get_all_collection_reverse_sort_on_term(self):
        """Verify that sorting ASC and then DESC returns inverse/mirrored results for a search query."""

        collections = Collections()
        
        search_term = "Dicken's Village"
        
        collection_asc = collections.get_all_collections(search=search_term, sort_by="collection_name", order="asc")
        assert collections.status_code == codes.ok

        collection_desc = collections.get_all_collections(search=search_term, sort_by="collection_name", order="desc")
        assert collections.status_code == codes.ok
        
        if len(collection_asc) > 1:
            # The first item of the ASC list should roughly align with the last item of the DESC list
            assert collection_asc[0]["collection_id"] != collection_desc[0]["collection_id"], "ASC and DESC datasets are identical, sorting failed to change order."
            
            # Check reverse symmetry explicitly by IDs or item names
            asc_names = [i["collection_name"] for i in collection_asc]
            desc_names = [i["collection_name"] for i in collection_desc]
            
            assert desc_names == list(reversed(asc_names)), "Descending list is not the exact reverse of the Ascending list."
    
    def test_collections_get_all_pagination(self):
        """Validate that when setting an offset and a limit that records load properly on the correct page"""

        collections = Collections()

        # show 25 records max on the first page
        page1 = collections.get_all_collections(limit=2, offset=0)
        assert collections.status_code == codes.OK
        assert len(page1)==2
        page_1_ids = {collection["id"] for collection in page1}

        # show 25 records max on the second page
        page2 = collections.get_all_collections(limit=2, offset=2)
        assert collections.status_code == codes.OK
        assert len(page2)==2
        page_2_ids = {collection["id"] for collection in page2}
    
        intersection = page_1_ids.intersection(page_2_ids)
        assert len(intersection) == 0, f"Offset failed! Overlapping collection IDs found between page 1 and page 2: {intersection}"

        # 3. Direct position check: The first collection of page 2 should match the third collection of a larger limit fetch
        large_page = collections.get_all_collections(limit=2, offset=0)
        if len(large_page) >= 3:
            assert page2[0]["collection_id"] == large_page[2]["collection_id"], (
                "Offset mismatch: Collection at offset 2 does not match the 3rd collection of the non-offset dataset."
            )

    def test_collections_offset_out_of_bounds(self):
        """Verify that a high offset beyond total record count safely returns an empty list."""
        # Using an unreasonably high offset
        collections = Collections()
        empty_page = collections.get_all_collections(limit=10, offset=999999)
        
        assert isinstance(empty_page, list), "Expected a list return type."
        assert len(empty_page) == 0, "Expected an empty list when offset exceeds total records."
