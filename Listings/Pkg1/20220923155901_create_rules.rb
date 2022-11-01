class CreateRules < ActiveRecord::Migration[7.0]
  def change
    create_table :rules do |t|
      t.belongs_to :inbox, index: true
      t.string :field_to_search
      t.string :field_matcher
    end
  end
end