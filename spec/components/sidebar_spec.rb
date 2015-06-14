describe 'Sidebar', js: true do
  describe 'search box' do
    before do
      visit '/'
    end

    context 'when input value is empty' do
      it 'does nothing' do
        find('#search-box .fa-search').click
        expect(page).to have_css '.main-title', text: 'ホットエントリー'
      end
    end

    context 'given a search query' do
      context 'when a user types enter' do
        it 'updates main content to search result component of 人気順' do
          within '#search-box' do
            input = find('input')
            input.set 'something'
            input.native.send_keys(:return)
          end
          expect(page).to have_css '.main-title', text: '「something」の検索結果'
          expect(page).to have_css '.header-state.active', text: '人気順'
        end
      end

      context 'when a user click the search button' do
        it 'updates main content to search result component of 人気順' do
          within '#search-box' do
            find('input').set 'something'
            find('.fa-search').click
          end
          expect(page).to have_css '.main-title', text: '「something」の検索結果'
          expect(page).to have_css '.header-state.active', text: '人気順'
        end
      end
    end
  end

  describe 'watch list' do
    before do
      visit '/pages/?q=something'
      within '#recommends' do
        all('.site')[0..2].each do |el|
          el.hover
          el.find('.fa-heart').click
        end
      end
      find('.main-header .fa-heart-o', match: :first).click
    end

    after do
      page.execute_script('localforage.clear()')
    end

    shared_examples_for 'watch list item' do
      context 'with mouse over' do
        it 'can be deleted' do
          skip 'fails only on TRAVIS' if ENV['TRAVIS']
          expect {
            favorite = find('#favorites .site', match: :first)
            favorite.hover
            favorite.find('.fa-close').click
          }.to change { find('#favorites .site', match: :first).text }
        end
      end

      context 'when a user drag and drop it' do
        it 'changes order and saves the order' do
          skip 'TODO'
        end
      end
    end

    describe 'domain item' do
      it_should_behave_like 'watch list item'

      context 'when a user click one' do
        it 'updates main content to domain component of 新着順' do
          skip 'fails only on TRAVIS' if ENV['TRAVIS']
          find('#favorites .site', match: :first).click
          expect(page).to have_css '.header-state.active', text: '新着順'
        end
      end
    end

    describe 'search result item' do
      it_should_behave_like 'watch list item'

      context 'when a user click one' do
        it 'updates main content to search result component of 新着順' do
          skip 'fails only on TRAVIS' if ENV['TRAVIS']
          all('#favorites .site').last.click
          expect(page).to have_css '.header-state.active', text: '新着順'
        end
      end
    end
  end

  shared_examples_for 'sidebar items' do |id|
    context 'when a user click one' do
      it 'updates main content to domain component of 新着順' do
        within id do
          find('.site', match: :first).click
        end
        expect(page).to have_css '.header-state.active', text: '新着順'
      end
    end
  end

  describe 'recommended sites' do
    before do
      visit '/'
    end

    it_should_behave_like 'sidebar items', '#recommends'

    it 'does not include the items which are in the user\'s watch list' do
      expect {
        li = find('#recommends .site', match: :first)
        li.hover
        li.find('.fa-heart').click
      }.to change { find('#recommends').text }
    end

    describe 'もっと見る button' do
      context 'when a user click it' do
        it 'adds more items' do
          within '#recommends' do
            expect {
              click_on 'もっと見る'
            }.to change { all('.site').count }
          end
        end
      end
    end
  end

  describe 'popular sites' do
    before do
      j = 0
      allow_any_instance_of(Sinatra::Application).to receive(:cache) do
        j += 10
        JSON.dump(20.times.map {|i| "test#{i+j}.example.com" })
      end
      visit '/'
    end

    it_should_behave_like 'sidebar items', '#popular-sites'

    describe 'もっと見る button' do
      context 'when a user click it' do
        it 'adds more items' do
          within '#popular-sites' do
            click_on 'もっと見る'
            Timeout.timeout(10 * Capybara.default_wait_time) do
              loop while all('.site').count == 20
            end
          end
        end
      end
    end
  end
end
