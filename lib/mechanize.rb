class Mechanize
  def self.create_agent(user, pass, login_url)
    agent = self.new
    agent.get(login_url) do |page|
      mypage = page.form_with(action: '/session') do |form|
        form['login'] = user
        form['password'] = pass
      end.submit
    end
    agent
  end
end
