require 'spec_helper'

describe TheModerator::Model do
  describe '#moderate' do
    it 'moderates simple field' do
      page = Page.new(name: 'Name', content: 'Content')
      page.moderate(:name)

      expect(page.moderations).to have(1).moderation
      expect(page.moderations.first.data[:attributes]).to include(name: 'Name')
      expect(page.name).to be_nil
      expect(page.content).to eq('Content')
    end

    it 'moderates association fields' do
      category = Category.new(name: 'category')
      category.create_page
      category.save

      category.attributes = {page_attributes: {
        name: 'name', content: 'content', id: category.page.id}}
      category.moderate(page: :name)

      expect(category.moderations).to have(1).moderation
      expect(category.moderations.first.data[:attributes])
        .to include(page_attributes: {name: 'name', id: category.page.id})
      expect(category.page.name).to be_nil
    end

    it 'moderates has_many associations' do
      page = Page.new(name: 'page')
      page.save
      link = page.links.create

      page.attributes = {links_attributes: [{id: link.id, name: 'link'}]}
      page.moderate(links: [:name])

      expect(page.moderations).to have(1).moderation
      expect(page.moderations.first.data[:attributes])
        .to include(links_attributes: {link.id => {name: 'link', id: link.id}})
      expect(link.name).to be_nil
    end
  end

  describe '#moderated?' do
    it 'detects moderated field' do
      page = Page.new(name: 'Name', content: 'Content')
      page.moderate(:name)

      expect(page.moderated?(:name)).to be_true
      expect(page.moderated?(:content)).to be_false
    end
  end
end
