class AddReservationEmailToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :reservation_email, :string, null: true
  end
end
