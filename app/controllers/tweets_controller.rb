class TweetsController < ApplicationController

    get '/tweets' do 
        @tweets = Tweet.all
        if !Helpers.is_logged_in?(session)
            redirect '/login'
        else
            @user = Helpers.current_user(session)
            erb :'tweets/tweets'
        end
    end

    get '/tweets/new' do 
        if !Helpers.is_logged_in?(session)
            redirect '/login'
        else
            erb :'tweets/new'
        end
    end

    post '/tweets' do 
        if !params[:content].empty?
            @tweet = Tweet.new
            @tweet.content = params[:content]

            @user = User.find(session[:user_id])
            @user.tweets << @tweet
            
            redirect "/tweets/#{@tweet.id}"
        else
            redirect '/tweets/new'
        end
    end

    get '/tweets/:id' do
        if !Helpers.is_logged_in?(session)
            redirect '/login'
        else
            @tweet = Tweet.find(params[:id])
            erb :'/tweets/show'
        end
    end

    get '/tweets/:id/edit' do
        if Helpers.is_logged_in?(session)
            
            @tweet = Tweet.find(params[:id])
            erb :'/tweets/edit'
        else
            redirect '/login'
        end
    end

    patch '/tweets/:id' do
        @tweet = Tweet.find(params[:id])
        if !params[:content].empty?
            @tweet.content = params[:content]
            @tweet.save
        else
            redirect "/tweets/#{@tweet.id}/edit"
        end
    end

    delete '/tweets/:id' do 
        @tweet = Tweet.find(params[:id])
        @user = Helpers.current_user(session)
        
        if @tweet.user == @user
            Tweet.find(params[:id]).destroy
        end

        redirect '/tweets'
    end

end