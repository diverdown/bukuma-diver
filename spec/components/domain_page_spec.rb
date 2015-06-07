describe 'Domain Page', :js do
  describe 'header' do
    it 'shows the site name' do
      visit '/domains/example.com'
      expect(page).to have_content 'サイト名'
    end

    it 'shows total bookmarks counts' do
      visit '/domains/example.com'
      expect(page).to have_content "total#{FakeHatenaBookmark::TOTAL_BOOKMARK_COUNT}users"
    end

    describe 'favorite button' do
      it 'shows favorite state' do
        visit '/domains/example.com'
        button = find('#main .fa-heart-o')
        expect(button['class']).not_to match 'favorited'
        button.click
        expect(button['class']).to match 'favorited'
      end
    end

    describe 'indicator of order' do
      it 'shows current order' do
        visit '/domains/example.com'
        expect(page).to have_css '.header-state.active', text: '人気順'
        visit '/domains/example.com?sort=recent'
        expect(page).to have_css '.header-state.active', text: '新着順'
        visit '/domains/example.com?sort=eid'
        expect(page).to have_css '.header-state.active', text: 'すべて'
      end

      context 'when a user click one' do
        it 'updates main content with the specified order' do
          visit '/domains/example.com'
          click_link '新着順'
          expect(page).to have_css '.header-state.active', text: '新着順'
          click_link 'すべて'
          expect(page).to have_css '.header-state.active', text: 'すべて'
        end
      end
    end
  end
end
