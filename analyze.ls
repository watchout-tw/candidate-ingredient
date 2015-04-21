"use strict"

require! <[fs superagent cheerio async]>

data = fs.readFileSync "data.json" |> JSON.parse

augment = (i) ->
  story = data.stories[i]
  (done) ->
    story.issues = {}
    err, res <- superagent story.url .end
    return done(null, story <<< issues: {}) if err
    body = (cheerio.load res.text)("article")
    data.issues.forEach (n) ->
      if body.text!.indexOf(n) > -1
        story.issues ||= {}
        story.issues[n] ||= 0
        story.issues[n]++
    title = (cheerio.load res.text)("title")
    data.issues.forEach (n) ->
      if body.text!.indexOf(n) > -1
        story.issues ||= {}
        story.issues[n] ||= 0
        story.issues[n]++
    console.log story
    done null, story

jobs = [ augment(i) for i from 0 to data.stories.length - 1]

err, data.stories <- async.series jobs
data |> JSON.stringify |> fs.writeFileSync "data.json", _
