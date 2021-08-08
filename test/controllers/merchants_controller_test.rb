require 'test_helper'

class MerchantsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get merchants_index_url
    assert_response :success
  end

end
