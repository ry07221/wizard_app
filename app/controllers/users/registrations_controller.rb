# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up

  def new
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)

    unless @user.valid?  #送られてきたパラメータが指定されたバリデーションに違反しないかチェック
      flash.now[:alert] = @user.errors.full_messages
      render :new and return
    end

    session["devise.regist_data"] = {user: @user.attributes}  
    # 入力した情報のバリデーションチェックが完了したらここに値が入る
    # sessionにハッシュオブジェクトの形で情報を保持させるために「attributesメソッド」を使用

    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    # paramsの中にはパスワードの情報は含まれているが、attributesメソッドでデータ整形をした際にパスワードの情報は含まれていない→再度パスワードをsessionに代入する

    @address = @user.build_address 
    # 関連したモデルのインスタンスを新しく作る場合はb「uildメソッドを」を使用
    # アソシエーションが0〜1の場合のため、この書き方

    render :new_address
    end

    def create_address
      @user = User.new(session["devise.regist_data"]["user"])
      @address = Address.new(address_params)
      unless @address.valid?
        flash.now[:alert] = @address.errors.full_messages
        render :new_address and return
      end

      @user.build_address(@address.attributes)
      @user.save
      # build_addressを用いて送られてきたparamsを、保持していたsessionが含まれる@userに代入する
      # saveメソッドを用いてテーブルに保存

      sign_in(:user, @user)
    end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  def address_params
    params.require(:address).permit(:zipcode, :address)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
