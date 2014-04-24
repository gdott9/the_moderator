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
      moderations.build(data: {attributes: data[:data]},
                        data_display: data[:data_display]) unless data.empty?
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
      object_fields, object_fields_display = {}, {}

      moderated_attributes.each do |attribute|
        if attribute.is_a?(Hash)
          attribute.each do |key, value|
            data = moderate_association(key, value)
            object_fields[:"#{key}_attributes"] = data[:data] unless data[:data].empty?
            object_fields_display.merge!(data[:data_display]) unless data[:data_display].empty?
          end
        elsif changed.include?(attribute.to_s)
          object_fields[attribute.to_sym] = send(attribute)
          class_name ||= self.class.name.to_sym
          object_fields_display[class_name] ||= {}
          object_fields_display[class_name].merge!(attribute.to_sym => send(attribute))
          send("#{attribute}=", changed_attributes[attribute.to_s])
        end
      end

      { data: object_fields, data_display: object_fields_display }
    end

    def moderate_association(assoc, moderated_attributes)
      assoc_fields, assoc_fields_display = {}, {}
      objects = send(assoc)

      if respond_to?("#{assoc}_attributes=")
        if objects.is_a?(Array)
          data = moderate_has_many_association(objects, moderated_attributes)
          assoc_fields = data[:data]
          assoc_fields_display = data[:data_display]
        else
          data = objects.moderation_data(*moderated_attributes)
          assoc_fields = data[:data].merge(id: objects.id) unless data[:data].empty?
          assoc_fields_display = data[:data_display] unless data[:data_display].empty?
        end
      end

      { data: assoc_fields, data_display: assoc_fields_display }
    end

    def moderate_has_many_association(objects, moderated_attributes)
      assoc_fields, assoc_fields_display = {}, {}
      tab = []

      objects.each do |resource|
        data = resource.moderation_data(*moderated_attributes)

        assoc_fields[resource.id] = data[:data].merge(id: resource.id) unless data[:data].empty?
        unless data[:data_display].empty?
          key = data[:data_display].keys.first
          assoc_fields_display[key] ||= {}
          assoc_fields_display[key] = tab.push(data[:data])
        end
      end

      { data: assoc_fields, data_display: assoc_fields_display }
    end
  end
end
