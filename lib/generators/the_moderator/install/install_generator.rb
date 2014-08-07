class TheModerator::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  def copy_model
    template 'moderation.rb', File.join('app', 'models', 'moderation.rb')
  end

  def create_migration_file
    migration_template 'migration.rb', 'db/migrate/create_moderations.rb'
  end

  def self.next_migration_number(dirname)
    ActiveRecord::Migration.next_migration_number(
      current_migration_number(dirname) + 1)
  end
end
