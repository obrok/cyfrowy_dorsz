describe "Per question results" do
  before(:each) do
    @poll = create_poll
    @user = @poll.user
    @q1 = create_question(:text => "Pytanie 1", :poll => @poll)
    @q2 = create_question(:text => "Pytanie 2", :poll => @poll)
    @a1 = create_question_answer(:question => @q1)
    @a2 = create_question_answer(:question => @q1)
    @a1 = create_question_answer(:question => @q2)
    login_as(@user, CreationTestHelper::USER_HASH[:password])
    visit resource(@poll, :edit)
  end

  it "should be possible to navigate to a question's answers" do
    click_link "Odpowiedzi do pytania Pytanie 1"
    response.should include "Pytanie 1"
    response.should_not include "Pytanie 2"
  end
end
