class AddGamethemeToJackpotMachine < ActiveRecord::Migration[6.0]
  def change
    add_reference :machine_reservations, :gametheme, index: true
  end
end
