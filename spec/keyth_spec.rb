# encoding: utf-8
require 'tempfile'
require 'yaml'
require 'dotenv'
require 'spec_helper'

describe Keyth do
  before :each do
    make_temp_store
  end

  after :each do
    destroy_temp_store
  end

  describe '#get_key' do
    it 'raises an error for a missing key' do
      expect { Keyth.get_key('keyth-testing/TEST_KEY') }.to raise_error
    end
  end

  describe '#get_key_safe' do
    it 'returns nil for a missing key and raises no error' do
      expect(Keyth.get_key_safe('keyth-testing/TEST_KEY')).to be_nil
      expect { Keyth.get_key_safe('keyth-testing/TEST_KEY') }.not_to raise_error
    end
  end

  describe '#add_key' do
    it 'adds a key that can be retrieved later with the same value' do
      Keyth.add_key('keyth-testing/TEST_KEY', 'TEST_VALUE')
      expect(Keyth.get_key('keyth-testing/TEST_KEY')).to eq('TEST_VALUE')
    end
  end

  describe '#delete_key' do
    it 'deletes a previously added key' do
      Keyth.add_key('keyth-testing/TEST_KEY', 'TEST_VALUE')
      Keyth.delete_key('keyth-testing/TEST_KEY')
      expect { Keyth.get_key('keyth-testing/TEST_KEY') }.to raise_error
    end
  end

  describe '#keys' do
    before :each do
      Keyth.add_key('keyth-testing/TEST_KEY', 'TEST_VALUE')
      Keyth.add_key('keyth-testing/TEST_KEY2', 'TEST_VALUE')
      Keyth.add_key('keyth-testing2/TEST_KEY3', 'TEST_VALUE')
    end

    it 'returns a list of all existing keys' do
      keys = Keyth.keys
      expect(keys).to include('keyth-testing/TEST_KEY' => 'TEST_VALUE')
      expect(keys).to include('keyth-testing/TEST_KEY2' => 'TEST_VALUE')
      expect(keys).to include('keyth-testing2/TEST_KEY3' => 'TEST_VALUE')
    end

    it 'returns a list of all keys in a namespace' do
      keys = Keyth.keys('keyth-testing2')
      expect(keys).to match('keyth-testing2/TEST_KEY3' => 'TEST_VALUE')
    end
  end

  describe 'DotEnv support' do
    describe 'DotEnv Monkey-patch' do
      it 'loads a .env file with the keys translated' do
        Keyth.add_key('keyth-testing/TEST_KEY', 'TEST_VALUE')
        Dotenv.load
        expect(ENV['CLICK']).to eq('TEST_VALUE')
      end
    end
  end

  describe 'YAML Support' do
    before :each do
      Keyth.add_key('keyth-testing/TEST_KEY', 'TEST_VALUE')
      test_keys = { es: { key1: 'boring', key2: 'keyth:keyth-testing/TEST_KEY' } }
      @yaml_file = Tempfile.new('keyth_spec_test')
      @yaml_file.write(test_keys.to_yaml)
      @yaml_file.close
    end

    after :each do
      @yaml_file.unlink
    end

    describe '#load_yaml' do
      it 'loads a YAML File with the keys translated' do
        keys = Keyth.load_yaml(File.open(@yaml_file))
        expect(keys[:es][:key2]).to eq('TEST_VALUE')
      end
    end

    describe 'YAML Monkey-patch' do
      it 'loads a YAML File with the keys automatically translated' do
        keys = YAML.load(File.open(@yaml_file))
        expect(keys[:es][:key2]).to eq('TEST_VALUE')
      end
    end
  end
end
