require 'spec_helper'

describe TheModerator::ModerationModel do
  subject do
    page = Page.new(name: 'Name', content: 'Content')
    moderation = page.moderate(:name)
    page.save

    moderation
  end

  describe '#accept' do
    it 'accepts moderated data' do
      expect(subject.moderatable.name).to be_nil
      subject.accept

      expect(subject.moderatable.name).to eq('Name')
      expect(subject.destroyed?).to be true
    end
  end

  describe '#discard' do
    it 'discards moderated data' do
      expect(subject.moderatable.name).to be_nil
      subject.discard

      expect(subject.moderatable.name).to be_nil
      expect(subject.destroyed?).to be true
    end
  end

  describe '#preview' do
    it 'previews moderated data' do
      expect(subject.moderatable.name).to be_nil
      preview = subject.preview

      expect(preview.frozen?).to be true
      expect(preview.name).to eq('Name')
    end
  end

  describe '#include?' do
    it 'includes name' do
      expect(subject.include?(:name)).to be true
      expect(subject.include?(:content)).to be false
    end
  end
end
