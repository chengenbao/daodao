
class CreateCities < ActiveRecord::Migration
  def change
    create_table :datacenters do |t|
      t.string :name
      t.integer :geo
      t.string :tag

      t.timestamps
    end
  end
end
