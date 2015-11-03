require_relative 'repo'
require_relative 'constants'

module Tasks
  class << self
    def clone(hex, repo, branch)
      Repo.new(TMP + hex).clear.clone(repo).checkout(branch).ls
    end

    def push(hex, message)
      Repo.new(TMP + hex).add.commit(message).push
    end

    def ls(hex)
      Repo.new(TMP + hex).ls
    end

    def read(hex, path)
      Repo.new(TMP + hex).read(path)
    end

    def write(hex, path, body)
      Repo.new(TMP + hex).write(path, body)
    end

    def delete(hex, path)
      Repo.new(TMP + hex).delete(path)
    end
  end
end
