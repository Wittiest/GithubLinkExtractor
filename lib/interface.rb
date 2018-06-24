require 'io/console'
require 'nokogiri'
require 'mechanize'
require_relative 'parse'
require_relative 'mechanize'

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

  def get_links(agent, append_url)
    parser = Parser.new(agent)
    parser.get_links(append_url)
  end

  def run
    append_url = get_url
    p append_url
    username = get_username
    password = get_password
    agent = Mechanize.create_agent(username, password, LOGIN_URL)
    links = get_links(agent, append_url)
  end

end

interface = Interface.new
interface.run
