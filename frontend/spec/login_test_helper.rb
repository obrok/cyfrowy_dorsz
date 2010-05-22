module LoginTestHelper
  def login
    $current_user = create_user
    login_as($current_user)
  end

  def login_as(user, password=nil)
    visit "/login"
    fill_in "Email", :with => user.email
    fill_in "Password", :with => password || CreationTestHelper::USER_HASH[:password]
    click_button "Log In"
  end

  def logout
    visit "/logout"
  end
end

include LoginTestHelper
