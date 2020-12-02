class Development::SessionsController < ApplicationController
  def login_as
    user = User.find(params[:user_id])
    auto_login(user)
    redirect_to admin_url, notice: "Signed in! [#{user.id}]"
  end
end
