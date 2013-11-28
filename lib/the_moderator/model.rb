require 'active_support/concern'

module TheModerator
  module Model
    extend ActiveSupport::Concern

    included do
      has_many :moderations, as: :moderatable, dependent: :destroy
    end

    module ClassMethods
    end

    def moderate(*moderated_attributes)
      data = moderation_data(*moderated_attributes)
      moderations.build(data: {attributes: data}) unless data.empty?
    end

    def moderated?(attr_name)
      moderations.each do |moderation|
        return true if moderation.include?(attr_name)
      end
      false
    end

    def moderated_fields_for(assoc)
      moderations.map { |m| m.moderated_fields_for(assoc) }
                 .inject(&:|)
    end

    protected

    def moderation_data(*moderated_attributes)
      moderate_object moderated_attributes
    end

    private

    def moderate_object(moderated_attributes)
      object_fields = {}
      moderated_attributes.each do |attribute|
        if attribute.is_a?(Hash)
          attribute.each do |key, value|
            data = moderate_association(key, value)
            object_fields[:"#{key}_attributes"] = data unless data.empty?
          end
        elsif changed.include?(attribute.to_s)
          object_fields[attribute.to_sym] = send(attribute)
          send("#{attribute}=", changed_attributes[attribute.to_s])
        end
      end

      object_fields
    end

    def moderate_association(assoc, moderated_attributes)
      assoc_fields = {}
      objects = send(assoc)

      if respond_to?("#{assoc}_attributes=")
        if objects.is_a?(Array)
          assoc_fields = moderate_has_many_association(objects, moderated_attributes)
        else
          data = objects.moderation_data(*moderated_attributes)
          assoc_fields = data.merge(id: objects.id) unless data.empty?
        end
      end

      assoc_fields
    end

    def moderate_has_many_association(objects, moderated_attributes)
      assoc_fields = {}

      objects.each do |resource|
        data = resource.moderation_data(*moderated_attributes)
        assoc_fields[resource.id] = data.merge(id: resource.id) unless data.empty?
      end

      assoc_fields
    end
  end
end
