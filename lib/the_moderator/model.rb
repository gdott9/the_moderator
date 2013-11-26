module TheModerator
  module Model
    def self.included(base)
      base.has_many :moderations, as: :moderatable, dependent: :destroy
    end

    def moderate(*moderated_attributes)
      data = moderation_data(*moderated_attributes)
      moderations.build(data: {attributes: data}) unless data.empty?
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
      send(assoc).each do |resource|
        if respond_to?("#{assoc}_attributes=")
          data = resource.moderation_data(*moderated_attributes)
          assoc_fields[resource.id] = data.merge(id: resource.id) unless data.empty?
        end
      end

      assoc_fields
    end
  end
end
