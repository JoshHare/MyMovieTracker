require "test_helper"

class SeensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seen = seens(:one)
  end

  test "should get index" do
    get seens_url
    assert_response :success
  end

  test "should get new" do
    get new_seen_url
    assert_response :success
  end

  test "should create seen" do
    assert_difference("Seen.count") do
      post seens_url, params: { seen: {  } }
    end

    assert_redirected_to seen_url(Seen.last)
  end

  test "should show seen" do
    get seen_url(@seen)
    assert_response :success
  end

  test "should get edit" do
    get edit_seen_url(@seen)
    assert_response :success
  end

  test "should update seen" do
    patch seen_url(@seen), params: { seen: {  } }
    assert_redirected_to seen_url(@seen)
  end

  test "should destroy seen" do
    assert_difference("Seen.count", -1) do
      delete seen_url(@seen)
    end

    assert_redirected_to seens_url
  end
end
