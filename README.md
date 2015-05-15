# ブクマダイバー [![Build Status](https://travis-ci.org/webken/bukuma-diver.svg?branch=master)](https://travis-ci.org/webken/bukuma-diver)
面白いページを1匹見つけたら裏に100匹潜んでいると考えろ！良質なコンテンツを芋づる式に発掘していく装置、ブクマダイバー！

- [ウェブサイト](http://bukuma-diver.com)
- [Chrome 拡張機能](https://chrome.google.com/webstore/detail/%E3%83%96%E3%82%AF%E3%83%9E%E3%83%80%E3%82%A4%E3%83%90%E3%83%BC-google-chrome-%E6%8B%A1%E5%BC%B5/akkdidfaignjdpencliimleoglchphld?hl=ja)

## クレジット
ブクマダイバーは[はてな](http://www.hatena.ne.jp/)のサービスである[はてなブックマーク](http://b.hatena.ne.jp/)の情報を利用しています。また[CCライセンスで公開されているロゴ](http://hatenacorp.jp/press/resource)を利用しています。

## Development dependency
- rbenv
- nvm
- chromedriver

## Setup for develpment
```sh
$ git clone https://github.com/webken/bukuma-diver.git
$ cd bukuma-diver
$ npm install -g bower gulp coffee-script
$ npm install
$ bower install
$ bundle
```

## Develpment

開発時

```sh
# APIサーバ、ファイルの変更監視とビルド用のgulpを起動
foreman start
```

テスト時
```sh
bundle exec guard
```
