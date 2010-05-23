module Plancast
  class Client
    include HTTParty
    base_uri "api.plancast.com/#{Plancast.api_version}"
    format :json
    
    attr_reader :username

    def initialize(username, password)
      @username = username
      self.class.basic_auth username, password
    end
    
    def verify_credentials
      self.class.get("/account/verify_credentials.json")
    end
    
    def user(query={})
      self.class.get("/users/show.json", :query => query)
    end
    
    def subscriptions(query={})
      self.class.get("/users/subscriptions.json", :query => query)
    end
    
    def update_subscription(options={})
      self.class.post("/subscriptions/update.json", :body => options)
    end
    
    def destroy_subscription(options={})
      self.class.post("/subscriptions/destroy.json", :body => options)
    end
    
    def subscribers(query={})
      self.class.get("/users/subscribers.json", :query => query)
    end
    
    def discover_friends(query={})
      self.class.get("/users/discover_friends.json", :query => query)
    end
    
    def search_users(q, options={})
      self.class.get("/users/search.json", :query => options.merge({:q => q}))
    end
    
    def plans(query = {})
      self.class.get("/plans/user.json", :query => query)
    end
    
    def home
      self.class.get("/plans/home.json")
    end    
    
    def plan(query = {})
      self.class.get("/plans/show.json", :query => query)
    end
    
    def search_plans(query)
      self.class.get("/plans/search.json", :query => query)
    end
    
    def parse_when(q)
      date = self.class.get("/plans/parse_when.json", :query => {:when => q})
      date.start = Time.at(date.start)
      date.stop = Time.at(date.stop)
      date
    end
    
    def parse_where(where)
      locations = self.class.get("/plans/parse_where.json", :query => {:where => where})
      locations.each{|l| l.latitude = l.latitude.to_f; l.longitude = l.longitude.to_f}
      locations
    end
    
    def update(details={})
      self.class.post("/plans/update.json", :body => details)
    end
    
    def attend(details={})
      self.class.post("/plans/attend.json", :body => details)
    end

    def user_timeline(username=self.username)
      self.class.get("/plans/user_timeline.json")
    end
    
    def unattend(options)
     self.class.post("/plans/destroy.json", :body => options)
    end
    
    def update_comment(details={})
      self.class.post("/comments/update.json", :body => details)
    end
    
    def destroy_comment(comment_id)
      self.class.post("/comments/destroy.json", :body => {:comment_id => comment_id})
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
      if response.is_a?(Array)
        response.map{|item| Hashie::Mash.new(item)}
      else
        Hashie::Mash.new(response)
      end
    end
    
  end
end