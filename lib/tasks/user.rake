namespace :user do
	desc "Create a user given email and password"
	task :create, [:email, :password] => :environment do |t, args|
	  user = DailyUser.new(:email => args[:email], :password => args[:password])
	  if user.save
	    puts "User #{user.email} created!"
    else
      puts "Error: #{user.errors.full_messages.join(", ")}"
    end
  end
  task :admin, [:email, :password] => [:environment, :create] do |t, args|
    user = DailyUser.find_by_email(args[:email])
    if user
      user.admin = true
      if user.save
        puts "User made admin."
      else
        puts "User NOT saved as admin."
      end
    else
      put "User not found."
    end
  end
end