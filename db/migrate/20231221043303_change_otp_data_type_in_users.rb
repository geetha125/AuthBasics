class ChangeOtpDataTypeInUsers < ActiveRecord::Migration[6.0]
  def change  
    change_column :users, :otp, :string
  end
end
