class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :overview
      t.string :image_url
      t.float :vote_average

      t.timestamps
    end
  end
end
