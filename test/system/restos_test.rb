require "application_system_test_case"

class RestosTest < ApplicationSystemTestCase
  setup do
    @resto = restos(:one)
  end

  test "visiting the index" do
    visit restos_url
    assert_selector "h1", text: "Restos"
  end

  test "creating a Resto" do
    visit restos_url
    click_on "New Resto"

    fill_in "Name", with: @resto.name
    click_on "Create Resto"

    assert_text "Resto was successfully created"
    click_on "Back"
  end

  test "updating a Resto" do
    visit restos_url
    click_on "Edit", match: :first

    fill_in "Name", with: @resto.name
    click_on "Update Resto"

    assert_text "Resto was successfully updated"
    click_on "Back"
  end

  test "destroying a Resto" do
    visit restos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Resto was successfully destroyed"
  end
end
