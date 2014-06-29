class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :release_year
      t.float :price
      t.text :description
      t.string :imdb_id
      t.string :poster_url

      t.timestamps
    end
  end
end
