class AddInviteCaddieTicketToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :invite_caddie_ticket, :string, limit: 512, after: :total
  end
end
