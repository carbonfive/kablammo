module Kablammo
  class Git
    class << self
      def sha path
        begin
          g = ::Git.open(path)
          g.object('HEAD').sha
        rescue ::Git::GitExecuteError => ex
          nil
        end
      end

      def repo_exists? path
        r = true
        begin
          g = ::Git.open(path)
          g.object('HEAD')
        rescue ::Git::GitExecuteError => ex
          puts "[repo_exists] Caught", ex
          r = false
        rescue ArgumentError => ex
          puts "[repo_exists] Caught", ex
          r = false
        end
        r
      end

      def pull_or_clone github_repo_url, local_repo_path
        if repo_exists? local_repo_path
          g = ::Git.open(local_repo_path)
          g.reset_hard g.object('HEAD')
          g.checkout('master')
          g.pull
        else
          ::Git.clone(github_repo_url, local_repo_path)
        end
      end
    end
  end
end
