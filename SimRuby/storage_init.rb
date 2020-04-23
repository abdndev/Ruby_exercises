class Storage
  attr_accessor :params

  def initialize
    @params = {}
  end

  def method_missing(name, *args)
    p name
  end
end
