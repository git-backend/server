require 'repo'
require 'pathname'

describe Repo do
  tmp = Pathname.new('../../tmp').expand_path(__FILE__)

  before(:all) do
    tmp.mkpath
    tmp.children.each(&:rmtree)
    (tmp + 'remote').mkpath
    (tmp + 'local').mkpath
  end

  it 'presents simplified API for git' do
    # Create an initial commit
    File.write(tmp + 'remote/index.html', '<html>Index</html>')
    remote = Repo.init((tmp + 'remote').to_path).add.commit('Initial commit')

    # Create a feature branch
    File.write(tmp + 'remote/about.html', '<html>About</html>')
    remote.branch('with-about').add.commit('Added about page')

    # List files in feature branch
    expect(remote.ls).to contain_exactly('index.html', 'about.html')

    # Clone to local
    local = Repo.clone((tmp + 'remote').to_path, (tmp + 'local').to_path)
    expect(local.ls).to contain_exactly('index.html', 'about.html')

    # Checkout master
    local.checkout('master')
    expect(local.ls).to contain_exactly('index.html')

    # Add new commit push to remote
    File.write(tmp + 'local/logo.svg', '<svg><circle cx="40" cy="40" r="40" /></svg>')
    File.delete(tmp + 'local/index.html')
    local.add.commit('Add circle and remove index').push

    # Open remote, checkout master and list files
    remote = Repo.open((tmp + 'remote').to_path)
    remote.checkout('master')
    expect(remote.ls).to contain_exactly('logo.svg')
  end
end
