class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.date :born_on
      t.integer :gender
      t.string :password

      t.timestamps
    end
  end
end
