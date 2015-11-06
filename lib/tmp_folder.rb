require 'womb'
require 'pathname'
require_relative 'repo'

base = Pathname.new('../../tmp').expand_path(__FILE__)

repo_wrapper = Womb[Class.new]
  .init(:path)
  .def(:open) { Repo.open(@path) }
  .def(:init) { Repo.init(@path) }
  .def(:clone){ |url| Repo.clone(url, @path) }
  .birth

TmpFolder = Womb[Class.new]
  .def(:initialize) { |relative = ''| @folder = base + relative }
  .def(:clear) { folder.mkpath; folder.children.each(&:rmtree); self }
  .def(:read) { |file| File.read(folder + file) }
  .def(:delete) { |file| File.delete(folder + file); self }
  .def(:write) { |file, body| ensure_parent(file); File.write(folder + file, body); self }
  .def(:git) { repo_wrapper.new(folder.to_path) }
  .private
  .attr_reader(:folder)
  .def(:ensure_parent) { |file| (folder + file).parent.mkpath }
  .birth
