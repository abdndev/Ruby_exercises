class Settings
  def initialize
    yield @obj
  end
  def method_missing(name)
    @obj.send(name) if @obj.respond_to? name
  end
end
