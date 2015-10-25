require 'repo'
require 'constants'

describe Repo do
  it 'presents simplified API for git' do
    remote = Repo.new(TMP + 'remote')
                 .clear
                 .init
                 .write('index.html', '<html>Index</html>')
                 .add
                 .commit('Initial commit')
                 .branch('with-about')
                 .write('about.html', '<html>About</html>')
                 .add
                 .commit('Added about page')

    expect(remote.ls).to contain_exactly('index.html', 'about.html')
    expect(remote.read('index.html')).to eql('<html>Index</html>')

    local = Repo.new(TMP + 'local').clear.clone(remote.base)
    expect(local.ls).to contain_exactly('index.html', 'about.html')

    local.checkout('master')
    expect(local.ls).to contain_exactly('index.html')

    local.write('assets/img/logo.svg', '<svg><circle cx="40" cy="40" r="40" /></svg>')
         .delete('index.html')
         .add
         .commit('Add circle and remove index')
         .push
    remote.checkout('master')
    expect(remote.ls).to contain_exactly('assets/img/logo.svg')
    expect(remote.read('assets/img/logo.svg')).to eql('<svg><circle cx="40" cy="40" r="40" /></svg>')
  end
end
