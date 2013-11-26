module TheModerator
  module ModerationModel
    def self.included(base)
      base.send :extend, ClassMethods

      base.class_eval do
        belongs_to :moderatable, polymorphic: true
        serialize :data
      end
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
  end
end
