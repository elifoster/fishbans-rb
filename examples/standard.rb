# Creating a string based on the get_total_bans method.

require 'fishbans'

username = 'satanicsanta'
bans = Fishbans.get_total_bans(username)
if bans.is_a?(Fixnum)
  if bans > 0
    message = "#{username} has been banned! What a loser! They've " \
              "been banned #{bans} times!"
  else
    message = "#{username} has not been banned! What a gentle person!"
  end
else
  message = "Error: #{bans}"
end
puts message
