require File.expand_path('../../lib/kablammo/git', __FILE__)
require 'digest/md5'

class Strategy

  REPO_REGEX = /git@github\.com:([^\/]*)\/(.*)\.git/
  include MongoMapper::Document

  cattr_accessor :strategies_location
  cattr_accessor :start_code_file_name
  cattr_accessor :start_code_file_location

  key :username, String, required: true, unique: true
  key :github_url, String, required: true, unique: true
  validates_format_of :github_url, :with => REPO_REGEX, message: 'Your repository url needs to be the ssh url.  e.g. git@github.com:my_username/myrepo.git'

  # local path where we've cloned this
  key :path, String, required: true

  before_save :clone_repo
  after_destroy :delete_repo

  def initialize(url = nil)
    if url
      self.url = url
    end
    self
  end

  def self.lookup(username)
    Strategy.where(username: username).first
  end

  def launch
    puts "Lauching #{username}"
    start_code_file_destination = File.join(path, @@start_code_file_name)
    forced = true
    FileUtils.remove_file(start_code_file_destination, forced)
    #clone_repo
    puts @@start_code_file_location
    FileUtils.cp @@start_code_file_location, start_code_file_destination
    cmd = "cd #{path} && bundle && ruby #{@@start_code_file_name} #{username}"
    puts cmd
    @pid = Process.spawn(cmd)
    puts "Launched #{username}"
  end

  def kill
    puts "Killing #{username}"
    Process.kill 'HUP', @pid
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

  def gravatar
    author = Kablammo::Git::latest_author path
    if author
      email_address = author.email
      hash = Digest::MD5.hexdigest(email_address)
      "http://www.gravatar.com/avatar/#{hash}"
    else
      nil
    end
  end

  def delete_repo
    if File.exists?(path)
      FileUtils.rm_rf(path)
    end
  end

  def clone_repo
    # may want some error protection around this system command
    begin
      Kablammo::Git.pull_or_clone(github_url,path)
    rescue Git::GitExecuteError => ex
      puts "GIT ERROR: ", ex
      self.errors.add :github_url, "Unable to clone url.  Check your Url and permissions"
      false
    end
  end

  def sha
    Kablammo::Git.sha(path)
  end

  def score
    scores = Battle.for_strategy(self).map(&:score).reject(&:empty?)
    scores.reduce(0) { |total, score| total += ( score[username] || 0 ) } || 0
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
