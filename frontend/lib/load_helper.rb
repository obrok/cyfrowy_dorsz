module LoadHelper

  protected

  def load_poll
    @poll = session.user.polls_dataset[:id => params[:poll_id] || params[:id]] or raise Merb::ControllerExceptions::NotFound
  end

  def load_polls
    @polls = session.user.polls
  end

  def load_token
    @token = @poll.tokens_dataset[:id => params[:id]] or raise Merb::ControllerExceptions::NotFound
  end

  def load_question
    @question = @poll.questions_dataset[:id => params[:id]] or raise Merb::ControllerExceptions::NotFound 
  end

end
