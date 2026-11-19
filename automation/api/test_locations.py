from automation.lib.locations import Locations
from requests import codes

class TestLocations:

    def test_locations_get_all(self):
        """Test the get_all_locations"""

        locations = Locations()
        req = locations.get_all_locations()
        assert locations.status_code == codes.OK
        assert len(req) == 7

    def test_locations_get_all_search(self):
        """Validate that when searching by a location name the correct one is returned."""

        locations = Locations()

        location_name = "Office"
        req = locations.get_all_locations(search=location_name)
        assert locations.status_code == codes.OK
        assert len(req) == 1
        cat_info = req[0]
        assert cat_info['location_name'] == location_name
    
    def test_locations_get_all_sort_by_created_at(self):
        """Sort by DESC and then ASC and validate the the locations are sorted properly."""

        locations = Locations()
        created_at = 'created_at'
        
        asc_ord = locations.get_all_locations(sort_by=created_at, limit=10)
        assert locations.status_code == codes.ok
        assert len(asc_ord) >=2 
        values_asc = [location[created_at] for location in asc_ord]

        desc_ord = locations.get_all_locations(sort_by=created_at, order='desc', limit=10)
        assert locations.status_code == codes.ok
        assert len(desc_ord) >=2
        values_desc = [bin[created_at] for bin in desc_ord]
    
        expected_asc = sorted(values_asc, key=lambda x: (x is None, x))
        assert values_asc == expected_asc, f"Ascending sort failed for column: {created_at}"

        expected_desc = sorted(values_desc, key=lambda x: (x is None, x), reverse=True)
        assert values_desc == expected_desc, f"Descending sort failed for column: {created_at}"

    def test_locations_get_all_locations_reverse_sort_on_term(self):
        """Verify that sorting ASC and then DESC returns inverse/mirrored results for a search query."""

        locations = Locations()
        
        location_name = "Kitchen - Main Cabinet"
        
        location_asc = locations.get_all_locations(search=location_name, sort_by="location_name", order="asc")
        assert locations.status_code == codes.ok

        location_desc = locations.get_all_locations(search=location_name, sort_by="location_name", order="desc")
        assert locations.status_code == codes.ok
        
        if len(location_asc) > 1:
            # The first item of the ASC list should roughly align with the last item of the DESC list
            assert location_asc[0]["location_name"] != location_desc[0]["location_name"], "ASC and DESC datasets are identical, sorting failed to change order."
            
            # Check reverse symmetry explicitly by IDs or item names
            asc_names = [i["location_name"] for i in location_asc]
            desc_names = [i["location_name"] for i in location_desc]
            
            assert desc_names == list(reversed(asc_names)), "Descending list is not the exact reverse of the Ascending list."
    
    def test_locations_get_all_pagination(self):
        """Validate that when setting an offset and a limit that records load properly on the correct page"""

        locations = Locations()

        # show 25 records max on the first page
        page1 = locations.get_all_locations(limit=2, offset=0)
        assert locations.status_code == codes.OK
        assert len(page1)==2
        page_1_ids = {locations["id"] for locations in page1}

        # show 25 records max on the second page
        page2 = locations.get_all_locations(limit=2, offset=2)
        assert locations.status_code == codes.OK
        assert len(page2)==2
        page_2_ids = {locations["id"] for locations in page2}
    
        intersection = page_1_ids.intersection(page_2_ids)
        assert len(intersection) == 0, f"Offset failed! Overlapping collection IDs found between page 1 and page 2: {intersection}"

        # 3. Direct position check: The first collection of page 2 should match the third collection of a larger limit fetch
        large_page = locations.get_all_locations(limit=2, offset=0)
        if len(large_page) >= 3:
            assert page2[0]["location_name"] == large_page[2]["location_name"], (
                "Offset mismatch: Location at offset 2 does not match the 3rd location of the non-offset dataset."
            )

    def test_locations_offset_out_of_bounds(self):
        """Verify that a high offset beyond total record count safely returns an empty list."""
        # Using an unreasonably high offset
        locations = Locations()
        empty_page = locations.get_all_locations(limit=10, offset=999999)
        
        assert isinstance(empty_page, list), "Expected a list return type."
        assert len(empty_page) == 0, "Expected an empty list when offset exceeds total records."
