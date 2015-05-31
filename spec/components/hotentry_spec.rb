describe 'Hotentry', :js do
  context 'when one visits root path with category hash' do
    before do
      visit "/##{URI.encode_www_form_component '世の中'}"
    end

    it 'makes the category active' do
      expect(page).to have_css '.header-state.active', text: '世の中'
      expect(page.evaluate_script("(function(){ var y = document.getElementById('世の中').getBoundingClientRect().top; return y > 0 && y < window.innerHeight})()")).to eq true
    end
  end

  context 'without category hash' do
    before do
      visit '/'
    end

    it 'has title' do
      expect(page).to have_css '#title', text: 'ブクマダイバー'
    end

    it 'shows 10 pages of 総合 category' do
      expect(page).to have_css '#総合 + ul > li', count: 10
    end

    it 'shows 5 pages except 総合 category' do
      expect(page).to have_css '.hotentry:not(:first-child)'
      page.all(:css, '.hotentry:not(:first-child)').each do |el|
        expect(el).to have_css 'li', count: 5
      end
    end

    context 'when one clicks a link to see more of a category' do
      it 'shows more pages of the category' do
        expect {
          within '.hotentry:first-child' do
            click_on('もっと見る')
          end
        }.to change { all(:css, '.hotentry:first-child li').count }
      end
    end

    context 'when one clicks a page link of a category' do
      it 'shows more pages of the category' do
        expect {
          window_opened_by { first(:css, '.page-title > a').click }.close
        }.to change { all(:css, '.hotentry:first-child li').count }
      end
    end
  end
end
