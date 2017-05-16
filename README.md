# Fretboard Web App
[![Build Status](https://travis-ci.org/tardate/fretboard_web.svg?branch=master)](https://travis-ci.org/tardate/fretboard_web)

This is a simple html and sinatra app that includes two components:

* an informational web site hosted at [fretboard.tardate.com](http://fretboard.tardate.com).
* a demonstration build status proxy, used to transform actual build status into a form easily consumed by the associated Arduino project.

## About "The Fretboard"

The Fretboard is a simple Arduino project that displays continuous integration server build status
for up to 24 projects, using an addressable LED array for build status visualisation.

Arduino source and build details are available in the
[LittleArduinoProjects](https://github.com/tardate/LittleArduinoProjects/tree/master/FretBoard)
git repository.


## Installation for Development

To hack on the web front-end, you need a recent `npm` installed, then run:

    $ npm install

Use grunt to just-in-time compile coffeescript sources as you work:

    $ grunt watch

To hack on the sinatra web app, make sure you have a valid ruby runtime, then bundle:

    $ bundle install

Run tests:

    $ bundle exec rake

Guard is included to for watching code and running specs as you go:

    $ bundle exec guard


## CI Server Integration

Can be used with two CI servers: CruiseControl (XML response), and Circle CI (JSON response)

### CruiseControl

Set `type="xml"` e.g.

```
export FB_CI_SERVER_URL="https://your-ci-server.com/XmlStatusReport.aspx"
export FB_CI_SERVER_TYPE=xml
```

### Circle CI

Set `type="circleci"` e.g.

```
export FB_CI_SERVER_URL="https://circleci.com/api/v1.1/projects?circle-token=:token"
export FB_CI_SERVER_TYPE=circleci
```

See [Circle CI API reference](https://circleci.com/docs/api/v1-reference/)


## Running Locally

A sinatra web app is included in this repo for the purpose of simple hosting at providers like [heroku](http://heroku.com).

To run the app locally:

    $ bundle install
    $ ruby web_app.rb

The information web site will run by default at http://localhost:4567

The build status proxy will run by default at http://localhost:4567/status.csv

You can use `curl` to inspect the raw build status response like this, which will also dump the response to `status.trace`:

    curl -i -0 --raw --trace status.trace "http://localhost:4567/status.csv"


## Hosting

I'm using GitHub Pages to host [fretboard.tardate.com](http://fretboard.tardate.com) directly from the GitHub repository.

How does that work? GitHub Pages basically serves whatever you commit to the repo.
For static HTML sites, that means simply adding an `index.html` to the root of the repo.

GitHub now allows you to select the branch from which GitHub Pages are built.
I've chosen to serve directly from the master branch.

To host on a custom URL, just two steps:

* in DNS, configure a CNAME to point to <username>.github.io
* add a CNAME file to the repo root with the matching CNAME in DNS (GitHub does this for you automatically if you add the custom url in the web interface)


## Contributing

1. Fork it ( https://github.com/tardate/fretboard_web/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
