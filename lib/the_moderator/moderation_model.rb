require 'active_support/concern'

module TheModerator
  module ModerationModel
    extend ActiveSupport::Concern

    included do
      belongs_to :moderatable, polymorphic: true
      serialize :data
    end

    module ClassMethods
    end

    def accept
      self.class.transaction do
        destroy
        moderatable.update_attributes(data)
      end
    end

    def accept!
      accept || raise(TheModerator::ModerationNotAccepted)
    end

    def discard
      destroy
    end

    def preview
      preview = moderatable.clone
      preview.attributes = data
      preview.freeze
    end

    def parsed_data
      data
    end

    def include?(attribute)
      include_attribute?(attribute, data[:attributes])
    end

    def moderated_fields_for(assoc)
      (data[:attributes][assoc].try(:keys) || []) - [:id]
    end

    private

    def include_attribute?(attribute, attr_data)
      return false if attr_data.nil?
      if attribute.is_a?(Hash)
        include_assoc?(attribute, attr_data)
      else
        attr_data.keys.include?(attribute)
      end
    end

    def include_assoc?(attribute, assoc_data)
      include_attribute?(attribute.first.last,
                         assoc_data[attribute.first.first])
    end
  end
end
