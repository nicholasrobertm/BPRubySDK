class Response
  attr_reader :body
  attr_reader :code
  attr_reader :msg
  attr_reader :request

  public
  def initialize(request,response)
    @request = request
    @body = response.body
    @code = response.code
    @msg = response.msg
  end

  public
  def getRequestID
    return @request.id
  end

  public
  def getRequestURI
    return @request.uri
  end

  public
  def getPostBody
    return @request.requestBody if @request.requestType.to_s.casecmp('post')
    return "This is not a post method."
  end
end