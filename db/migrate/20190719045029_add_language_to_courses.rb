class AddLanguageToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :language, :string
  end
end
