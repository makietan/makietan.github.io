# Contributing

## セットアップ

ローカルでこのサイトを動かすときは、次を実行します。

- `brew install rbenv`
- `eval "$(rbenv init - zsh)" >> ~/.zshrc`
- `gem install bundler`
- `bundle install --path vendor/bundle`

## ローカル確認

- `rake jekyll:serve`

ブラウザで http://localhost:4000 を開いて確認します。
