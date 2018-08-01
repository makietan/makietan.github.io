---
layout: post
title:  "Hubot notifies github project card changes"
categories: [tech]
date: "2018-04-23"
---

## Setup

### Generate Hubot with Slack adapter

```
npm init
```

```
npm i -D yo generator-hubot
```

```
yo hubot --adapter=slack
```

## Environments

You'll need the following.

- HUBOT_GITHUB_SECRET
- HUBOT_SLACK_TOKEN
- GITHUB_AUTHORIZATION
- HUBOT_HEROKU_KEEPALIVE_URL

### Github Webhook

#### Payload URL

```
#{Heroku Base URL}/github/webhook
```

#### Content type

```
application/json
```

#### Secret

Random string.

You need same `HUBOT_GITHUB_SECRET`.

#### Trigger

- Projects
- Project cards
- Project columns

### Github Personal Access Token

### Slack apps

### Generate main.js

```js

```
