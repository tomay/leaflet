module Color
  class Ramp

    def initialize(h)
      #@low = h[:low] # => [r,g,b]
      #@hi = h[:hi] # => [r,g,b]
      h.each {|k,v| instance_variable_set("@#{k}",v)}
      # equivalent to: @n = h[:n]
      @hi_r = @hi[0]
      @hi_g = @hi[1]
      @hi_b = @hi[2]
      @low_r = @low[0]
      @low_g = @low[1]
      @low_b = @low[2]
    end

    def ramp
      r_range = (@hi_r - @low_r).abs
      g_range = (@hi_g - @low_g).abs
      b_range = (@hi_b - @low_b).abs

      r_inc = (r_range / @n.to_f)
      g_inc = (g_range / @n.to_f)
      b_inc = (b_range / @n.to_f)

      r = @low_r
      g = @low_g
      b = @low_b

      @rgb_output = []
      (0..@n).each_with_index {|n, i|
        if i > 0
          @hi_r > @low_r ? (r+= r_inc) : (r-= r_inc)
          @hi_g > @low_g ? (g+= g_inc) : (g-= g_inc)
          @hi_b > @low_b ? (b+= b_inc) : (b-= b_inc)
          #puts "#{r}, #{g}, #{b}"
          #puts convert_to_hex(r,g,b)
        end
        r_int, g_int, b_int = r.to_i, g.to_i, b.to_i
        #p "#{r_int}, #{g_int}, #{b_int}"
        #p convert_to_hex(r_int,g_int,b_int)
        @rgb_output << [r_int,g_int,b_int]
      }
      return @rgb_output
    end

    def convert_to_hex(r,g,b)
      @hex_output = ""
      [r,g,b].each {|dec|

        ahex = dec.to_s(16).upcase
        ahex = "0#{ahex}" if dec <= 10
        @hex_output += ahex
      }
      return "##{@hex_output}"
    end

    def print(output)
      output.each

    end
  end
end


# 255,0,128
# 13
# 0,255,128
# 12
# 0,0,255

# load '/home/tomay/Desktop/DBC/leaflet/mada/color.rb'

# c = Color::Ramp.new({:low_r => 255, :low_g => 0, :low_b => 127, :hi_r => 0, :hi_g => 255, :hi_b => 128, :n => 13})
# c.ramp

# RgbToHex.new(255, 0, 127).convert
# RgbToHex.new(236, 19, 127).convert
# RgbToHex.new(217, 38, 127).convert
# RgbToHex.new(198, 57, 127).convert
# RgbToHex.new(179, 76, 127).convert
# RgbToHex.new(, 95, 127).convert
# RgbToHex.new(141, 114, 127).convert
# RgbToHex.new(122, 133, 127).convert
# RgbToHex.new(103, 152, 127).convert
# RgbToHex.new(84, 171, 127).convert
# RgbToHex.new(65, 190, 127).convert
# RgbToHex.new(46, 209, 127).convert
# RgbToHex.new(27, 228, 127).convert
# RgbToHex.new(8, 247, 127).convert


## some driver code for irb
# load '/home/tomay/Desktop/DBC/leaflet/mada/color.rb'
# c = Color::Ramp.new({:low_r => 255, :low_g => 0, :low_b => 128, :hi_r => 0, :hi_g => 255, :hi_b => 128, :n => 5})
# out = c.ramp

# hex3 = []
# out.each {|color| hex3 << c.convert_to_hex(color[0],color[1],color[2])}
# hex3




