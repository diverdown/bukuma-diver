chrome.browserAction.onClicked.addListener (tab)->
  domain = tab.url.split('/')[2].replace(/^www\./, '')
  url = process.env.BUKUMA_DIVER_URL + "/domains/#{domain}?sort=count"
  chrome.tabs.create url: url, active: true
