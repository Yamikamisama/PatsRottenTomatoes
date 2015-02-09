class CreateFilters < ActiveRecord::Migration
  def change
  	create_table :filters do |t|
  		t.string :release_date
  		t.string :critic_rating
  		t.references :user
  	end
  end
end
