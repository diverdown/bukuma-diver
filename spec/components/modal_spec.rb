describe 'Modal', :js do
  before do
    visit '/'
    find(:button, '人気ページを見る', match: :first).click
  end

  context 'when a user click overlay' do
    before do
      page.execute_script('document.getElementById("overlay").click()')
    end

    it 'becomes invisible' do
      expect(page).to have_no_css '#modal'
    end
  end

  context 'when a user type escape' do
    before do
      find('body').native.send_keys(:escape)
    end

    it 'becomes invisible' do
      expect(page).to have_no_css '#modal'
    end
  end

  describe 'header' do
    it 'shows the site name' do
      expect(page).to have_content 'サイト名'
    end

    it 'shows total bookmarks counts' do
      expect(page).to have_content "total#{FakeHatenaBookmark::TOTAL_BOOKMARK_COUNT}users"
    end
  end

  describe 'indicator of order' do
    it 'shows popular pages first' do
      expect(page).to have_css '#modal .header-state.active', text: '人気順'
    end

    context 'when a user click one' do
      it 'updates content with the specified order' do
        within '#modal' do
          click_link '新着順'
          expect(page).to have_css '.header-state.active', text: '新着順'
          expect(page).to have_css '#modal .card'
          click_link 'すべて'
          expect(page).to have_css '.header-state.active', text: 'すべて'
          expect(page).to have_css '#modal .card'
        end
      end
    end
  end
end
