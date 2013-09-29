class StyleEditor
  require 'nokogiri'

  def initialize(args)
    # expects
    # @infile = args[:infile]
    # @cuts = args[:cuts] => [3,5,7,9,10,12]
    # @colors = args[:colors] => [#8080FE, #FF0080, ...]
    # @attribute = args[:attribute] => "curr"
    # @outfile = args[:outfile]
    args.each {|k,v| instance_variable_set("@#{k}",v)}

  end

  def open
    @f = File.open(@infile)
    @doc = Nokogiri::XML(@f, &:noblanks)
  end

  def edit
    # first delete existing rule elements in Style node
    # ruleset = @doc.search("//Style //Rule"). # assumes one shapefile?
    # ruleset.size.times do
    #   ruleset.delete(ruleset.last)
    # end
    @doc.search("//Style //Rule").remove

    @colors.reverse! # hi > lo
    @cuts.reverse! # [3,2,1]
    @cuts.unshift(@cuts.first) # [3,3,2,1]
    @cuts.each_with_index {|cut, i|
      rule = Nokogiri::XML::Node.new "Rule", @doc
      filt = Nokogiri::XML::Node.new "Filter", @doc

      content = "[#{@attribute}] "

      case i
      when 0 # first one
        content += ">= #{cut}"
      when @cuts.size - 1 #last one
        content += "<= #{cut}"
      else
        content += "<= #{cut} and [#{@attribute}] >= #{@cuts[i + 1]}"
      end

      filt.content = content

      poly = Nokogiri::XML::Node.new "PolygonSymbolizer", @doc
      poly["fill"] = @colors[i]

      puts poly.to_xml

      rule << filt
      rule << poly

      body = @doc.at_css("Style")
      body << rule
    }
  end

  def save
    File.open(@outfile, 'w') { |f| f.print(@doc.to_xml) }
  end


end