require 'yaml'
require 'nokogiri'

class Parser

  def initialize(agent, filename="links.yml")
    @agent = agent
    @links = {}
    @filename = filename
    @count = 0
  end

  def store_links(append_url)
    get_md_links(append_url)
    add_links_from_md
    store_links_in_file
  end

  def incremental_storage
    puts "---Appending the links of 20 .md files to links.yml"
    store_links_in_file
    count = 0
  end

  def get_md_links(append_url)
    incremental_storage if count >= 20

    nav_elements = get_nav_elements(append_url)
    nav_elements.each do |el|
      title = el["title"]
      link = el["href"]
      if link.include?("blob")
        if title[-3..-1] == ".md"
          puts "Identified .md file at #{link}"
          links[link] = []
          self.count += 1
        end
      elsif link.include?("tree")
        get_md_links(link)
      end
    end
  end

  def store_links_in_file
    name = filename
    yaml_links = links.to_yaml
    if File.file?(name)
      File.prepend_write(name, yaml_links)
    else
      File.write(name, yaml_links)
    end
    self.links = {}
  end

  def find_anchors(node)
    anchors = []
    node.children.each do |child_node|
      anchors << child_node["href"] if child_node["href"] != nil
      child_anchors = find_anchors(child_node)
      anchors.concat(child_anchors)
    end
    anchors
  end

  def add_links_from_md
    links.each_key do |md_append_url|
      page = get_page(md_append_url)
      sub_page = page.css("article").select {|link| link['class'] == "markdown-body entry-content"}.first
      anchors = find_anchors(sub_page)
      links[md_append_url] << anchors
    end
  end

  def get_nav_elements(append_url)
    page = get_page(append_url)
    nav_items = extract_navigation_items(page)
    extract_nav_elements(nav_items)
  end

  def get_page(append_url)
    agent.get(Interface::BASE_URL + append_url)
  end

  def extract_navigation_items(page)
    page.xpath('//tr[contains(@class, "js-navigation-item")]')
  end

  def extract_nav_elements(nav_items)
    nav_elements = []
    nav_items.each do |item|
      content = item.elements.select {|el| el["class"] == "content"}.first
      if content != nil
        span = content.elements.select {|el| el["class"] == "css-truncate css-truncate-target"}.first
        nav_elements << span.elements.select {|el| el["class"] == "js-navigation-open"}.first
      end
    end
    nav_elements
  end
  private

  attr_reader :agent, :append_url, :filename
  attr_accessor :links, :count
end
