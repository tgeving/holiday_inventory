from automation.lib.bins import Bins
from requests import codes

class TestBins:

    def test_bins_get_all(self):
        """Test the get_all_bins"""

        bins = Bins()
        req = bins.get_all_bins()
        assert bins.status_code == codes.OK
        assert len(req) == 27

    def test_bins_get_all_search(self):
        """Validate that when searching by a bin name the correct one is returned."""

        bins = Bins()

        bin_nu = 13
        #bin_nu = '13'
        req = bins.get_all_bins(search=bin_nu)
        assert bins.status_code == codes.OK
        assert len(req) == 1
        cat_info = req[0]
        assert cat_info['bin_no'] == bin_nu
    
    def test_bins_get_all_sort_by_created_at(self):
        """Sort by DESC and then ASC and validate the the bins are sorted properly."""

        bins = Bins()
        created_at = 'created_at'
        
        asc_ord = bins.get_all_bins(sort_by=created_at, limit=10)
        assert bins.status_code == codes.ok
        assert len(asc_ord) >=2 
        values_asc = [bin[created_at] for bin in asc_ord]

        desc_ord = bins.get_all_bins(sort_by=created_at, order='desc', limit=10)
        assert bins.status_code == codes.ok
        assert len(desc_ord) >=2
        values_desc = [bin[created_at] for bin in desc_ord]
    
        expected_asc = sorted(values_asc, key=lambda x: (x is None, x))
        assert values_asc == expected_asc, f"Ascending sort failed for column: {created_at}"

        expected_desc = sorted(values_desc, key=lambda x: (x is None, x), reverse=True)
        assert values_desc == expected_desc, f"Descending sort failed for column: {created_at}"


    def test_bins_get_all_collection_reverse_sort_on_term(self):
        """Verify that sorting ASC and then DESC returns inverse/mirrored results for a search query."""

        bins = Bins()
        
        bin_nu = 24
        
        bin_asc = bins.get_all_bins(search=bin_nu, sort_by="bin_no", order="asc")
        assert bins.status_code == codes.ok

        bin_desc = bins.get_all_bins(search=bin_nu, sort_by="bin_no", order="desc")
        assert bins.status_code == codes.ok
        
        if len(bin_asc) > 1:
            # The first item of the ASC list should roughly align with the last item of the DESC list
            assert bin_asc[0]["bin_nu"] != bin_desc[0]["bin_nu"], "ASC and DESC datasets are identical, sorting failed to change order."
            
            # Check reverse symmetry explicitly by IDs or item names
            asc_names = [i["bin_no"] for i in bin_asc]
            desc_names = [i["bin_no"] for i in bin_desc]
            
            assert desc_names == list(reversed(asc_names)), "Descending list is not the exact reverse of the Ascending list."
    
    def test_bins_get_all_pagination(self):
        """Validate that when setting an offset and a limit that records load properly on the correct page"""

        bins = Bins()

        # show 25 records max on the first page
        page1 = bins.get_all_bins(limit=2, offset=0)
        assert bins.status_code == codes.OK
        assert len(page1)==2
        page_1_ids = {bins["id"] for bins in page1}

        # show 25 records max on the second page
        page2 = bins.get_all_bins(limit=2, offset=2)
        assert bins.status_code == codes.OK
        assert len(page2)==2
        page_2_ids = {bins["id"] for bins in page2}
    
        intersection = page_1_ids.intersection(page_2_ids)
        assert len(intersection) == 0, f"Offset failed! Overlapping collection IDs found between page 1 and page 2: {intersection}"

        # 3. Direct position check: The first collection of page 2 should match the third collection of a larger limit fetch
        large_page = bins.get_all_bins(limit=2, offset=0)
        if len(large_page) >= 3:
            assert page2[0]["bin_no"] == large_page[2]["bin_no"], (
                "Offset mismatch: Collection at offset 2 does not match the 3rd collection of the non-offset dataset."
            )

    def test_bins_offset_out_of_bounds(self):
        """Verify that a high offset beyond total record count safely returns an empty list."""
        # Using an unreasonably high offset
        bins = Bins()
        empty_page = bins.get_all_bins(limit=10, offset=999999)
        
        assert isinstance(empty_page, list), "Expected a list return type."
        assert len(empty_page) == 0, "Expected an empty list when offset exceeds total records."
