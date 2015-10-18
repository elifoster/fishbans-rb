require 'httpclient'
require 'json'

module Fishbans
  extend self
  @client = HTTPClient.new
  @services = [
    'mcbouncer',
    'minebans',
    'glizer',
    'mcblockit',
    'mcbans'
  ]

  # Gets all bans on a user.
  # @param username [String] The username to check.
  # @return [Hash/Nil/String] Either a hash of arrays containing information on
  #   the user's bans, or nil if they aren't banned. An error string if the
  #   request failed.
  def get_all_bans(username)
    response = get("http://api.fishbans.com/bans/#{username}")
    if response.is_a?(String)
      return response
    else
      return parse_generic_ban_result(response)
    end
  end

  # Gets all bans for a given service for a user.
  # @param username [String] The username to check.
  # @param service [String] The service to check. Can be any of the values in
  #   the @services array.
  # @return [Hash/Nil/Boolean/String] False if the service is not an accepted
  #   value. A hash of arrays containing information on the user's bans, or nil
  #   if they aren't banned. An error string if the request failed.
  def get_ban_service(username, service)
    service = service.downcase

    if @services.include? service
      response = get("http://api.fishbans.com/bans/#{username}/#{service}")
      if response.is_a?(String)
        return response
      else
        return parse_generic_ban_result(response)
      end
    else
      return false
    end
  end

  # Gets the total number of bans that the user has.
  # @param username [String] The username to check.
  # @return [Int/String] The number of bans the user has. An error string if the
  #   request failed.
  def get_total_bans(username)
    response = get("http://api.fishbans.com/stats/#{username}")
    if response.is_a?(String)
      return response
    else
      return response['stats']['totalbans']
    end
  end

  # Gets the total number of bans by service that the user has.
  # @param username [String] The username to check.
  # @param service [String] The service to check. Can be any of the values in
  #   the @services array.
  # @return [Int/Boolean/String] False if the service is not an accepted value.
  #   An int containing the number of bans the user has in the given service. An
  #   error string if the request failed.
  def get_total_bans_service(username, service)
    if @services.include?(service)
      # Note that the /service part is not necessary, but it slightly improves
      #   performance of the API.
      response = get("http://api.fishbans.com/stats/#{username}/#{service}")
      if response.is_a?(String)
        return response
      else
        return response['stats']['service'][service]
      end
    else
      return false
    end
  end

  # Gets the Minecraft UUID for the user.
  # @param username [String] The username to get the ID for.
  # @return [String] The user's UUID. An error string if the request failed.
  def get_userid(username)
    response = get("http://api.fishbans.com/uuid/#{username}")
    if response.is_a?(String)
      return response
    else
      return response['uuid']
    end
  end

  # Gets username history for the user.
  # @param username [String] The username to get history for.
  # @return [Array/String] Array of strings containing old usernames. An error
  #   string if the request failed.
  def get_username_history(username)
    response = get("http://api.fishbans.com/history/#{username}")
    if response.is_a?(String)
      return response
    else
      return response['data']['history']
    end
  end

  private
  # Performs a basic GET request.
  # @param url [String] The URL to get.
  # @return [JSON/String] The parsed JSON of the response, or the error string.
  def get(url)
    url = URI.encode(url)
    uri = URI.parse(url)
    response = @client.get(uri)
    json = JSON.parse(response.body)
    if json['success']
      return json
    else
      return json['error']
    end
  end

  # Parses a basic ban result into a formatted hash.
  # @param response [JSON] The response to parse.
  # @return [Hash/Nil] Nil if there are no bans in the response, or a hash of
  #   arrays containing the user's bans.
  def parse_generic_ban_result(response)
    ret = {}
    response['bans']['service'].each do |b, i|
      next if i['bans'] == 0
      i['ban_info'].each do |s, r|
        ret[b] = [
          i['bans'],
          { s => r }
        ]
      end
    end

    return nil if ret.empty?
    return ret
  end
end
