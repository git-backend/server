require 'tasks'
require 'pathname'

describe Tasks do
  tmp = Pathname.new('../../tmp').expand_path(__FILE__)
  remote = TmpFolder.new('remote')
  remote_repo = nil
  hex = 'fhur7fh98e98234hne'
  logo = '<svg><circle cx="40" cy="40" r="40" /></svg>'
  logo_file = 'assets/img/logo.svg'
  local = TmpFolder.new(hex)
  let(:local_repo) { local.git.open }

  before(:all) do
    tmp.mkpath
    tmp.children.each(&:rmtree)
    remote.clear.write('index.html', '<html>Index</html>')
    remote_repo = remote.git.init.add.commit('Initial commit')
    remote.write('about.html', '<html>About</html>')
    remote_repo.branch('with-about').add.commit('Added about page')
  end

  it 'successfully completes tasks' do
    # it clones
    res = Tasks.clone(hex, (tmp + 'remote').to_path, 'master')
    expect(res).to contain_exactly('index.html')

    # it lists files
    expect(Tasks.ls(hex)).to contain_exactly('index.html')

    # it reads
    expect(Tasks.read(hex, 'index.html')).to eql('<html>Index</html>')

    # it writes
    Tasks.write(hex, logo_file, logo)
    expect(local_repo.ls).to contain_exactly('index.html', logo_file)
    expect(local.read(logo_file)).to eql(logo)

    # it deletes
    Tasks.delete(hex, 'index.html')
    expect(local_repo.ls).to contain_exactly(logo_file)

    # it pushes
    Tasks.push(hex, 'Added circle and deletes index')
    remote_repo.checkout('master')
    expect(remote_repo.ls).to contain_exactly(logo_file)
    expect(remote.read(logo_file)).to eql(logo)
  end
end
