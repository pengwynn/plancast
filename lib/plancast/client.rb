module Plancast
  class Client
    include HTTParty
    base_uri "api.plancast.com/#{Plancast.api_version}"
    format :json
    
    attr_reader :username

    # Create the API client
    #
    # @param username [String] Plancast username
    # @param password [String] Plancast password
    # @example
    #   client = Plancast::Client.new('pengwynn', 'ou812')
    def initialize(username, password)
      @username = username
      self.class.basic_auth username, password
    end
    
    # Verify account credentials and gets information about the authenticated user
    # @return [Hashie::Mash] Plancast user info
    # @see http://groups.google.com/group/plancast-api/web/api-method---account-verify-credentials Plancast API docs: verify credentials
    def verify_credentials
      self.class.get("/account/verify_credentials.json")
    end
    
    # Return information about a given user.
    # @option query [String] :username Username of Plancast user
    # @option query [Integer] :user_id ID of Plancast user
    # @return [Hashie::Mash] Plancast user info
    # @example
    #   client.user(:user_id => 1234)
    # @example
    #   client.user(:username => 'pengwynn')
    # @see http://groups.google.com/group/plancast-api/web/api-method---users-show Plancast API docs: User show
    def user(query={})
      self.class.get("/users/show.json", :query => query)
    end
    
    # Return the users to which a given user is subscribed
    #
    # @option query [String] :username Username of Plancast user
    # @option query [Integer] :user_id ID of Plancast user
    # @option query [Integer] :page Page number of results to retrieve
    # @return [Hashie::Mash] Subscriptions info
    # @example
    #   subscriptions = client.subscriptions(:user_id => 30).users
    # @see http://groups.google.com/group/plancast-api/web/api-methods---users-subscriptions Plancast API docs: User subscriptions
    def subscriptions(query={})
      self.class.get("/users/subscriptions.json", :query => query)
    end
    
    # Subscribe the authenticated user to a target user and returns information about the target user. If the target user has enabled account protection, a subscription request will be sent.
    #
    # @option options [String] :username Username of Plancast user
    # @option options [Integer] :user_id ID of Plancast user
    # @return [Hashie::Mash] Subscribed user info
    # @see http://groups.google.com/group/plancast-api/web/api-method---subscriptions-create Plancast API docs: Create subscription
    def update_subscription(options={})
      self.class.post("/subscriptions/update.json", :body => options)
    end
    
    # Unsubscribe the authenticated user from a target user and returns information about the target user
    #
    # @option options [String] :username Username of Plancast user
    # @option options [Integer] :user_id ID of Plancast user
    # @return [Hashie::Mash] Unubscribed user info
    # @see http://groups.google.com/group/plancast-api/web/api-method---subscriptions-destroy Plancast API docs: Destroy subscription
    def destroy_subscription(options={})
      self.class.post("/subscriptions/destroy.json", :body => options)
    end
    
    # Return the users who are subscribed to a given user
    #
    # @option query [String] :username Username of Plancast user
    # @option query [Integer] :user_id ID of Plancast user
    # @option query [Integer] :page Page number of results to retrieve
    # @return [Hashie::Mash] Subscribers info
    # @example
    #   subscribers = client.subscribers(:user_id => 30).users
    # @see http://groups.google.com/group/plancast-api/web/api-methods---users-subscribers Plancast API docs: User subscribers
    def subscribers(query={})
      self.class.get("/users/subscribers.json", :query => query)
    end
    
    # Return the users connected to the authenticated user on a given network (Facebook or Twitter)
    #
    # @option query [String] :service Whether to return friends from 'facebook' or 'twitter'
    # @option query [Integer] :page Page number of results to retrieve
    # @return [Hashie::Mash] Friend info
    # @example
    #   friends = client.discover_friends(:service => 'twitter').users
    # @see http://groups.google.com/group/plancast-api/web/api-method---users-discover-friends Plancast API docs: Discover friends
    def discover_friends(query={})
      self.class.get("/users/discover_friends.json", :query => query)
    end
    
    # Return up to 25 users that match the given keyword(s).
    #
    # @param [String] Keyword query
    # @return [Hashie::Mash] User results
    # @example
    #   client.search_users('ruby')
    # @see http://groups.google.com/group/plancast-api/web/api-methods---users-search Plancast API docs: Search users
    def search_users(q, options={})
      self.class.get("/users/search.json", :query => options.merge({:q => q}))
    end
    
    # Return a given user's plans
    #
    # @option query [String] :username Username of Plancast user
    # @option query [Integer] :user_id ID of Plancast user
    # @option query [String] :view_type ("schedule") Optional; The type of plans to return (possible values: schedule, stream, ongoing, past)
    # @option query [Integer] :page (1) Optional: Page number
    # @option query [Integer] :count (25) Optional: (maximum: 100) - Number of plans per page
    # @option query [String] :extensions Optional: (possible values: attendees, comments, place) - Comma-delimited list of extended data types you want; omitted by default to minimize the size of the response
    # @return [Hashie::Mash] Plans info
    # @see http://groups.google.com/group/plancast-api/web/api-method---plans-user-get Plancast API Docs: User plans
    # @example
    #   client.plans(:username => 'pengwynn', :count => 20, :page => 3, :extensions => "attendees,comments")
    def plans(query = {})
      self.class.get("/plans/user.json", :query => query)
    end
    
    # Return plans on the session user's homepage (their own plans plus those of their subscriptions).
    #
    # @option query [String] :view_type ("schedule") Optional; The type of plans to return (possible values: schedule, stream, ongoing, past)
    # @option query [Integer] :page (1) Optional: Page number
    # @option query [Integer] :count (25) Optional: (maximum: 100) - Number of plans per page
    # @option query [String] :extensions Optional: (possible values: attendees, comments, place) - Comma-delimited list of extended data types you want; omitted by default to minimize the size of the response
    # @return [Hashie::Mash] Plans info
    # @see http://groups.google.com/group/plancast-api/web/api-method---plans-home-get Plancast API Docs: User home
    # @example
    #   client.home( :count => 20, :page => 3, :extensions => "attendees,comments")
    def home(query = {})
      self.class.get("/plans/home.json", :query => query)
    end    
    
    # Return the details for a given plan
    #
    # @option query [String] :attendance_id The ID of an attendance, in base 36
    # @option query [String] :plan_id The ID of a plan, in base 36
    # @option query [String] :extensions Optional: (possible values: attendees, comments, place) - Comma-delimited list of extended data types you want; omitted by default to minimize the size of the response
    # @return [Hashie::Mash] Plans info
    # @example
    #   client.plan(:plan_id => 'enf')
    # @see http://groups.google.com/group/plancast-api/web/api-method---plans-show Plancast API Docs: Plan show
    def plan(query = {})
      self.class.get("/plans/show.json", :query => query)
    end
    
    # Return up to 25 plans that match the given keyword(s).
    #
    # @option query [String] :q Keywords to search on
    # @option query [String] :extensions Optional: (possible values: attendees, comments, place) - Comma-delimited list of extended data types you want; omitted by default to minimize the size of the response
    # @return [Hashie::Mash] Search results
    # @see http://groups.google.com/group/plancast-api/web/api-method---plans-search Plancast API docs: Plans search
    # @example
    #   client.search_plans(:q => 'ruby')
    def search_plans(query={})
      self.class.get("/plans/search.json", :query => query)
    end
    
    # Parse a string for datetime information and returns the result if successful
    # @param [String] Date/time string to parse
    # @return [Hashie::Mash] Parsed time info
    # @see http://groups.google.com/group/plancast-api/web/api-method---plans-parse-when Plancast API docs: Parse when
    # @example
    #   date_range = client.parse_when("next friday")
    #   date_range.start.year
    #   # => 2010
    def parse_when(q)
      date = self.class.get("/plans/parse_when.json", :query => {:when => q})
      date.start = Time.at(date.start)
      date.stop = Time.at(date.stop)
      date
    end
    
    # Parse a string for location information and returns the result if successful
    # @param [String] Location string to parse
    # @return [Hashie::Mash] Parsed time info
    # @see http://groups.google.com/group/plancast-api/web/api-methods---plans-parse-where Plancast API docs: Parse where
    # @example
    #   location = client.parse_where("Sixth Street, Austin, TX")
    #   # => [<#Hashie::Mash accuracy=6 address="W 6th St, Austin, Texas, US" id=66569 latitude=30.272467 longitude=-97.756405 maps=<#Hashie::Mash detect="http://plancast.com/uploads/maps/66569_detect.png"> name="W 6th St">]
    #   location.latitude
    #   # => 30.272467
    def parse_where(where)
      locations = self.class.get("/plans/parse_where.json", :query => {:where => where})
      locations.each{|l| l.latitude = l.latitude.to_f; l.longitude = l.longitude.to_f}
      locations
    end
    
    # Create a new plan or update the details of an existing plan. Returns up-to-date information about the plan in either case.
    #
    # @option details [String] :what - Required - Brief descriptor of the plan
    # @option details [String] :when - Required - String descriptor of plan's date/time, parsed into timestamps for you. You're highly recommended to use plans/parse_when to verify that the string is parseable first
    # @option details [String] :where - Required - String descriptor of the plan's location
    # @option details [String] :place_id - Optional but highly recommended - ID of a canonical place record retrieved using plans/parse_where
    # @option details [String] :external_url - Optional - URL for more information about the plan elsewhere
    # @option details [String] :description - Optional - Longer, more free-form descriptor of the plan
    # @option details [Boolean] :syndicate_facebook - Optional (default: user's default) - Whether to syndicate the plan to Facebook, if authorization is available (only effective for new plans)
    # @option details [Boolean] :syndicate_twitter - Optional (default: user's default) - Whether to syndicate the plan to Twitter, if authorization is available (only effective for new plans)
    # @option details [String] :plan_id or attendance_id - Optional - Base-36 ID of an existing plan or attendance; provide this if you'd like to update a plan instead of creating a new one
    # @return [Hashie::Mash] Plan info
    # @see http://groups.google.com/group/plancast-api/web/api-method---plans-update Plancast API docs: Update plan
    # @example
    #   plan = client.update({
    #     :what => "Grabbing some BBQ",
    #     :when => "tomorrow night",
    #     :where => "Clark's Outpost, Tioga, TX"
    #   })
    def update(details={})
      self.class.post("/plans/update.json", :body => details)
    end
    
    # Add an attendance for a particular plan for the authenticated user and return information about it
    #
    # @option details [Boolean] :syndicate_facebook - Optional (default: user's default) - Whether to syndicate the plan to Facebook, if authorization is available (only effective for new plans)
    # @option details [Boolean] :syndicate_twitter - Optional (default: user's default) - Whether to syndicate the plan to Twitter, if authorization is available (only effective for new plans)
    # @option details [String] :plan_id Base-36 ID of an existing plan
    # @option details [String] :attendance_id - Base-36 ID of an existing attendance
    # @return [Hashie::Mash] Plan info
    # @see http://groups.google.com/group/plancast-api/web/api-method---plans-attend Plancast API docs: Attend plan
    # @example
    #   info = {
    #     :attendance_id => 'dho',
    #     :syndicate_twitter => false
    #   }
    #   attendance = client.attend(info)
    def attend(details={})
      self.class.post("/plans/attend.json", :body => details)
    end

    def user_timeline(username=self.username)
      self.class.get("/plans/user_timeline.json")
    end
    
    # Delete an attendance for the authenticated user and returns its previous information
    # @option options [String] :plan_id Base-36 ID of an existing plan
    # @option options [String] :attendance_id - Base-36 ID of an existing attendance
    # @return [Hashie::Mash] Deleted attendance info
    # @see http://groups.google.com/group/plancast-api/web/api-method---plans-destroy Plancast API docs: Plan destroy
    def unattend(options={})
     self.class.post("/plans/destroy.json", :body => options)
    end
    
    # Create a new comment on a plan and return information about it
    # 
    # @option details [String] :content Comment content
    # @option details [String] :plan_id Base-36 ID of an existing plan
    # @option details [String] :attendance_id - Base-36 ID of an existing attendance
    # @return [Hashie::Mash] Comment info
    # @see http://groups.google.com/group/plancast-api/web/api-method---comments-create Plancast API docs: Comment create
    # @example
    #   comment = client.update_comment(:content => "Hey I'll see you there!", :attendance_id => "2xlm")
    def update_comment(details={})
      self.class.post("/comments/update.json", :body => details)
    end
    
    # Delete a comment for the authenticated user and return its previous information
    # 
    # @param [String] Comment ID
    # @return [Hashie::Mash] Deleted comment info
    # @see http://groups.google.com/group/plancast-api/web/api-method---comments-destroy Plancast API docs: Comment destroy
    def destroy_comment(comment_id)
      self.class.post("/comments/destroy.json", :body => {:comment_id => comment_id})
    end
    
    
    # @private
    def self.get(*args); handle_response super end
    # @private
    def self.post(*args); handle_response super end
    
    # @private
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