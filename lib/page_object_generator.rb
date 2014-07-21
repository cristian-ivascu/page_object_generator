require 'page_object_generator/version'
require 'uri'
require 'nokogiri'
require 'mechanize'

module PageObjectGenerator

  require 'page_object_generator/railtie' if defined?(Rails)

  def self.create_module_scaffold(page_url, options={} )

    dir = options[:dir] unless options[:dir].nil?
    user = options[:user] unless options[:user].nil?
    password = options[:password] unless options[:password].nil?

    set_working_path(dir) unless dir.nil?

    initialize(page_url, user, password)
    create_page_path_and_file(page_url)

    content = File.open(@page_object, 'w+')

    create_module_structure(content)
    generate_link_list(content)
    generate_select_lists(content)
    generate_text_field_list(content)
    generate_button_list(content)
    generate_table_list(content)
    close_module_formatting(content)
  end

  def self.set_working_path(dir)
    Dir.mkdir(dir) unless Dir.exist?(dir)
    Dir.chdir(dir)
  end

  def self.initialize(page_url, user, password)
    agent = Mechanize.new()
    agent.get(page_url)
    form = agent.page.forms.first unless user.nil? || password.nil?
    form.login(user) unless user.nil?
    form.password(password) unless password.nil?
    form.submit unless user.nil? || password.nil?
    @doc = agent.page.parser.css('div#content_wrapper')
  end

  def self.create_page_path_and_file(page_url)
    path = page_url.path
    path[0] = ''
    @modules_list = path.split(/\//)
    nested_dirs = @modules_list.dup
    nested_dirs.pop

    nested_dirs.each do |dir|
      Dir.mkdir(dir) unless Dir.exist?(dir)
      Dir.chdir(dir)
    end

    (@modules_list.length > 1) ? file_name = @modules_list.last + '.rb' : file_name = 'index.rb'

    @page_object = File.new(file_name, 'w+')

  end

  def self.create_module_structure(content_page)
    @modules_list = @modules_list.map { |mod| mod.capitalize }
    @modules_list = @modules_list.map { |mod| mod.insert(0, 'module ') }

    content_page.write('module Page' + "\n")
    1.upto(@modules_list.length) do |item_number|
      tab_string = "\t" * item_number
      content_page.write(tab_string + @modules_list[item_number-1] + "\n")
    end

    @indent_string = "\t" * (@modules_list.length+1)
    content_page.write(@indent_string + 'class PageObject < Page::AbstractPage' + "\n")
  end

  def self.generate_link_list(content_page)

    if !@doc.css('a[href]').nil?
      files = %w[png jpeg jpg gif svg txt js css zip gz]

      uris = @doc.css('a[href]').map{ |a| a['href'] }
      uris.reject!{ |uri| files.any?{ |ext| uri.end_with?(".#{ext}") } }
      uris = uris.map { |single_uri| single_uri.to_s }.uniq

      content_page.write("\n")

      uris.each do |single_uri|
        content_page.write(@indent_string +  "link :name_this_link, href: '" + single_uri + "'" + "\n" )
      end

      content_page.write("\n")
    end
  end

  def self.generate_select_lists(content_page)

    if !@doc.css('select').nil?
      select_fields = @doc.css('select')
      select_fields.each do |field|
        if field.has_attribute?('id')
          content_page.write(@indent_string + "select_list :name_this_list, id: '" + field.attr('id') + "'" + "\n")
        elsif field.has_attribute?('class')
          content_page.write(@indent_string + "select_list :name_this_list, class: '" + field.attr('class') + "'" + "\n")
        elsif field.has_attribute?('name')
          content_page.write(@indent_string + "select_list :name_this_list, name: '" + field.attr('name') + "'" + "\n")
        end
      end

      content_page.write("\n")
    end
  end

  def self.generate_text_field_list(content_page)

    if !@doc.css('input').nil?
      inputs = @doc.css('input')
      inputs.each do |input|
        if input.attr('type') == 'text'
          if input.has_attribute?('id')
            content_page.write(@indent_string + "text_field :name_this_field, id: '" + input.attr('id') + "'" + "\n")
          elsif input.has_attribute?('class')
            content_page.write(@indent_string + "text_field :name_this_field, class: '" + input.attr('class') + "'" + "\n")
          elsif input.has_attribute?('name')
            content_page.write(@indent_string + "text_field :name_this_field, name: '" + input.attr('name') + "'" + "\n")
          end
        end
      end

      content_page.write("\n")
    end
  end

  def self.generate_button_list(content_page)

    if !@doc.css('input').nil?
      inputs = @doc.css('input')
      inputs.each do |input|
        if input.attr('type') == 'submit'
          if input.has_attribute?('id')
            content_page.write(@indent_string + "button :name_this_button, id: '" + input.attr('id') + "'" + "\n")
          elsif input.has_attribute?('class')
            content_page.write(@indent_string + "button :name_this_button, class: '" + input.attr('class') + "'" + "\n")
            content_page.write("\n")
          elsif input.has_attribute?('name')
            content_page.write(@indent_string + "button :name_this_button, name: '" + input.attr('name') + "'" + "\n")
            content_page.write("\n")
          end
        end
      end
      content_page.write("\n")
    end
  end

  def self.generate_table_list(content_page)

    if !@doc.css('table').nil?
      tables = @doc.css('table')
      !tables.css('thead').nil? ? head_row = tables.css('thead').css('tr') : head_row = tables.css('tr')
      head_columns = head_row.css('th')
      head_columns = head_columns.map {|column| column.children.text }
      head_columns.map!{|a| a.downcase.gsub(' ', '_')}
      table_body = tables.css('tbody')

      tables.each do |each_table|
        xpath_for_table = Nokogiri::CSS.xpath_for each_table.name

        if each_table.has_attribute?('class')
          xpath_for_table = '"' + xpath_for_table.join + "[@class='" + each_table.attr('class') + "'/]" + '"'
          content_page.write(@indent_string + 'table :name_this_table, xpath: ' + xpath_for_table + "\n")
        elsif  each_table.has_attribute?('id')
          xpath_for_table = '"' + xpath_for_table.join + "[@id='" + each_table.attr('id') + "'/]" + '"'
          content_page.write(@indent_string + 'table :name_this_table, xpath: ' + xpath_for_table + "\n")
        elsif each_table.has_attribute?('name')
          xpath_for_table = '"' + xpath_for_table.join + "[@name='" + each_table.attr('name') + "'/]" + '"'
          content_page.write(@indent_string + 'table :name_this_table, xpath: ' + xpath_for_table + "\n")
        end
      end
      content_page.write("\n")
      generate_columns_arrays(content_page, head_columns)
    end
  end

  def self.generate_columns_arrays(content_page, head_columns)
    content_page.write(@indent_string + 'COLUMNS = {' + "\n")
    1.upto(head_columns.length) do |n|
      content_page.write(@indent_string + "\t" + head_columns[n-1] + ': ' + n.to_s + ", \n")
    end
    content_page.write(@indent_string + '}' + "\n"*2)
  end

  def self.close_module_formatting(content_page)
    (@modules_list.length+1).downto(0) do |x|
      tab_string = "\t" * x
      content_page.write(tab_string + 'end' + "\n")
    end
  end
end
