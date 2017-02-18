require 'httpclient'
require 'json'
require_relative 'block_engine'
require_relative 'player_skins'

module Fishbans
  include BlockEngine
  include PlayerSkins

  extend self
  @client = HTTPClient.new
  SERVICES = [
    'mcbouncer',
    'minebans',
    'glizer',
    'mcblockit',
    'mcbans'
  ]

  # Gets all bans on a user.
  # @param username [String] The username to check.
  # @return see #parse_generic_ban_result
  # @raise see #get
  def get_all_bans(username)
    response = get("http://api.fishbans.com/bans/#{username}")
    parse_generic_ban_result(response)
  end

  # Gets all bans for a given service for a user.
  # @param username [String] The username to check.
  # @param service [String] The service to check. Can be any of the values in the SERVICES array.
  # @return [Boolean] False if the service is not an accepted value.
  # @return [Hash<String, String>] Key: Minecraft server; value: reason
  # @raise see #get
  def get_ban_service(username, service)
    service.downcase!

    if SERVICES.include? service
      response = get("http://api.fishbans.com/bans/#{username}/#{service}")
      parse_generic_ban_result(response)[service]
    else
      false
    end
  end

  # Gets the total number of bans that the user has.
  # @param username [String] The username to check.
  # @return [Integer] The number of bans the user has.
  # @raise see #get
  def get_total_bans(username)
    response = get("http://api.fishbans.com/stats/#{username}")
    response['stats']['totalbans']
  end

  # Gets the total number of bans by service that the user has.
  # @param username [String] The username to check.
  # @param service [String] The service to check. Can be any of the values in
  #   the SERVICES array.
  # @return [Boolean] False if the service is not an accepted value.
  # @return [Integer] The number of bans the user has in the given service. See SERVICES for valid services.
  # @raise see #get
  def get_total_bans_service(username, service)
    service.downcase!

    if SERVICES.include?(service)
      # Note that the /service part is not necessary, but it slightly improves
      #   performance of the API.
      response = get("http://api.fishbans.com/stats/#{username}/#{service}")
      response['stats']['service'][service]
    else
      false
    end
  end

  # Gets the Minecraft UUID for the user.
  # @param username [String] The username to get the ID for.
  # @return [String] The user's UUID.
  # @raise see #get
  def get_userid(username)
    response = get("http://api.fishbans.com/uuid/#{username}")
    response['uuid']
  end

  # Gets username history for the user.
  # @param username [String] The username to get history for.
  # @return [Array<String>] Array of strings containing old usernames.
  # @raise see #get
  def get_username_history(username)
    response = get("http://api.fishbans.com/history/#{username}")
    response['data']['history']
  end

  private

  # Performs a basic GET request.
  # @param url [String] The URL to get.
  # @param do_json [Boolean] Whether to parse the JSON before returning.
  # @return [Hash] The parsed JSON of the response, if do_json is true.
  # @return [HTTP::Message] Unparsed response, if do_json is false.
  # @raise [RuntimeError] An error if the request is not successful.
  def get(url, do_json = true)
    url = URI.encode(url)
    uri = URI.parse(url)
    response = @client.get(uri)
    return response unless do_json
    json = JSON.parse(response.body)
    return json if json['success']
    fail json['error']
  end

  # Parses a basic ban result into a formatted hash. This assumes it is not an errored response.
  # @param response [JSON] The response to parse.
  # @return [Hash<String, Hash<String, String>>] Service (see SERVICES) is the key; value is a hash with
  #   server as the key, and the reason as the value. Empty hash if there are no bans.
  def parse_generic_ban_result(response)
    ret = {}
    response['bans']['service'].each do |service, info|
      next if info['bans'] == 0
      ret[service] = {}
      info['ban_info'].each do |server, reason|
        ret[service][server] = reason
      end
    end

    ret
  end
end
