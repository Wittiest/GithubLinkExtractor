require 'yaml'

class Parser

  def initialize(agent)
    @agent = agent
    @links = {}
  end

  def store_links(append_url)
    get_md_links(append_url)
    add_links_from_md
    store_links_in_file
  end

  def get_md_links(append_url)
    nav_elements = get_nav_elements(append_url)
    nav_elements.each do |el|
      title = el["title"]
      link = el["href"]
      if link.include?("blob")
        if title[-3..-1] == ".md"
          links[link] = []
        end
      elsif link.include?("tree")
        dfs(link)
      end
    end
  end

  def store_links_in_file
    file_name = "links.yml"
    yaml_links = links.to_yaml
    if File.file?(filename)
      File.prepend_write(file_name, yaml_links)
    else
      File.write(file_name, yaml_links)
    end
  end

  def add_links_from_md
    links.each_key do |md_append_url|
      raw_url = create_raw_url(md_append_url)
      #identify links in page
      #shovel into array
      #shovel links into array in hash at key
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

  attr_reader :agent, :append_url, :links
end
