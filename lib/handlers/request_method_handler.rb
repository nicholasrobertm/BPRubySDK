require_relative '../applib/request_method'
require 'open-uri'
require 'json'
class RequestMethodHandler

  public
  def initialize
    @requestMethods = generateRequestMethods()
  end

  #Gets the supplied request method object by a passed in resource,
  #and methodType(Get,post,put, etc)if not null, if no methodType is passed in it will return the first result
  public
  def getRequestMethodByResource(resource,methodType = nil)
    if methodType == nil
      if @requestMethods[resource] != nil
        return @requestMethods[resource]
      end
    else
      @requestMethods.detect {|k,v| return v if v.resource == resource && v.HTTPMethod.to_s.casecmp(methodType.to_s) == 0}
    end
  end

  #Returns the request methods URI from an input resource
  #Optional parameter of service type to allow you to specify which resource service type you want (Get,Post,put,etc)
  public
  def getRequestMethodURI(resource,methodType = nil)
    if methodType == nil
      if @requestMethods[resource] != nil
        puts "Resourced found by name of #{resource}"
        return @requestMethods[resource].uri
      else
        puts "No Resource Found by the name of #{resource}"
      end
    else
      @requestMethods.detect {|k,v| return v.uri if v.resource == resource && v.HTTPMethod.to_s.casecmp(methodType.to_s) == 0}
    end
  end


  #This method Gets the given request parameters by resource and returns a hash with all the parameters.
  #Has optional methodType paramater to only return resource of a certain method type (Post,put, etc)
  #Returned keys in hash are: name,service, method,uri,response,apiDomain,urls,authorizeServer,authorizeInstance,requests
  public
  def getRequestParemetersByResource(resource,methodType = nil)
    if methodType == nil
      @requestMethods.each do |index,val|
        if resource.to_s.casecmp(index) == 0
          parameterHash =
              {
                  "name" => val.instance_variable_get(:@name),
                  "service" => val.instance_variable_get(:@service),
                  "HTTPMethod" => val.instance_variable_get(:@HTTPMethod),
                  "uri" => val.instance_variable_get(:@uri),
                  "response" => val.instance_variable_get(:@response),
                  "apiDomain" => val.instance_variable_get(:@apiDomain),
                  "urls" => val.instance_variable_get(:@urls),
                  "authorizeServer" => val.instance_variable_get(:@authorizeServer),
                  "authorizeInstance" => val.instance_variable_get(:@authorizeInstance),
                  "requests" => val.instance_variable_get(:@requests)
              }
          return parameterHash if parameterHash != nil
        else
          #Resource doesn't match, continue to loop
        end
      end

      puts "No matching Resource, please input a valid resource. To list resources use listRequestMethodsByResource()"
    else
      @requestMethods.detect do |key,val|
        if val.resource == resource && val.HTTPMethod.to_s.casecmp(methodType.to_s) == 0
          parameterHash =
              {
                  "name" => val.instance_variable_get(:@name),
                  "service" => val.instance_variable_get(:@service),
                  "@HTTPMethod" => val.instance_variable_get(:@HTTPMethod),
                  "uri" => val.instance_variable_get(:@uri),
                  "response" => val.instance_variable_get(:@response),
                  "apiDomain" => val.instance_variable_get(:@apiDomain),
                  "urls" => val.instance_variable_get(:@urls),
                  "authorizeServer" => val.instance_variable_get(:@authorizeServer),
                  "authorizeInstance" => val.instance_variable_get(:@authorizeInstance),
                  "requests" => val.instance_variable_get(:@requests)
              }
          return parameterHash if parameterHash != nil
        else
          #Resource doesn't match, continue to loop
        end
      end
      puts 'No matching Resource, please input a valid resource. To list resources use listRequestMethodsByResource()'
    end
  end

  #Returns an array of request methods with input method type, example arguments are ('get','post',etc)
  def getRequestMethodsOfType(type)
    vals = Array.new
    @requestMethods.each do |index,val|
      if type.to_s.casecmp('all') == 0
        vals << val
      else
        if type.to_s.casecmp('get')
          if val.HTTPMethod == 'get' || val.HTTPMethod == 'GET'
            vals << val
          end
        end
      end
    end
    vals
  end

  #Lists current request methods
  #(Generated from generateRequestMethods, which pulls from http://api-docs.brightpearl.com/json-index.html)
  #Defaults to show 'all' possible request methods
  #allows a resource to be passed to show only a given request method's parameters
  #EX listRequestMethodsByResource('zone')
  #Option parameter of method type to only list resources of a given method type (Post,put,etc)
  public
  def listRequestMethodsByResource(resource = 'all',methodType = nil)
    if methodType == nil
      @requestMethods.each do |index,val|
        if resource.to_s.casecmp('all') == 0
          puts "---------------------------------------------------------------------------------------"
          puts "Resource: #{val.instance_variable_get(:@resource)}"
          puts "Name: #{val.instance_variable_get(:@name)}"
          puts "Service: #{val.instance_variable_get(:@service)}"
          puts "Method: #{val.instance_variable_get(:@HTTPMethod)}"
          puts "URI: #{val.instance_variable_get(:@uri)}"
          puts "Response: #{val.instance_variable_get(:@response)}"
          puts "API Domain: #{val.instance_variable_get(:@apiDomain)}"
          puts "URLs: #{val.instance_variable_get(:@urls)}"
          puts "Authorize Server: #{val.instance_variable_get(:@authorizeServer)}"
          puts "Authorize Instance: #{val.instance_variable_get(:@authorizeInstance)}"
          puts "Requests: #{val.instance_variable_get(:@requests)}"
          puts "---------------------------------------------------------------------------------------\n\n"
        else
          if resource.to_s.casecmp(val.instance_variable_get(:@resource)) == 0
            puts "---------------------------------------------------------------------------------------"
            puts "Resource: #{val.instance_variable_get(:@resource)}"
            puts "Name: #{val.instance_variable_get(:@name)}"
            puts "Service: #{val.instance_variable_get(:@service)}"
            puts "Method: #{val.instance_variable_get(:@HTTPMethod)}"
            puts "URI: #{val.instance_variable_get(:@uri)}"
            puts "Response: #{val.instance_variable_get(:@response)}"
            puts "API Domain: #{val.instance_variable_get(:@apiDomain)}"
            puts "URLs: #{val.instance_variable_get(:@urls)}"
            puts "Authorize Server: #{val.instance_variable_get(:@authorizeServer)}"
            puts "Authorize Instance: #{val.instance_variable_get(:@authorizeInstance)}"
            puts "Requests: #{val.instance_variable_get(:@requests)}"
            puts "---------------------------------------------------------------------------------------\n\n"
          end
        end
      end
    else
      @requestMethods.each do |index,val|
        if resource.to_s.casecmp('all') == 0 && val.HTTPMethod.to_s.casecmp(methodType.to_s) == 0
          puts "---------------------------------------------------------------------------------------"
          puts "Resource: #{val.instance_variable_get(:@resource)}"
          puts "Name: #{val.instance_variable_get(:@name)}"
          puts "Service: #{val.instance_variable_get(:@service)}"
          puts "Method: #{val.instance_variable_get(:@HTTPMethod)}"
          puts "URI: #{val.instance_variable_get(:@uri)}"
          puts "Response: #{val.instance_variable_get(:@response)}"
          puts "API Domain: #{val.instance_variable_get(:@apiDomain)}"
          puts "URLs: #{val.instance_variable_get(:@urls)}"
          puts "Authorize Server: #{val.instance_variable_get(:@authorizeServer)}"
          puts "Authorize Instance: #{val.instance_variable_get(:@authorizeInstance)}"
          puts "Requests: #{val.instance_variable_get(:@requests)}"
          puts "---------------------------------------------------------------------------------------\n\n"
        else
          if resource.to_s.casecmp(val.instance_variable_get(:@resource)) == 0  && val.HTTPMethod.to_s.casecmp(methodType.to_s) == 0
            puts "---------------------------------------------------------------------------------------"
            puts "Resource: #{val.instance_variable_get(:@resource)}"
            puts "Name: #{val.instance_variable_get(:@name)}"
            puts "Service: #{val.instance_variable_get(:@service)}"
            puts "Method: #{val.instance_variable_get(:@HTTPMethod)}"
            puts "URI: #{val.instance_variable_get(:@uri)}"
            puts "Response: #{val.instance_variable_get(:@response)}"
            puts "API Domain: #{val.instance_variable_get(:@apiDomain)}"
            puts "URLs: #{val.instance_variable_get(:@urls)}"
            puts "Authorize Server: #{val.instance_variable_get(:@authorizeServer)}"
            puts "Authorize Instance: #{val.instance_variable_get(:@authorizeInstance)}"
            puts "Requests: #{val.instance_variable_get(:@requests)}"
            puts "---------------------------------------------------------------------------------------\n\n"
          end
        end
      end
    end
  end


  #This Generates all possible request methods to the Brightpearl API and loads them into the @requestMethods hash.
  #The Request methods have their own class so each part of the data (Name, resource, URI, etc) can be read.
  #Needed to run in the INIT method for other functions in request_method_handler.rb to work
  private
  def generateRequestMethods
    #TODO - rewrite this not using open-uri
    json = open('http://api-docs.brightpearl.com/json-index.html').read
    #puts json
    temp_hash = Hash.new()
    data_hash = JSON.parse(json)      #Each value in the hash                     #(name,service,resource,method,uri,responses,apiDomain,urls,authorizeServer,authorizeInstance,requests)
    data_hash.each_with_index { |val,index| temp_hash.store(val, RequestMethod.new(data_hash[index]['name'],data_hash[index]['service'],data_hash[index]['resource'],data_hash[index]['method'],data_hash[index]['uri'],data_hash[index]['responses'],data_hash[index]['apiDomain'],data_hash[index]['urls'],data_hash[index]['authorizeServer'],data_hash[index]['authorizeInstance'],data_hash[index]['requests']))} #RequestMethod.new(data_hash[x]['name'].to_s,data_hash[x]['service'].to_s,data_hash[x]['resource'].to_s,data_hash[x]['method'].to_s,data_hash[x]['uri'].to_s,data_hash[x]['responses'].to_s,data_hash[x]['apiDomain'].to_s,data_hash[x]['urls'].to_s,data_hash[x]['authorizeServer'].to_s,data_hash[x]['authorizeInstance'].to_s,data_hash[x]['requests'].to_s)
    temp_hash
  end


end