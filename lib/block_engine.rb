require 'chunky_png'
require_relative 'fishbans'

module Fishbans
  module BlockEngine
    # Gets a block image by its ID and Metadata. Unfortunately it uses the old
    #   block IDs rather than the new ones, so you have to memorize those
    #   pesky integers.
    # @param id [Integer] The (outdated) block ID number.
    # @param metadata [Integer] The metadata, if any, for the block.
    # @param size [Fixnum] The size of the image to get.
    # @return [ChunkyPNG::Image] The ChunkyPNG instance of that block image.
    def get_block(id, metadata = nil, size = 42)
      url = "http://blocks.fishbans.com/#{id}"
      url += "-#{metadata}" unless metadata.nil?
      url += "/#{size}" if size != 42
      response = get(url, false)
      ChunkyPNG::Image.from_blob(response.body)
    end

    # Gets the monster image by its ID.
    # @param id [Any] The string ID. It will automatically prefix it with "m" if
    #   that is omitted. It doesn't matter what type it is: String or Fixnum,
    #   because it will automatically convert it to a String.
    # @param three [Boolean] Whether to get a three-dimensional monster image.
    #   The three-dimensional image is of the full monster, while the
    #   two-dimensional image is just its head.
    # @param size [Integer] The size of the image (width) to get. For 3D images
    #   this will not be perfect just by nature of the API.
    # @return [ChunkyPNG::Image] The ChunkyPNG instance of that monster image.
    def get_monster(id, three = false, size = 42)
      id = id.to_s
      url = 'http://blocks.fishbans.com'
      url += "/#{id}" if id =~ /^m/
      url += "/m#{id}" if id !~ /^m/
      url += '-3d' if three
      url += "/#{size}" if size != 42
      response = get(url, false)
      ChunkyPNG::Image.from_blob(response.body)
    end
  end
end
