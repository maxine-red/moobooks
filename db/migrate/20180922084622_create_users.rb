class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :name, null: false, unique: true
      t.text :pronouns, null: false, default: 'they/them/theirs'
      t.text :description
      t.text :email
      t.text :level, null: false, default: 'user'
      # t.text :accepted_tos, reminder to test for TOS acceptance
      t.text :icon
      t.text :banner

      t.timestamps
    end
  end
end
