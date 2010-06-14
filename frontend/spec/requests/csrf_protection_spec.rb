describe "CSRF protection" do
  [:post, :put].each do |method|
    it "should not allow requests without valid CSRF token via #{method} " do
      visit("/", method)
      response_status.should == 400
    end
  end
end
