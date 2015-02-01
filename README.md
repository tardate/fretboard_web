# Fretboard Web App
[![Build Status](https://travis-ci.org/tardate/fretboard_web.svg?branch=master)](https://travis-ci.org/tardate/fretboard_web)

This is a simple sinatra app that includes two components:

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


## Running Locally

A sinatra web app is included in this repo for the purpose of hosting at [fretboard.tardate.com](http://fretboard.tardate.com).

To run the app locally:

    $ bundle install
    $ ruby web_app.rb

The information web site will run by default at http://localhost:4567

The build status proxy will run by default at http://localhost:4567/status.csv

You can use `curl` to inspect the raw build status response like this, which will also dump the response to `status.trace`:

    curl -i -0 --raw --trace status.trace "http://localhost:4567/status.csv"


## Contributing

1. Fork it ( https://github.com/tardate/fretboard_web/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
