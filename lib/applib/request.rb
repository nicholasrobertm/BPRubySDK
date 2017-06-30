#Container class used to store a ready to send request while adding to the request queue.
class Request

  attr_reader :id
  attr_reader :uri
  attr_reader :accountID
  attr_accessor :requestType
  attr_accessor :requestBody
  attr_accessor :response
  attr_accessor :httpCode

  public
  def initialize(id,uri,requestType,accountID,requestBody = nil)
    @id = id
    @uri = uri
    @requestType = requestType
    @accountID = accountID
    @requestBody = requestBody
  end
end