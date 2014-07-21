require 'page_object_generator'

namespace :generate do

  desc 'generate a page object file given a working directory for pages, and login credentials. Defaults to no login'
  task page_object: :environment do
    print "enter the URL of the page \n"
    url = STDIN.gets.chomp
    puts

    print "enter working directory for pages or leave blank for root of project \n"
    dir = STDIN.gets.chomp
    dir = dir.empty? ? nil : dir
    puts

    print "enter username, leave blank if none \n"
    user = STDIN.gets.chomp
    user = user.empty? ? nil : user
    puts

    print "enter password for user, leave blank if no login required \n"
    password = STDIN.gets.chomp
    password = password.empty? ? nil : password
    puts
    PageObjectGenerator.create_module_scaffold(URI(url),{dir: dir, user: user, password: password} )

  end
end
