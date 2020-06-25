require_relative 'seo'

class Page
  include Seo
  extend Seo::ClassMethods
end

p Page.instance_methods
# [:meta_description=, :meta_title, :meta_description, ...
p Page.methods
# [:title, :say, ...
