#The Request Method class is a class used to hold data pulled from http://api-docs.brightpearl.com/json-index.html
class RequestMethod
  attr_reader :name
  attr_reader :service
  attr_reader :resource
  attr_reader :HTTPMethod
  attr_reader :uri
  attr_reader :responses
  attr_reader :apiDomain
  attr_reader :urls
  attr_reader :authorizeServer
  attr_reader :authorizeInstance
  attr_reader :requests

  public
  def initialize(name,service,resource,httpMethod,uri,responses,apiDomain,urls,authorizeServer,authorizeInstance,requests)
    @name = name
    @service = service
    @resource = resource
    @HTTPMethod = httpMethod
    @uri = uri
    @responses = responses
    @apiDomain = apiDomain
    @urls = urls
    @authorizeServer = authorizeServer
    @authorizeInstance = authorizeInstance
    @requests = requests
  end



end