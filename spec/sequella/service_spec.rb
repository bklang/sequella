require 'spec_helper'
require 'ostruct'

describe Sequella::Service do
  subject { Sequella::Service }

  describe '#start' do
    it 'should raise if start attempted without an adapter specified' do
      config = OpenStruct.new
      expect { subject.start config }.to raise_error
    end
  end

  describe '#qualify_path' do
    it 'should not alter a path that begins with "/"' do
      subject.qualify_path('/tmp/foo/bar').should == '/tmp/foo/bar'
    end

    it 'should prefix the Adhearsion root for relative paths' do
      Adhearsion.should_receive(:root).once.and_return '/path/to/myapp'
      subject.qualify_path('models').should == '/path/to/myapp/models'
    end
  end

  describe '#require_models' do
    it 'should load all files in a given path' do
      Dir.should_receive(:glob).once.with('/tmp/models/*.rb').and_yield('/tmp/models/foo.rb').and_yield('/tmp/models/bar.rb')
      subject.should_receive(:require).once.ordered.with '/tmp/models/foo.rb'
      subject.should_receive(:require).once.ordered.with '/tmp/models/bar.rb'
      subject.require_models '/tmp/models'
    end
  end
end
