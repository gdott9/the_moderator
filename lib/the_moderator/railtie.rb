module TheModerator
  class Railtie < Rails::Railtie
    initializer "the_moderator.include_in_active_record" do
      ActiveSupport.on_load :active_record do
        include TheModerator::Model
      end
    end
  end
end
