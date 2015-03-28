describe 'Hotentry', js: true do
  it 'should have title' do
    visit '/'
    expect(page).to have_css '#title', text: 'ブクマダイバー'
  end
end
