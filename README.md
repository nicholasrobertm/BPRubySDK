# BPRubySDK

This project is a ruby wrapper to the Brightpearl API. It's meant to allow the developer quick access to any calls available, and provides useful functions for handling the data sent/received. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'BPRubySDK'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install BPRubySDK

## Usage

Starting an app consists of three available classes.

**RequestMethodHandler**

Allows you to get a list of all current possible Requests, and their metadata.
Initialized with **rmh = RequestMethodHandler.new()** (No parameters)

**RequestMethodHandler** offers 4 methods

**getRequestMethodByResource(resourceNameString,methodType = nil)**

    Gets the supplied request method object by a passed in resource,
    and methodType (GET,POST,PUT,etc)if not null, if no methodType is passed in it will return the first result

**getRequestMethodURI(resourceNameString,methodType = nil)**

    Returns the request methods URI from an input resource
    Optional parameter of service type to allow you to specify which resource service type you want (GET,POST,PUT,etc)

**getRequestParemetersByResource(resourceNameString,methodType = nil)**

    This method Gets the given request parameters by resource and returns a hash with all the parameters.
    Has optional methodType paramater to only return resource of a certain method type (GET,POST,PUT,etc)
    **Returned keys in hash are: name,service, method,uri,response,apiDomain,urls,authorizeServer,authorizeInstance,requests**

**listRequestMethodsByResource(resourceNameString = 'all',methodType = nil)**

    Lists current request methods
    Defaults to show 'all' possible request methods
    allows a resource to be passed to show only a given request method's parameters
    EX listRequestMethodsByResource('zone')
    Option parameter of method type to only list resources of a given method type (GET,POST,PUT,etc)

**RequestHandler**

Provides the ability to make calls to the Brightpearl API. Puts calls in a queue which you can run as needed
Initialized with rh = RequestHandler.new(appRef,appToken,accID,dataCenter,apiVersion)

**appRef** = The App References from the app created in Brightpearl
**appToken** = The token from the app created in Brightpearl
**accID** = The Brightpearl account ID calls are made with
**dataCenter** = The Datacenter the account is found on (Found in your URL when logged in, should be euw or use/use1)
**apiVersion** = The version of the API you wish to use, defaults to 'public-api'

**RequestHandler** offers 3 methods

**call(resourceURI, requestType,parameterArray = nil,postBody = nil)**

    Puts a call in the queue to be made to the Brightpearl API, can be called with a full URI, or with a generated URI(From RequestMethodHandler) if a tailing URI is passed in
    Accepts parameter array, paremeterArray[0] is the first parameter of the URI, parameterArray[1] is the second.
    The parameters are used to specify what data you want in your uri.
    E.G. /order-service/order/100051 would take a parameter array of Array["100051"]
    This works with URIs with two parameters as well and should be in the form of Array["100051",20] or similar
    
    The parameters for this are what the RequestMethodHandler returns.
    
**update(delayTime = 1)**

    Update method, this method allows you to specify a 'delayTime' in which the function is delayed each run.
    Default is '1', which means it will sleep 1 second after each run (running once every second where possible)
    Empties the requestQueue and sends them as HTTP requests based on the type of method (Post, get, etc)
    Pushes responses to responseQueue

**buildRequestURL(resourceURI,requestType,arrayOfParameters)**

    This method is meant to build a URI out of an input resource URI, the parameterName
    and the value passed from the user/developer

**ResponseHandler**

    This class provides methods to handle responses from the Brightpearl API.
    
**updateHash(queue)**

    This method updates the ResponseHandler's hash of responses with another

**clearResponseHash()**

    This method clears out all the responses in the queue
    
**getResponsesByURI(uri)**

    This method returns a hash of responses based on the input URI
    
**listResponses**

    This method lists all responses in the queue, and their metadata
    
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xaviarrob/BPRubySDK. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).