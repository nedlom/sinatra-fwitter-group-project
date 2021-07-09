class UsersController < ApplicationController

    get '/signup' do 
        if session[:user_id]
            redirect '/tweets'
        else
            erb :'/users/create_user'
        end   
    end

    post '/signup' do
        if !params.values.include?("") 
            user = User.create(params)
            session[:user_id] = user.id
            redirect '/tweets'
        else
            redirect '/signup'
        end

        # user = User.new
        # user.username = params[:username]
        # user.email = params[:email]
        # user.password = params[:password]
        
        # if !params.values.include?("") && user.save
        #     session[:user_id] = user.id
        #     redirect '/tweets'
        # else
        #     redirect '/signup'
        # end
    end

    get '/login' do 
        if session[:user_id]
            redirect '/tweets'
        else
            erb :'users/login'
        end
    end

    post '/login' do 
        @user = User.find_by(:username => params[:username])
        
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect '/tweets'
        else
            redirect '/login'
        end

    end

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        erb :'/users/show'
    end

    get '/logout' do 
        if logged_in?
            session.clear
            redirect '/login'
        else
            redirect '/'   
        end
    end
end
