#!/usr/bin/env ruby
=begin
Used to create a connection to the Brightpearl API via Ruby
=end
class Connection

  attr_reader :appRef
  attr_reader :appToken
  attr_reader :dataCenter
  attr_reader :apiVersion
  attr_reader :accountID

  def initialize(appRef,appToken,accID,dataCenter,apiVersion = "public-api")
    @appRef = appRef
    @appToken = appToken
    @accountID = accID
    @apiVersion = apiVersion

    #checking if passed in datacenter is correct value, and stripping it of any format (camel case or similar)
    @dataCenter = dataCenter.downcase if dataCenter.casecmp("use") || dataCenter.casecmp("eu1")
    @dataCenter = "eu1" if dataCenter.casecmp("euw") == dataCenter
  end
  #end init

  #checks auth against warehouse service
  public
  def checkAuthorization
    uri = URI("http://ws-#{@dataCenter}.brightpearl.com/#{@apiVersion}/#{@accountID}/warehouse-service/warehouse")
    response = Net::HTTP.start(uri.host,uri.port) do |http|
      request = Net::HTTP::Get.new uri
      request.add_field('brightpearl-app-ref',@appRef)
      request.add_field('brightpearl-account-token',@appToken)

      if @apiVersion.casecmp("use") || @apiVersion.casecmp("eu1")
        http.request request
      else
        puts "Error - Invalid datacenter supplied, please enter a valid datacenter."
      end
    end
    return true unless response.nil?
  end
end