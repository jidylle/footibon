desc "This task is called by the Heroku scheduler add-on"

task :reset_score_day => :environment do
  puts "Updating score day..."
  User.reset_score_day
  puts "done"
end