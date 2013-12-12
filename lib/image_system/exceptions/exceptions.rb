module Exceptions
  class AlreadyExistsException < Exception
  end

  class CdnResponseException < Exception
  end

  class CdnUnknownException < Exception
  end

  class NotFoundException < Exception
  end
end
