class CreateMovies < ActiveRecord::Migration
  def change
  	create_table :movies do |t|
  		t.string :title
  		t.text :synopsis
  		t.string :mpaa_rating
  		t.string :year
  		t.string :runtime
  		t.string :release_date
  		t.string :critics_score
  		t.string :audience_score
  		t.string :poster_thumbnail
  		t.string :cast1
  		t.string :cast2
  		t.string :cast3
  		t.string :cast4
  		t.string :cast5
  		t.boolean :favorite, default: false
  		t.timestamps
  		t.references :user
  	end
  end
end
