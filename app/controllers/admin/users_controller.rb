class Admin::UsersController < Admin::AdminController
    before_action :set_user, only: %i[edit]
    def index
        @selected_filter = request.params['filter']
    
        @users = User.non_admin

        case @selected_filter
        when 'confirmed'
            @users = @users.confirmed
        when 'unconfirmed'
            @users = @users.unconfirmed
        end

        @users = @users.order(created_at: :desc)
    end

    def edit
        
    end

    private

    def set_user
        @user = User.find(params[:id])
    end
end