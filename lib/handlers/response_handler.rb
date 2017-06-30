require_relative "../appLib/response.rb"
class ResponseHandler

  attr_reader :responseHash

  public
  def initialize(responseQueue)
    @responseHash = queueToHash(responseQueue)
  end

  #Merges the inputed queue into the responseHash using the queueToHash method and the Hash's .merge method
  public
  def updateHash(queue)
    @responseHash = queueToHash(queue).merge(@responseHash)
  end

  #Clears out the response queue but is self explanatory :)
  public
  def clearResponseHash
    @responseHash.clear
  end

  #Returns a hash of Responses based on the input URI
  public
  def getResponsesByURI(uri)
    returnHash = Hash.new
    @responseHash.each do |index,value|
      if value.getRequestURI.to_s.casecmp(uri)
        returnHash[index] = value
      end
    end
    returnHash
  end

  private
  def clearResponsesByURI(uri)
    #TODO: Not implemented
  end

  public
  def listResponses
    @responseHash.each do |key,value|
      puts "Request ID: #{key} had a response code of #{value.code}, response body of #{value.body}, response message of #{value.msg}"
      puts "For URI: #{value.getRequestURI}, and Post Body: #{value.getPostBody}"
    end
  end

  #Adds responses into a hash. The Key is the Request ID of the request that was made that gave the response (Should be unique), the value is the response object.
  private
  def queueToHash(queue)
    returnHash = Hash.new
    current = Thread.new do
      while queue.length > 0
        response = queue.pop
        returnHash[response.getRequestID] = response
      end
    end
    current.join
    returnHash
  end

end