class AddPriceToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :price, :float
  end
end
