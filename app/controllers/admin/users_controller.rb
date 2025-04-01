class Admin::UsersController < Admin::AdminController
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
end