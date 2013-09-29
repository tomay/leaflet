require 'dbf'
class DbfUtil
  def initialize(dbf_obj)
    @dbf = dbf_obj
  end

  def get_max(col)
    max = 0
    @dbf.each do |record|
      max = record.send col.to_sym if ((record.send col.to_sym) > max)
    end
    return max
  end




end