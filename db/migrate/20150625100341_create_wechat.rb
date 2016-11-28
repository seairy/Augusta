class CreateWechat < ActiveRecord::Migration
  def change
    create_table :wechat, id: false do |t|
      t.string :access_token, limit: 512
      t.datetime :expired_at
    end
  end
end
