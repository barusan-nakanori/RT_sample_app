module SessionsHelper
    
    def log_in(user) #login状態を作るメソッド
        session[:user_id] = user.id
    end
    
    def current_user #current_userを定義
        if session[:user_id]
          @current_user ||= User.find_by(id: session[:user_id])
        end
    end
    
    def logged_in? #loginしているかを確かめるメソッド
        !current_user.nil?
    end
    
    def log_out
        session.delete(:user_id)
        @current_user = nil
    end
end
