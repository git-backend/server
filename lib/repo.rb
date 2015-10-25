require 'git'

class Repo
  attr_reader :base

  def initialize(base)
    @base = base
  end

  def git
    @git ||= Git.open(base.to_path)
  end

  def clone(repo)
    @git = Git.clone(repo, base.to_path)
    self
  end

  def init
    @git = Git.init(base.to_path)
    self
  end

  def clear
    base.rmtree if base.exist?
    base.mkpath
    self
  end

  def checkout(branch_name)
    git.checkout(branch_name)
    self
  end

  def branch(branch_name)
    git.branch(branch_name).checkout
    self
  end

  def add
    git.add(all: true)
    self
  end

  def commit(message)
    git.commit(message)
    self
  end

  def push
    git.push('origin', git.current_branch, force: true)
    self
  end

  def ls
    add
    git.ls_files.keys
  end

  def read(file)
    File.read((base + file).to_path)
  end

  def write(file, body)
    (base + file).parent.mkpath
    File.write((base + file).to_path, body)
    self
  end

  def delete(file)
    File.delete((base + file).to_path)
    self
  end
end
