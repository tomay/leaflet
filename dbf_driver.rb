# dbf_driver.rb
$LOAD_PATH << "."
require 'dbf_util'

dbf = DBF::Table.new("richlemur.dbf")

dbf_util = DbfUtil.new(dbf)
currmax = dbf_util.get_max("curr")