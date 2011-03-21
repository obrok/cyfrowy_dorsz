desc "Create an admin account. The admin will receive an email."
task :create_admin => :merb_env do
  puts "Email:"
  @user = User.new(:email => Readline.readline, :admin => true, :blocked => false)
  @user.reset_password!
end
