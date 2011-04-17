puts 'falisdhhh'

require 'test_helper'

puts '8ad6yfiasfdf'

class MarbleTest < ActionDispatch::IntegrationTest
  def test_render_json
    get '/', :format => :json
    assert_equal({ 'instance' => 'OK', 'local' => 'OK' }, JSON.parse(response.body))
  end
  
  def test_render_yaml
    get '/', :format => :yaml
    assert_equal({ 'instance' => 'OK', 'local' => 'OK' }, YAML.load(response.body))
  end
end