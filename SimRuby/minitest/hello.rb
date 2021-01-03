require 'minitest/autorun'

class Hello
  def say(str)
  end
end

class TestHello < MiniTest::Unit::TestCase
  def setup
    @object = Hello.new
  end

  def test_that_hello_return_a_string
    assert_instance_of String, @obj.say('test')
  end
end


