require 'womb'
require_relative 'tmp_folder'

Tasks = Womb[Module.new]
  .assign(:clone)  { |hex, url, branch| TmpFolder.new(hex).clear.git.clone(url).checkout(branch).ls }
  .assign(:push)   { |hex, message|     TmpFolder.new(hex).git.open.add.commit(message).push        }
  .assign(:ls)     { |hex|              TmpFolder.new(hex).git.open.ls                              }
  .assign(:read)   { |hex, path|        TmpFolder.new(hex).read(path)                               }
  .assign(:write)  { |hex, path, body|  TmpFolder.new(hex).write(path, body)                        }
  .assign(:delete) { |hex, path|        TmpFolder.new(hex).delete(path)                             }
  .birth
