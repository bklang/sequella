require 'spec_helper'
require 'ostruct'

describe Sequella::Plugin::Service do
  subject { Sequella::Plugin::Service }

  describe '#start' do
    it 'should not raise an error if start attempted with a uri specified' do
      config = OpenStruct.new uri: 'postgres://user:password@localhost/blog'
      subject.should_receive(:establish_connection).with(config.uri)
      subject.should_receive(:require_models)

      expect { subject.start config.marshal_dump }.to_not raise_error
    end
  end

  describe '#connection_string' do
    it 'should use uri if specified in params' do
      params = { uri: 'this-is-a-connection-uri' }

      connection_string = subject.connection_string params
      expect(connection_string).to eq(params[:uri])
    end

    it 'should raise error if adapter is not specified' do
      params = { }

      expect { subject.connection_string(params) }.to raise_error 'Must supply an adapter argument to the Sequel configuration'
    end

    context 'for ruby platform' do
      let(:connection_params) {
        {
          adapter: 'postgres',
          host: 'localhost',
          port: 5432,
          database: 'test',
          username: 'test-user',
          password: 'password'
        }
      }

      it 'mri' do
        stub_const('RUBY_PLATFORM', 'x86_64-linux')

        connection_string = subject.connection_string connection_params
        expect(connection_string).to eq('postgres://localhost:5432/test?user=test-user&password=password')
      end

      it 'jruby' do
        stub_const('RUBY_PLATFORM', 'java')

        connection_string = subject.connection_string connection_params
        expect(connection_string).to eq('jdbc:postgres://localhost:5432/test?user=test-user&password=password')
      end
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
