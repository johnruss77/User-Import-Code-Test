class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :project, :null => false
      t.references :user, :null => false
      t.text :other_info
      t.timestamps
    end
    add_foreign_key(:memberships, :projects, :name => 'memberships_project_fk')
    add_foreign_key(:memberships, :users, :name => 'memberships_user_fk')

  end
end