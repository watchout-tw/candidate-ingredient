"use strict"

require! <[fs superagent cheerio async]>

data = fs.readFileSync "data.json" |> JSON.parse

augment = (i) ->
  story = data.stories[i]
  (done) ->
    story.issues = {}
    err, res <- superagent story.url .end
    return done(null, story <<< issues: {}) if err
    body = cheerio.load res.text
    data.issues.forEach (n) ->
      if body("article").text!.search(n) > -1
        story.issues ||= {}
        story.issues[n] ||= 1
    data.issues.forEach (n) ->
      if body("title").text!.search(n) > -1
        story.issues ||= {}
        story.issues[n] ||= 1
    console.log story
    done null, story

jobs = [ augment(i) for i from 0 to data.stories.length - 1]

err, data.stories <- async.series jobs
data |> JSON.stringify |> fs.writeFileSync "data.json", _
