require '/home/tomay/Desktop/DBC/leaflet/color'
require '/home/tomay/Desktop/DBC/leaflet/styles_edit'
require 'rinruby'

# Get splits from R and shapefile dbf
R.eval <<EOF
  require(foreign)
  x <- read.dbf("mada/richlemur.dbf")

  library(classInt)

  ints_curr = classIntervals(x[,2], n = 6, style = "kmeans", dataPrecision = 0)
  ints_a2100 = classIntervals(x[,3], n = 6, style = "kmeans", dataPrecision = 0)
  ints_b2100 = classIntervals(x[,4], n = 6, style = "kmeans", dataPrecision = 0)

  a = ints_curr$brks
  b = ints_a2100$brks
  c = ints_b2100$brks

EOF

cuts_curr = R.a.map{|n| n.round}
cuts_2100a = R.b.map{|n| n.round}
cuts_2100b = R.c.map{|n| n.round}

cuts_curr.shift
cuts_2100a.shift
cuts_2100b.shift

# Start
#########################################################
## CURR
# Get color ramps
colors = Color::Ramp.new({
          :low => [153,230,153],
          :hi => [10,41,10],
          :n => 7
         })

out = colors.ramp
hex = []
out.each {|color| hex << colors.convert_to_hex(color[0],color[1],color[2])}

style = StyleEditor.new({
          :infile => "/home/tomay/Desktop/DBC/leaflet/mada/richlemur.xml",
          :colors => hex,
          :attribute => "curr",
          :cuts => cuts_curr, # from R
          :outfile => "/home/tomay/Desktop/DBC/leaflet/mada/curr.xml"
        })
style.open
style.edit
style.save

##########################################################
## a2100
# Get color ramps
colors = Color::Ramp.new({
          :low => [204, 204, 255],
          :hi => [0,0,76],
          :n => 6
         })

out = colors.ramp
hex2 = []
out.each {|color| hex2 << colors.convert_to_hex(color[0],color[1],color[2])}

style = StyleEditor.new({
          :infile => "/home/tomay/Desktop/DBC/leaflet/mada/richlemur.xml",
          :colors => hex2,
          :attribute => "a2100",
          :cuts => cuts_2100a, # from R
          :outfile => "/home/tomay/Desktop/DBC/leaflet/mada/a2100.xml"
        })

style.open
style.edit
style.save

##########################################################
## b2100
# Get color ramps
colors = Color::Ramp.new({
          :low => [255, 230, 230],
          :hi => [76, 0, 0],
          :n => 6
         })

out = colors.ramp
hex3 = []
out.each {|color| hex3 << colors.convert_to_hex(color[0],color[1],color[2])}

style = StyleEditor.new({
          :infile => "/home/tomay/Desktop/DBC/leaflet/mada/richlemur.xml",
          :colors => hex3,
          :attribute => "b2100",
          :cuts => cuts_2100b, # from R
          :outfile => "/home/tomay/Desktop/DBC/leaflet/mada/b2100.xml"
        })

style.open
style.edit
style.save
