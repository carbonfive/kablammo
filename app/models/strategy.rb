class Strategy

  REPO_REGEX = /git@github\.com:([^\/]*)\/(.*)\.git/
  include MongoMapper::Document

  cattr_accessor :strategies_location

  key :username, String, required: true
  key :github_url, String, required: true, unique: true
  validates_format_of :github_url, :with => REPO_REGEX, message: 'Your repository url needs to be the ssh url.  e.g. git@github.com:my_username/myrepo.git'

  # local path where we've cloned this
  key :path, String, required: true

  before_save :clone_repo

  def initialize(url = nil)
    if url
      self.url = url
    end
    self
  end

  def url= url
    username = get_github_username(url)
    if username
      path = File.join( @@strategies_location, username )
      FileUtils.mkdir_p path

      self.username = username
      self.github_url = url
      self.path = File.join path, get_github_repo_name(url)
    end
  end

  def self.find_or_create_by_url(url)
    s = where(github_url: url).first
    s ||= Strategy.create(url)
  end

  def github_url_valid?
    matches = github_url.to_s.match(REPO_REGEX)
    puts "Validating url #{github_url} #{matches}"
    !!(matches && matches[1])
  end

  def clone_repo
    # may want some error protection around this system command
    begin
      Git.clone(github_url,path)
    rescue Git::GitExecuteError => ex
      puts "GIT ERROR: ", ex
      self.errors.add :github_url, "Unable to clone url.  Check your Url and permissions"
      false
    end
  end

  private
  def get_github_repo_name(url)
    matches = url.match(REPO_REGEX)
    if matches && matches[2]
      matches[2]
    else
      nil
    end
  end

  def get_github_username(url)
    matches = url.match(REPO_REGEX)
    if matches && matches[1]
      matches[1].downcase
    else
      nil
    end
  end

end

