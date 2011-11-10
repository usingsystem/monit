class OperatorPasswordController < ApplicationController
  menu_item 'settings'
  def edit
    submenu_item 'operator-password'
  end

  def update
    submenu_item 'operator-password'
    operator=params[:operator]
    if @operator.update_password(operator[:old_password],operator[:password],operator[:password_confirmation])
      flash.now[:notice] = '密码修改成功,请妥善保存您的密码。'
    end
    render :action=>:edit
  end
end
