class CreateMovies < ActiveRecord::Migration

  def change
    create_table :movies do |t|
      t.string :name
      t.string :summary
      t.integer :user_id
    end
  end

end
