[![Build Status](https://travis-ci.org/dgsuarez/similatron.svg?branch=master)](https://travis-ci.org/dgsuarez/similatron)

# Similatron

The laziest way to test generated artifacts.

`Similatron` compares files. It can make image, text or pure binary
comparisons.

It's designed to be used in tests, so:

- If the files are different, it'll raise an exception
- If the expected file doesn't yet exist, it'll copy the expected one over (so
  you can build your tests post-hoc in one go)
- It can create html/json reports after running, so you'll be able to inspect
  differences in the actual files, and, when available, have access to
  a file with the differences as computed.

## Usage

One of the simplest ways to use it is the following:

```ruby

after :all do
  Similatron.complete
end


it "creates an image for an ugly face" do
  expected = "spec/assets/expected_face.jpg"
  actual = face_builder.ugly_face(:path => "tmp/ugly.jpg")

  Similatron.compare(expected: expected, actual: actual)
end

```

Depending on the files...

- If the actual exists and is equal to the expected, the spec will pass.
- If the expected face doesn't exist, `tmp/ugly.jpg` will be copied over, and
  the spec will not fail.
- Otherwise, the spec fails.

Whenever the images are not equal, an html report is generated so you can
check the reasons for the failure.

*NOTE* Some imagemagick versions don't allow PDF manipulation by default due to
security concerns. Until this can be fixed PDF comparison will be done in
binary mode

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'similatron'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install similatron

`Similatron` needs Imagemagick (to compare images), and a standard
implementation of `diff`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/dgsuarez/similatron.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
