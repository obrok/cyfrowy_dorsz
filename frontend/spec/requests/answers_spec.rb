require 'spec/spec_helper'

describe "Student" do
  before(:each) do
    visit "/answers"
  end

  it "can access the answers controller" do
    response_status.should == 200
  end

  it "should have to provide correct token to authenticate" do
    token = create_token
    fill_in "Token", :with => token.value
    click_button "Wypełnij ankietę"
    response.should include token.poll.name
  end

  it "should not be authenticated if token is invalid" do
    fill_in "Token", :with => "losowyciag"
    click_button "Wypełnij ankietę"
    response.should include "Nieważny token"
  end
end
