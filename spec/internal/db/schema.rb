ActiveRecord::Schema.define do
  create_table :pages, :force => true do |t|
    t.string :name
    t.text   :content
    t.timestamps
  end

  create_table :moderations, :force => true do |t|
    t.integer  :moderatable_id
    t.string   :moderatable_type
    t.text     :data
    t.timestamps
  end
end
