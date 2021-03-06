require 'io/console'
require 'mechanize'
require 'open-uri'

require_relative 'parse'
require_relative 'mechanize'
require_relative 'open_uri'
require_relative 'file'

class Interface
  LOGIN_URL = "https://github.com/login"
  BASE_URL = "https://github.com"

  def get_url
    puts "Enter a link in the following format (#{BASE_URL}/user/repo_name):"
    print "Link:"
    link = gets.chomp
    raise ArgumentError.new("Link does not include github URL") unless link.include?(BASE_URL)
    link.slice!(BASE_URL)
    link
  end

  def get_username
    print "Enter username:"
    gets.chomp
  end

  def get_password
    print "Enter password:"
    pass = STDIN.noecho(&:gets).chomp
    print "\n"
    pass
  end

  def store_links(append_url, agent)
    parser = Parser.new(agent)
    parser.store_links(append_url)
  end

  def finish_message(append_url)
    puts "All links from #{append_url} are now stored in links.yml!"
  end

  def run
    append_url = get_url
    unless OpenURI.private_repo?(BASE_URL + append_url)
      agent = Mechanize.new
    else
      username = get_username
      password = get_password
      agent = Mechanize.create_agent(username, password, LOGIN_URL)
    end
    store_links(append_url, agent)
    finish_message(append_url)
  end

end

interface = Interface.new
interface.run
