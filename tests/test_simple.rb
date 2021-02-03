require 'test/unit'

require 'jekyll-indico'

class TestSimple < Test::Unit::TestCase
  def test_simple_load_topical
    meeting = JekyllIndico::Meetings.new 10570
    assert_includes meeting.dict, "1234"
  end
end
