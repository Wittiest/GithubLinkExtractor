class Parser

  def initialize(agent)
    @agent = agent
  end

  def get_links(append_url)
    @links = [] #will store both
    get_md_links(append_url)
    add_links_from_md
    links
  end

  def get_md_links(append_url)
    nav_elements = get_nav_elements(append_url)
    nav_elements.each do |el|
      title = el["title"]
      link = el["href"]
      if link.include?("blob")
        links << [link] if title[-3..-1] == ".md"
      elsif link.include?("tree")
        dfs(link)
      end
    end
  end

  def add_links_from_md
    
  end
  # def bfs(append_url)
  #   queue = [append_url]
  #   until queue.empty?
  #     nav_elements = get_nav_elements(queue.shift)
  #     nav_elements.each do |el|
  #       title = el["title"]
  #       link = el["href"]
  #       if link.include?("blob")
  #         store_links_from_md(link) if title[-3..-1] == ".md"
  #       elsif link.include?("tree")
  #         queue.push(link)
  #       end
  #     end
  #   end
  # end

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
