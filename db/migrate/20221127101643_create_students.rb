class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :name
      t.string :surname
      t.string :patronymic
      t.string :sex
      t.integer :age
      t.integer :course

      t.timestamps
    end
  end
end
