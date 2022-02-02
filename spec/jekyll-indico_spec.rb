# frozen_string_literal: true

require 'yaml'

RSpec.describe JekyllIndico do
  it 'has a version number' do
    expect(JekyllIndico::VERSION).not_to be nil
  end

  context 'with a CERN topical meeting' do
    before :all do
      @meeting = JekyllIndico::Meetings.new('https://indico.cern.ch', 10570, timeout: 120)
    end

    it 'has expected meetings' do
      expect(@meeting.dict).to include('20190128')
      expect(@meeting.dict).to include('20200127')
    end

    %w[name startdate meetingurl location youtube description].each do |name|
      it "has a #{name} field" do
        expect(@meeting.dict['20190128']).to include('name')
        expect(@meeting.dict['20190128']).to include('startdate')
        expect(@meeting.dict['20190128']).to include('meetingurl')
      end
    end

    it 'has expected contents' do
      expect(@meeting.dict['20200909']['name']).to eq('Using GPUs and FPGAs as-a-service for LHC computing')
      expect(@meeting.dict['20200909']['youtube']).to eq('https://youtu.be/26YXz0fzMNQ')
    end
  end
end
