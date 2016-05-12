class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    @user = User.new(user_params)
    @role = Role.find(params[:role][:id])
    puts @role
    if @user.save
      personal_information = PersonalInformation.create
      @user.personal_information = personal_information
      Student.create(user_id: @user.id) if @role.student?
      Teacher.create(user_id: @user.id) if @role.teacher?
      @user.role_id = @role.id
      @user.save
      sign_in @user
      flash[:success] = "Welcome to the Thesis Manager"
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    super
  end

  private

    def user_params
      params.require(:user).permit(:email, :password,
                                   :password_confirmation, :role_id)
    end
end 