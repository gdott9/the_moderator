class CreateModerations < ActiveRecord::Migration
  def self.up
    create_table "moderations" do |t|
      t.references :moderatable, polymorphic: true
      t.text :data, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :moderations
  end
end
