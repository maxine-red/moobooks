class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :name, null: false
      t.text :pronouns, null: false, default: 'they/them/theirs'
      t.text :description
      t.text :email
      # t.text :accepted_tos, reminder to test for TOS acceptance
      t.text :icon
      t.text :banner

      t.timestamps
    end
  end
end
