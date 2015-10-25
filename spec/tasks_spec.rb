require 'repo'
require 'tasks'
require 'constants'

describe Tasks do
  let!(:remote) do
    Repo.new(TMP + 'remote')
        .clear
        .init
        .write('index.html', '<html>Index</html>')
        .add
        .commit('Initial commit')
        .branch('with-about')
        .write('about.html', '<html>About</html>')
        .add
        .commit('Added about page')
  end

  let!(:hex) { 'fhur7fh98e98234hne' }
  let!(:logo_file) { 'assets/img/logo.svg' }
  let!(:logo_body) { '<svg><circle cx="40" cy="40" r="40" /></svg>' }
  let!(:local) { Repo.new(TMP + hex) }

  it '.clone' do
    res = Tasks.clone(hex, remote.base, 'master')
    expect(res).to eql({ files: ['index.html'] })
  end

  it '.ls' do
    res = Tasks.ls(hex)
    expect(res).to eql({ files: ['index.html'] })
  end

  it '.read' do
    res = Tasks.read(hex, 'index.html')
    expect(res).to eql({ body: '<html>Index</html>' })
  end

  it '.write' do
    res = Tasks.write(hex, logo_file, logo_body)
    expect(res).to eql({})
    expect(local.ls).to contain_exactly('index.html', logo_file)
    expect(local.read(logo_file)).to eql(logo_body)
  end

  it '.delete' do
    res = Tasks.delete(hex, 'index.html')
    expect(res).to eql({})
    expect(local.ls).to contain_exactly(logo_file)
  end

  it '.push' do
    res = Tasks.push(hex, 'Added circle and deletes index')
    expect(res).to eql({})
    remote.checkout('master')
    expect(remote.ls).to contain_exactly(logo_file)
    expect(remote.read(logo_file)).to eql(logo_body)
  end
end
