require 'chunky_png'
require_relative 'fishbans'

module Fishbans
  module PlayerSkins
    # Gets the image for the front face of the player head.
    # @param username [String] The username to get the head of.
    # @param size [Fixnum] The width of the image to get.
    # @return [ChunkyPNG::Image] The ChunkyPNG::Image instance of that head.
    def get_player_head(username, size = 100)
      get_player_image(username, 'helm', size)
    end

    # Gets the image for the entire front of the player.
    # @param username [String] See #get_player_head.
    # @param size [Fixnum] See #get_player_head.
    # @return [ChunkyPNG::Image] The ChunkyPNG::Image instance of that front.
    def get_player_front(username, size = 100)
      get_player_image(username, 'player', size)
    end

    # Gets the image for the player's raw skin.
    # @param username [String] See #get_player_head.
    # @param size [Fixnum] See #get_player_head.
    # @return [ChunkyPNG::Image] The ChunkyPNG::Image instance of that skin.
    def get_player_skin(username, size = 64)
      get_player_image(username, 'skin', size)
    end

    private

    # Gets the player image for the type.
    # @param username [String] See #get_player_head.
    # @param type [String] The type of image to get. Can be 'helm', 'player', or
    #   'skin' as defined by the Fishbans Player Skins API.
    # @param size [Fixnum] See #get_player_head.
    # @return [ChunkyPNG::Image] The ChunkyPNG::Image instance for the params.
    def get_player_image(username, type, size)
      type.downcase
      url = "http://i.fishbans.com/#{type}/#{username}/#{size}"
      response = get(url, false)
      ChunkyPNG::Image.from_blob(response.body)
    end
  end
end
