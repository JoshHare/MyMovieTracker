require "application_system_test_case"

class SeensTest < ApplicationSystemTestCase
  setup do
    @seen = seens(:one)
  end

  test "visiting the index" do
    visit seens_url
    assert_selector "h1", text: "Seens"
  end

  test "should create seen" do
    visit seens_url
    click_on "New seen"

    click_on "Create Seen"

    assert_text "Seen was successfully created"
    click_on "Back"
  end

  test "should update Seen" do
    visit seen_url(@seen)
    click_on "Edit this seen", match: :first

    click_on "Update Seen"

    assert_text "Seen was successfully updated"
    click_on "Back"
  end

  test "should destroy Seen" do
    visit seen_url(@seen)
    click_on "Destroy this seen", match: :first

    assert_text "Seen was successfully destroyed"
  end
end
