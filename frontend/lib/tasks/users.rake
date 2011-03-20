desc "Create a user account. The user will receive an email."
task :create_user => :merb_env do
  puts "Email:"
  @user = User.new(:email => Readline.readline, :admin => false, :blocked => false)
  @user.reset_password!
end
