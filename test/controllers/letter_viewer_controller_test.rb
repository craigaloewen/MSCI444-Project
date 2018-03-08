require 'test_helper'

class LetterViewerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get letter_viewer_index_url
    assert_response :success
  end

  test "should get letterview" do
    get letter_viewer_letterview_url
    assert_response :success
  end

end
