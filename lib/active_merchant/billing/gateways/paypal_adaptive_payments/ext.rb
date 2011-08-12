# fix for case sensitive headers in paypal (issue #1)
module Net
  module HTTPHeader
    def []= key, val
      unless val
        @header.delete key
        return val
      end
      @header[key] = [val]
    end
  end
end
