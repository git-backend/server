require 'git'
require 'womb'

Repo = Womb[Class.new]
  .init(:base)
  .attr_reader(:base, :git)
  .def(:open) { @git = Git.open(path); self }
  .def(:init) { @git = Git.init(path); self }
  .def(:clone) { |url| @git = Git.clone(url, path); self }
  .def(:checkout) { |branch| git.checkout(branch); self }
  .def(:branch) { |branch| git.branch(branch).checkout; self }
  .def(:add) { git.add(all: true); self }
  .def(:commit) { |message| git.commit(message); self }
  .def(:push) { git.push('origin', git.current_branch, force: true); self }
  .def(:ls) { add; git.ls_files.keys }
  .def(:clear) { base.rmtree if base.exist?; base.mkpath; self }
  .def(:read) { |file| File.read(filepath(file)) }
  .def(:delete) { |file| File.delete(filepath(file)); self }
  .def(:write) { |file, body| make_parent_path(file); File.write(filepath(file), body); self }
  .private
  .def(:path) { base.to_path }
  .def(:filepath) { |file| (base + file).to_path }
  .def(:make_parent_path) { |file| (base + file).parent.mkpath }
  .birth
