require 'page_object_generator'
require 'rails'

module PageObjectGenerator
  class Railtie < Rails::Railtie
    railtie_name :page_object_generator

    rake_tasks do
      load "tasks/page_object_generator.rake"
    end
  end
end
