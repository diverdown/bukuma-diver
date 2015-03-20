chrome.browserAction.onClicked.addListener (tab)->
  domain = tab.url.split('/')[2].replace(/^www\./, '')
  url = process.env.BUKUMA_DIVER_URL + "/domains/#{domain}?sort=count"
  chrome.tabs.create url: url, active: true

chrome.omnibox.onInputEntered.addListener (text, disposition)->
  chrome.tabs.update(url: process.env.BUKUMA_DIVER_URL + "/pages/?q=#{text}&sort=popular")
