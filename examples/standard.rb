require 'fishbans'

print 'Enter a username: '
username = gets.chomp
begin
  bans = Fishbans.get_total_bans(username)
  if bans > 0
    message = "#{username} has been banned! What a loser! They've been banned #{bans} times!"
  else
    message = "#{username} has not been banned! What a gentle person!"
  end
rescue RuntimeError => e
  message = "Error: #{e.message}"
ensure
  puts message
end
