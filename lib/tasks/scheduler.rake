task :call_page => :environment do
  # // Open the file with fast csv 
  # Create the user. for those Failed user , save it into the failed user db
  uri = URI.parse('http://happyq.herokuapp.com/')
  Net::HTTP.get(uri)
  puts "this is it"
end

 