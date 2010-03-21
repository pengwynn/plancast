module Plancast
  class Client
    include HTTParty
    base_uri 'api.plancast.com/01'
    format :json
    
    attr_reader :username

    def initialize(username, password)
      @username = username
      self.class.basic_auth username, password
    end
    
    def verify_credentials
      Hashie::Mash.new(self.class.get("/account/verify_credentials.json"))
    end
    
    def home_timeline
      Hashie::Mash.new(self.class.get("/plans/home_timeline.json"))
    end
    
    def user_timeline(username=self.username)
      timeline = Hashie::Mash.new(self.class.get("/plans/user_timeline.json"))
    end
    
    def update(details={})
      plan = Hashie::Mash.new(self.class.post("/plans/update.json", :body => details))
    end
    
    def attend(plan_id)
      plan = Hashie::Mash.new(self.class.post("/plans/attend.json", :query => {:plan_id => plan_id}))
    end
    
    def unattend(attendance_id)
      plan = Hashie::Mash.new(self.class.post("/plans/destroy.json", :query => {:attendance_id => attendance_id}))
    end
    
    def plan(attendance_id)
      plan = Hashie::Mash.new(self.class.get("/plans/show.json", :query => {:attendance_id => attendance_id}))
    end
    
    def search_plans(q, options={})
      results = Hashie::Mash.new(self.class.get("/plans/search.json", :query => options.merge({:q => q})))
    end
    
    def user(screen_name=nil)
      user = Hashie::Mash.new(self.class.get("/users/show.json", :query => {:screen_name => screen_name}))
    end
    
    def search_users(q, options={})
      results = Hashie::Mash.new(self.class.get("/users/search.json", :query => options.merge({:q => q})))
    end
    
    def subscriptions(user_id)
      results = self.class.get("/users/subscriptions.json", :query => {:user_id => user_id}).map{|s| Hashie::Mash.new(s)}
    end
    
    def subscribers(user_id)
      results = self.class.get("/users/subscribers.json", :query => {:user_id => user_id}).map{|s| Hashie::Mash.new(s)}
    end
    
    def create_comment(details={})
      comment = Hashie::Mash.new(self.class.post("/comments/update.json", :body => details))
    end
    
    def create_friendship(user_id)
      user = Hashie::Mash.new(self.class.post("/friendships/create.json", :body => {:user_id => user_id}))
    end

    
    def self.get(*args); handle_response super end
    def self.post(*args); handle_response super end
    
    def self.handle_response(response)
      case response.code
      when 401; raise Unauthorized.new
      when 403; raise RateLimitExceeded.new
      when 404; raise NotFound.new
      when 400...500; raise ClientError.new
      when 500...600; raise ServerError.new(response.code)
      else; response
      end
      response
    end
    
  end
end