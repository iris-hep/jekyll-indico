# frozen_string_literal: true

require 'yaml'

RSpec.describe JekyllIndico do
  it 'has a version number' do
    expect(JekyllIndico::VERSION).not_to be nil
  end

  context 'with a CERN topical meeting' do
    before :all do
      @meeting = JekyllIndico::Meetings.new('https://indico.cern.ch', 10570, timeout: 120, limit: 20)
    end

    it 'has expected meetings' do
      expect(@meeting.dict).to include('20190128')
      expect(@meeting.dict).to include('20200127')
    end

    %w[name startdate meetingurl location youtube description].each do |name|
      it "has a #{name} field" do
        expect(@meeting.dict['20190128']).to include(name)
      end
    end

    it 'has expected contents' do
      expect(@meeting.dict['20200909']['name']).to eq('Using GPUs and FPGAs as-a-service for LHC computing')
      expect(@meeting.dict['20200909']['youtube']).to eq('https://youtu.be/26YXz0fzMNQ')
    end
  end

  context 'with multiple meetings on the same day' do
    def result(id, title)
      {
        'id' => id,
        'title' => title,
        'description' => '<p>A meeting</p>',
        'startDate' => { 'date' => '2024-03-04' },
        'url' => "https://indico.cern.ch/event/#{id}/",
        'location' => 'CERN'
      }
    end

    it 'keeps both meetings, disambiguated by event id' do
      dict = JekyllIndico::Meetings.build([result('111', 'First'), result('222', 'Second')])
      expect(dict.keys).to contain_exactly('20240304', '20240304-222')
      expect(dict['20240304']['name']).to eq('First')
      expect(dict['20240304-222']['name']).to eq('Second')
    end
  end
end
