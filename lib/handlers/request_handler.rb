require 'json'
require 'open-uri' #TODO- Remove this, look into replacing with Net::HTTPResponse read_body
require 'uri'
require "appLib/request"
require "appLib/request_method"
require "appLib/connection"
=begin
This class is used to handle and send requests via the Brightpearl API. It then takes the responses and adds them to the queue, and logs if necessary
TODO - Current Brightpearl Bugged issues include
TODO - Api Documentation XML has duplicate parameters in some URLs
TODO - Warehouse Location PUT having duplicate {ID} tag
TODO - Warehouse Goods-Out Note Delete having duplicate {ID} tag
TODO - Warehouse Goods note GET having duplicate {ID-SET}
TODO - Product Type Association XML POST URI malformed
TODO - Parameters need standardized
TODO - API Documentation contains invalid URIs for Developer URIs
---------------------------------------------------------------------------
=end
class RequestHandler
  attr_reader :responseQueue
  attr_reader :currentConnection
  attr_reader :requestIncrementID
  attr_reader :throttleTime
  attr_reader :requestsLeft

  public
  def initialize(appRef,appToken,accID,dataCenter,apiVersion)
    @currentConnection = Connection.new(appRef,appToken,accID,dataCenter,apiVersion)
    @requestQueue = Queue.new
    @responseQueue = Queue.new
    @throttleTime = 60000
    @requestsLeft = 200
    @requestIncrementID = 0
  end


  #Calls the Brightpearl API with passed in URI, or with a generated URI if a tailing URI is passed in (See documentation)
  #Accepts parameter array, paremeterArray[0] is the first parameter of the URI, parameterArray[1] is the second.
  #The parameters are used to specify what data you want in your uri.
  #E.G. /order-service/order/100051 would take a parameter array of Array["100051"]
  #This works with URIs with two parameters as well and should be in the form of Array["100051",20] or similar
  public
  def call(resourceURI, requestType,parameterArray = nil,postBody = nil)
    #Checks if the string includes http or https, if it does this means a full URI was passed in
    if (resourceURI.downcase["https"] || resourceURI.downcase["http"])
      requestToAdd = Request.new(@requestIncrementID,resourceURI,requestType,@currentConnection.accountID,postBody)
    else
      requestToAdd = Request.new(@requestIncrementID,buildRequestURL(resourceURI,requestType,parameterArray),requestType,@currentConnection.accountID,postBody)
    end
    addRequestToQueue(requestToAdd) if requestToAdd != nil
    @requestIncrementID += 1
  end

  #Update method, this method allows you to specify a 'delayTime' in which the function is delayed each run.
  #Default is '1', which means it will sleep 1 second after each run (running once every second where possible)
  #Empties the requestQueue and sends them as HTTP requests based on the type of method (Post, get, etc)
  #Pushes responses to responseQueue
  #TODO: Change this from 'delayTime' to implement rate limiting
  public
  def update(delayTime = 1)
    current = Thread.new do
      while @requestQueue.length > 0 do
        requestString = @requestQueue.pop
        uri = URI(requestString.uri.to_s)
        Net::HTTP.start(uri.host,uri.port) do |http|
          response = nil
          case requestString.requestType
            when 'post'
              request = Net::HTTP::Post.new uri
              request.body = requestString.requestBody
              request.add_field('brightpearl-app-ref',@currentConnection.appRef)
              request.add_field('brightpearl-account-token',@currentConnection.appToken)
              if @apiVersion.to_s.casecmp('use') || @apiVersion.to_s.casecmp('eu1')
                response = http.request request
                @requestsLeft = response['Brightpearl-Requests-Remaining']
                @throttleTime = response['Brightpearl-Next-Throttle-Period']
                @responseQueue.push(Response.new(requestString,response))
              else
                puts 'Error - Invalid datacenter supplied, please enter a valid datacenter.'
              end
            when 'get'
              request = Net::HTTP::Get.new uri
              request.add_field('brightpearl-app-ref',@currentConnection.appRef)
              request.add_field('brightpearl-account-token',@currentConnection.appToken)
              if @apiVersion.to_s.casecmp('use') || @apiVersion.to_s.casecmp('eu1')
                response = http.request request
                @requestsLeft = response['Brightpearl-Requests-Remaining']
                @throttleTime = response['Brightpearl-Next-Throttle-Period']
                @responseQueue.push(Response.new(requestString,response))
              else
                puts 'Error - Invalid datacenter supplied, please enter a valid datacenter.'
              end
            when 'patch'
              request = Net::HTTP::Patch.new uri
              request.body = requestString.requestBody
              request.add_field('brightpearl-app-ref',@currentConnection.appRef)
              request.add_field('brightpearl-account-token',@currentConnection.appToken)
              if @apiVersion.to_s.casecmp('use') || @apiVersion.to_s.casecmp('eu1')
                response = http.request request
                @requestsLeft = response['Brightpearl-Requests-Remaining']
                @throttleTime = response['Brightpearl-Next-Throttle-Period']
                @responseQueue.push(Response.new(requestString,response))
              else
                puts 'Error - Invalid datacenter supplied, please enter a valid datacenter.'
              end
            when 'put'
              request = Net::HTTP::Put.new uri
              request.body = requestString.requestBody
              request.add_field('brightpearl-app-ref',@currentConnection.appRef)
              request.add_field('brightpearl-account-token',@currentConnection.appToken)
              if @apiVersion.to_s.casecmp('use') || @apiVersion.to_s.casecmp('eu1')
                response = http.request request
                @requestsLeft = response['Brightpearl-Requests-Remaining']
                @throttleTime = response['Brightpearl-Next-Throttle-Period']
                @responseQueue.push(Response.new(requestString,response))
              else
                puts 'Error - Invalid datacenter supplied, please enter a valid datacenter.'
              end
            when 'delete'
              request = Net::HTTP::Delete.new uri
              request.body = requestString.requestBody
              request.add_field('brightpearl-app-ref',@currentConnection.appRef)
              request.add_field('brightpearl-account-token',@currentConnection.appToken)
              if @apiVersion.to_s.casecmp('use') || @apiVersion.to_s.casecmp('eu1')
                response = http.request request
                @requestsLeft = response['Brightpearl-Requests-Remaining']
                @throttleTime = response['Brightpearl-Next-Throttle-Period']
                @responseQueue.push(Response.new(requestString,response))
              else
                puts 'Error - Invalid datacenter supplied, please enter a valid datacenter.'
              end
            when 'search'
              request = Net::HTTP::Get.new uri
              request.add_field('brightpearl-app-ref',@currentConnection.appRef)
              request.add_field('brightpearl-account-token',@currentConnection.appToken)
              if @apiVersion.to_s.casecmp('use') || @apiVersion.to_s.casecmp('eu1')
                response = http.request request
                @requestsLeft = response['Brightpearl-Requests-Remaining']
                @throttleTime = response['Brightpearl-Next-Throttle-Period']
                @responseQueue.push(Response.new(requestString,response))
              else
                puts 'Error - Invalid datacenter supplied, please enter a valid datacenter.'
              end
            else
              puts 'Invalid request Type, please input a valid request Type for your request...'
          end
        end
        sleep(delayTime)
      end
    end
    current.join
  end

  #This method is meant to build a URI out of an input resource URI, the parameterName
  #and the value passed from the user/developer
  #TODO - Need to re-write this to use stuff in bp_util.rb
  public
  def buildRequestURL(resourceURI,requestType,arrayOfParameters)
    arrayOfParameters ||= Array[nil]
    if (arrayOfParameters!= nil && arrayOfParameters.is_a?(Array) == false)
      puts "Array of values not entered to build request URL, please enter an array of values"
    end
    url = 'http://ws-' << @currentConnection.dataCenter<< '.brightpearl.com/' << @currentConnection.apiVersion << '/' << @currentConnection.accountID << resourceURI
    if(requestType.to_s.casecmp('GET') || requestType.to_s.casecmp('OPTIONS') || requestType.to_s.caseCMP('POST')||  requestType.to_s.casecmp('PATCH') ||  requestType.to_s.casecmp('PUT') ||  requestType.to_s.casecmp('DELETE'))
      uriparameters = url.scan(/{.+?}/)#scans the request string for all paramaters in the URI/URL
      uriparameters.each_with_index  do |x,index| #for each paramater found we replace the value
        if index == 0
          url.gsub!(x,arrayOfParameters[0].to_s)
        elsif index == 1
          url.gsub!(x,arrayOfParameters[1].to_s)
        else
          puts "Invalid amount of paramaters specified in URL. Contact Developer/administrator as this application may need updated!"
        end
      end
    end
    return url
  end

  def checkAuthorization
    @currentConnection.checkAuthorization
  end

  #This method adds requests to the request queue
  private
  def addRequestToQueue(data)
    @requestQueue.push(data)
  end
end