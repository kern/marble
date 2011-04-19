# marble [![StillMaintained Status](http://stillmaintained.com/CapnKernul/marble.png)](http://stillmaintained.com/CapnKernul/marble) [![Build Status](http://travis-ci.org/CapnKernul/marble.png)](http://travis-ci.org/CapnKernul/marble) #

Marble is a Ruby object builder. It makes generating complex Ruby objects, and
by extension JSON and YAML, much more readable.

## Installation ##

Marble works both with and without Rails. Installation is as simple as adding
this line to your `Gemfile`:

    gem 'marble'

If you'd like to use marble without bundler, you can also directly install the
gem:

    gem install marble

## Usage ##

First, require marble and create a builder.

    require 'marble'
    builder = Marble.new

This builder can build any Ruby object using the `#build` method. The yielded
value is the current builder:

    builder.build do |m|
      ['foo']
    end # => ['foo']

However, this isn't very useful. The `#array` and `#hash` methods are far more
interesting. They allow you to build complex arrays and hashes in a minimal
amount of lines:

    builder.array do |m|
      m.item 'foo'
    end # => ['foo']
    
    builder.hash do |m|
      m.foo 'bar'
    end # => { 'foo' => 'bar' }

The returned value can be converted to JSON and YAML, giving you a really
concise way of creating JSON and YAML templates for API's.

See the `Marble` documentation for more details.

## Usage with Rails ##

Marble provides a template handler for Rails. It supports object literal, JSON,
and YAML output formats. Name your view template with the extension `marble`.
The template creates a builder with the name `marble` for you to use. You can
rename it using the block parameter. For example, in order to generate a JSON
view:

    # view_name.json.marble
    marble.hash do |m|
      m.foo 'bar'
    end
    
    # Renders: {"foo": "bar"}

See the `Marble::RailsTemplateHandler` documentation for more details.

## Note on Patches/Pull Requests ##

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, but do not mess with the `Rakefile`. If you want to have your own version, that is fine but bump the version in a commit by itself in another branch so I can ignore it when I pull.
* Send me a pull request. Bonus points for git flow feature branches.

## Resources ##

* [GitHub Repository](https://github.com/CapnKernul/marble)
* [Documentation](http://rubydoc.info/github/CapnKernul/marble/master/frames)

## License ##

Marble is licensed under the MIT License. See `LICENSE` for details.