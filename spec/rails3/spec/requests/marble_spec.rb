require 'spec_helper'

describe Marble::Rails do
  it 'should render JSON' do
    get '/', :format => :json
    JSON.parse(response.body).should == { 'instance' => 'OK', 'local' => 'OK' }
  end
  
  it 'should render YAML' do
    get '/', :format => :yaml
    YAML.load(response.body).should == { 'instance' => 'OK', 'local' => 'OK' }
  end
end