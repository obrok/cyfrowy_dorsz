class MerbAuthSlicePassword::Sessions < MerbAuthSlicePassword::Application
  private
  
  def redirect_after_login
    message[:notice] = "Zostałeś pomyślnie zalogowany."
    redirect_back_or "/", :message => message, :ignore => [slice_url(:login), slice_url(:logout)]
  end

  def redirect_after_logout
    message[:notice] = "Zostałeś wylogowany."
    redirect "/", :message => message
  end

end