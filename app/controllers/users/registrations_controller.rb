class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]

  def edit
    super
  end

  def update
    if current_user.update(account_update_params)
      sign_in(current_user, bypass: true)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  protected

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [:nickname, :lastname, :firstname, :lastname_kana, :firstname_kana, :birthday,
                                             :profile])
  end

  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end
end
