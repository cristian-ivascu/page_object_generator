# PageObjectGenerator

This gem is meant to speed up production of automation tests. 
It creates page objects by crawling pages and getting all links, tables, table columns, select lists, buttons, text fields, etc. in the body of the page.

## Installation

Add this line to your application's Gemfile:

    gem 'page_object_generator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install page_object_generator

## Usage

To run the gem use `rake page_object:generate`
It will prompt for a url, please put the full url in, `i.e. http://example.com/whatever/path`
It will prompt for a working directory to store the pages, usually `pages` or `spec/pages` will do. 
Else it will save to project root. It will also prompt for login credentials. If the site to crawl doesn't require login, leave these fields blank.

DISCLAIMERS: (things to fix in future) 
This generator will not account for existing pages and will overwrite them if used on a page you've worked on. 
The generator will create full file paths. i.e. if url is `http://example.com/whatever/path/to/site`, it will create folder structure and files to fall into `your_project/whatever/path/to/site.rb` 
It will only get elements which have either an id, a class or a name. Other elements will not be registered.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/page_object_generator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
