require 'womb'
require_relative 'repo'
require_relative 'constants'

Tasks = Womb[Module.new]
  .assign(:clone) { |hex, url, branch| Repo.new(TMP + hex).clear.clone(url).checkout(branch).ls }
  .assign(:push) { |hex, message| Repo.new(TMP + hex).open.add.commit(message).push }
  .assign(:ls) { |hex| Repo.new(TMP + hex).open.ls }
  .assign(:read) { |hex, path| Repo.new(TMP + hex).read(path) }
  .assign(:write) { |hex, path, body| Repo.new(TMP + hex).write(path, body) }
  .assign(:delete) { |hex, path| Repo.new(TMP + hex).delete(path) }
  .birth
