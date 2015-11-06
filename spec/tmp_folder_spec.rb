require 'tmp_folder'
require 'pathname'
require 'repo'

describe TmpFolder do
  tmp = Pathname.new('../../tmp').expand_path(__FILE__)
  index = '<html>Index</html>'
  logo = '<svg><circle cx="40" cy="40" r="40" /></svg>'
  folder = TmpFolder.new('folder')
  ls = ->() { (tmp + 'folder').children.map(&:basename).map(&:to_s) }

  before(:all) do
    tmp.mkpath
    tmp.children.each(&:rmtree)
  end

  it 'presents simplified API for managing a folder' do
    # it writes
    folder.write('index.html', index).write('assets/img/logo.svg', logo)
    expect(File.read(tmp + 'folder/index.html')).to eql(index)
    expect(File.read(tmp + 'folder/assets/img/logo.svg')).to eql(logo)

    # it reads
    expect(folder.read('index.html')).to eql(index)
    expect(folder.read('assets/img/logo.svg')).to eql(logo)

    # it deletes
    expect(ls.()).to contain_exactly('index.html', 'assets')
    folder.delete('index.html')
    expect(ls.()).to contain_exactly('assets')

    # it clears
    folder.clear
    expect(ls.()).to contain_exactly()
  end

  it 'does not raise when clearing a folder that does not exist' do
    expect { TmpFolder.new('blah').clear }.to_not raise_error
  end

  it 'presents the Repo interface' do
    expect(Repo).to receive(:init).with((tmp + 'folder').to_path)
    folder.git.init
  end
end
