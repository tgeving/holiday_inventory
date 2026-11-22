from automation.lib.themes import Themes 
from requests import codes

class TestThemes:

    def test_themes_get_all(self):
        """Test the get_all_themes"""

        themes = Themes()
        req = themes.get_all_themes()
        assert themes.status_code == codes.OK
        assert len(req) >= 1

    def test_themes_get_all_search(self):
        """Validate that when searching by a theme name only records that match the theme appear"""

        themes = Themes()

        theme_name = "North Pole"
        req = themes.get_all_themes(search=theme_name)
        assert themes.status_code == codes.OK
        assert len(req) == 1
        theme_info = req[0]
        assert theme_info['theme_name'] == theme_name
    
    def test_themes_get_all_sort_by_created_at(self):
        """Sort by DESC and then ASC and validate the the themes are sorted properly."""

        themes = Themes() 
        created_at = 'created_at'
        
        asc_ord = themes.get_all_themes(sort_by=created_at, limit=10)
        assert themes.status_code == codes.ok
        assert len(asc_ord) >=2 
        values_asc = [theme[created_at] for theme in asc_ord]

        desc_ord = themes.get_all_themes(sort_by=created_at, order='desc', limit=10)
        assert themes.status_code == codes.ok
        assert len(desc_ord) >=2
        values_desc = [theme[created_at] for theme in desc_ord]
    
        expected_asc = sorted(values_asc, key=lambda x: (x is None, x))
        assert values_asc == expected_asc, f"Ascending sort failed for column: {created_at}"

        expected_desc = sorted(values_desc, key=lambda x: (x is None, x), reverse=True)
        assert values_desc == expected_desc, f"Descending sort failed for column: {created_at}"

    def test_themes_get_all_pagination(self):
        """Validate that when setting an offset and a limit that records load properly on the correct page"""

        themes = Themes()

        # show 25 records max on the first page
        page1 = themes.get_all_themes(limit=2, offset=0)
        assert themes.status_code == codes.OK
        assert len(page1)==2
        page_1_ids = {themes["theme_id"] for themes in page1}

        # show 25 records max on the second page
        page2 = themes.get_all_themes(limit=2, offset=2)
        assert themes.status_code == codes.OK
        assert len(page2)==2
        page_2_ids = {themes["theme_id"] for themes in page2}
    
        intersection = page_1_ids.intersection(page_2_ids)
        assert len(intersection) == 0, f"Offset failed! Overlapping collection IDs found between page 1 and page 2: {intersection}"

        # 3. Direct position check: The first collection of page 2 should match the third collection of a larger limit fetch
        large_page = themes.get_all_themes(limit=2, offset=0)
        if len(large_page) >= 3:
            assert page2[0]["theme_names"] == large_page[2]["theme_names"], (
                "Offset mismatch: Theme at offset 2 does not match the 3rd theme of the non-offset dataset."
            )

    def test_themes_offset_out_of_bounds(self):
        """Verify that a high offset beyond total record count safely returns an empty list."""
        # Using an unreasonably high offset
        themes = Themes()
        empty_page = themes.get_all_themes(limit=10, offset=999999)
        
        assert isinstance(empty_page, list), "Expected a list return type."
        assert len(empty_page) == 0, "Expected an empty list when offset exceeds total records."
