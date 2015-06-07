describe 'Page', :js do
  context 'when a user click its popular page link' do
    it 'shows popular pages of the site with modal dialog' do
      visit '/'
      expect(page).not_to have_css '#modal'
      first(:button, '人気ページを見る').click
      expect(page).to have_css '#modal'
    end
  end

  context 'it comes into window' do
    it 'loads comments' do
      visit '/'
      expect(page).to have_css '.comment-box'
      comment_box = all('.comment-box').last
      expect(comment_box).to have_css '.loading-box'
      page.evaluate_script('(function(){ window.scrollTo(0, document.body.scrollHeight)})()')
      expect(comment_box).to have_no_css '.loading-box'
      expect(comment_box).to have_css '.comments'
    end
  end
end
