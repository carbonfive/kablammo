class Strategy
  include MongoMapper::Document

  key :username, String, required: true
  key :github_url, String, required: true
  # local path where we've cloned this
  key :path, String, required: true

  def initialize(url, app_root)
    # git from github
    username = get_github_username(url)
    path = File.join( app_root, 'game_strategies', username )
    FileUtils.mkdir_p path
    `cd #{path} && git clone #{url}`
  end

  def get_github_username(url)
    url.match(/github\.com\/([^\/]*)/)[1].downcase
  end

end

