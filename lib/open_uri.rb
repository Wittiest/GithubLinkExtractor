module OpenURI

  def self.private_repo?(url)
    return false if self.can_load_page(url)
    true
  end

  def self.can_load_page(url)
    begin
      open(url)
    rescue OpenURI::HTTPError => e
      return false
    end
    true
  end

end
