class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.string :name 
      t.string :channel_code 

      t.timestamps
    end
  end
end
