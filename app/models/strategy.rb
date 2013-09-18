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

  before_save :fetch_repo
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
    print "Lauching #{username}... "
    start_code_file_destination = File.join(path, @@start_code_file_name)
    forced = true
    FileUtils.remove_file(start_code_file_destination, forced)
    FileUtils.cp @@start_code_file_location, start_code_file_destination
    Bundler.with_clean_env do
      cmd = "cd #{path} && bundle exec ruby #{@@start_code_file_name} #{username}"
      @pid = Process.spawn(cmd)
      Process.detach(@pid)
    end
    puts "done (pid #{@pid})"
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

  def repo_exists?
    File.exists? path
  end

  def delete_repo
    if repo_exists?
      FileUtils.rm_rf(path)
    end
  end

  def fetch_repo(opts = {})
    # may want some error protection around this system command
    print "Getting latest code for #{username}... "
    begin
      Kablammo::Git.pull_or_clone github_url, path
    rescue Git::GitExecuteError => ex
      begin
        puts
        print "Error getting code, trying harder (#{ex.message})... "
        delete_repo
        Kablammo::Git.pull_or_clone github_url, path
      rescue Git::GitExecuteError => ex2
        puts
        puts "Error: ", ex2
        self.errors.add :github_url, "Unable to clone url.  Check your Url and permissions"
        return false
      end
    end
    cmd = opts[:bundle_update] ? 'bundle update' : 'bundle'
    print "#{cmd.sub(/e$/, '')}ing... "
    Bundler.with_clean_env do
      bundle_output = `#{cmd} 2>&1`
      status = $?
      if status.to_i != 0
        puts
        puts "Error running #{cmd}: #{status.to_s}"
        puts bundle_output
        return false
      end
    end
    puts 'done'
    true
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
