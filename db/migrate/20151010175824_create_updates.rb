class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|

      t.string :hall_name
      t.string :load

      t.timestamps null: false
    end
  end
end
