module Util
  require 'json'
  require 'csv'

  def Util.JsonToCSV(json,outputCSV)
    file = json
    hash = JSON.parse(file)

    in_array = Array.new

    hash['response'].each do |h|
      case h
        when Array
          in_array << h.each {|x| x.each {|y| in_array << nils_to_strings(DeepSearch(y)) if y.is_a? Hash} if x.is_a? Array}
        when Hash
          in_array << nils_to_strings(DeepSearch(h))
        else
          puts 'ERROR'
        #this should never run
      end
    end

    nonMergedKeys = Array.new
    keyz = Array.new

    #Use the output array from running a deep search on each request to generate a list of the rows
    in_array.each_with_index do |row,index|
      nonMergedKeys << row.keys if row.is_a? Hash
    end

    #Takes the keyz of every row of a query (Since they may be different) and merges them into a single array
    nonMergedKeys.each do |x|
      keyz += x
    end
    keyz.uniq! #Removes the duplicate keys from that array

    #Begins writing the data to a CSV file inputed. Writes headers first then loops through data writing to file (Blank string for any nils)
    headers_written = false
    CSV.open(outputCSV, 'w') do |csv|
      csv << keyz if headers_written==false
      headers_written = true
      in_array.each_with_index do |value,index|
        inserted = Array.new
        value.each_with_index do |val,key|
          inserted[keyz.index(val[0])] = nils_to_strings(val[1])
        end
        csv << inserted
      end
    end
  end


  def Util.DeepSearch(object, path='')
    scalars = [String, Integer, Fixnum, FalseClass, TrueClass]
    columns = {}
    if [Hash, Array].include? object.class
      object.each do |k, v|
        new_columns = DeepSearch(v, "#{path}#{k}/") if object.class == Hash
        new_columns = DeepSearch(k, "#{path}#{k}/") if object.class == Array
        columns = columns.merge new_columns
      end
      return columns
    elsif scalars.include? object.class
      # Remove trailing slash from path
      end_path = path[0, path.length - 1]
      columns[end_path] = object
      return columns
    else
      return {}
    end
  end

  def Util.nils_to_strings(hash)
    case hash
      when Hash
        hash.each_with_object({}) do |(k,v), object|
          case v
            when Hash
              object[k] = nils_to_strings v
            when nil
              object[k] = ''
            else
              object[k] = v
          end
        end
      when Array
        hash.each do |x|
          case x
            when Array
              x.each do |y|
                nils_to_strings y
              end
            when nil
              x = ""
            else
              x = x
          end
        end
        return hash
      when nil
        hash = ""
      else
        hash
    end
  end

  def Util.getInnerHashValues(hash)
    tempHash = Hash.new
    if hash.respond_to?(:each) || hash.is_a?(Array) || hash.is_a?(Hash)
      hash.each do |key,value|
        case key
          when Array
            key.each do |x|
              getInnerHashValues(x)
            end
          when Hash
            key.each do |x|
              getInnerHashValues(x)
            end
          else
            tempHash[key] = value unless value.nil? || key.nil?
        end

        case value
          when Array
            value.each do |x|
              getInnerHashValues(x)
            end
          when Hash
            value.each do |x|
              getInnerHashValues(x)
            end
          else
            tempHash[key] = value unless value.nil? || key.nil?
        end

      end
    else
      tempHash[key] = value
    end
  end

end