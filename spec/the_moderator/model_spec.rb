require 'spec_helper'

describe TheModerator::Model do
  subject { Page.new(name: 'Name', content: 'Content') }

  describe '#moderate' do
    it 'moderates simple field' do
      subject.moderate(:name)

      expect(subject.moderations).to have(1).moderation
      expect(subject.name).to be_nil
      expect(subject.content).to eq('Content')
    end
  end

  describe '#moderated?' do
    it 'detects moderated field' do
      subject.moderate(:name)

      expect(subject.moderated?(:name)).to be_true
      expect(subject.moderated?(:content)).to be_false
    end
  end
end
