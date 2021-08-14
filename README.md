[![CircleCI](https://circleci.com/gh/sivagollapalli/snomed_query/tree/master.svg?style=svg)](https://circleci.com/gh/sivagollapalli/snomed_query/tree/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/4874e46f608eed9c666a/maintainability)](https://codeclimate.com/github/sivagollapalli/snomed_query/maintainability)

# SnomedQuery

A set of utility functions to query the Snomed terminology server. Currently it is tested against https://github.com/IHTSDO/snowstorm server only. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snomed_query'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install snomed_query

## Usage

	SnomedQuery::ValueSet.descendants_of(46635009) # Returns a value set which are decendents of Diabetes mellitus Type 1

Currently supported methods are `descendants_or_self_of` , `child_of`, `child_or_self_of`, `ancestors_of`, `ancestors_or_self_of`, `parent_of`, `parent_or_self_of`
    
	query = "<281666001|family history of disorder|:246090004|associated finding|=22298006|myocardial infarction|"
	SnomedQuery::ValueSet.raw_query(query) # When you want to query with complex ECL

#
    SnomedQuery::CodeSystem.lookup(840539006) # Returns concept details based on identifier
    SnomedQuery::CodeSystem.synonyms(840539006) # Returns synonyms for a given concept
    

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/snomed_query. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/snomed_query/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SnomedQuery project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/snomed_query/blob/master/CODE_OF_CONDUCT.md).
