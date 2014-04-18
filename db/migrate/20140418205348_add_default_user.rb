class AddDefaultUser < ActiveRecord::Migration
  def change
    User.create firstname: 'admin',
                lastname: 'admin',
                email: 'admin@example.com',
                password: 'password'
  end
end
