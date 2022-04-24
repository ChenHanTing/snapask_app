module V1
  class Ping < Grape::API
    resources :ping do
      desc 'ping ping pong'
      get '/' do
        { ping: "pong" }
      end
    end
  end
end