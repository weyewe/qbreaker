class CreateSeatCategories < ActiveRecord::Migration
  def change
    create_table :seat_categories do |t|
      t.integer :office_id 
      t.string :name 

      t.timestamps
    end
  end
end
