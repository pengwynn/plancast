require 'helper'

class PlancastTest < Test::Unit::TestCase
  
  context "Plancast API" do
    
    setup do
      @client = Plancast::Client.new('pengwynn', 'password')
    end

    should "verify credentials" do
      
      stub_get("/account/verify_credentials.json", "verify_credentials.json")      
      lambda {@client.verify_credentials}.should_not raise_error
      user = @client.verify_credentials
      user.username.should == 'pengwynn'
      user.name.should == 'Wynn Netherland'
      
    end
    
    should "raise error on invalid credentials" do
      stub_get("/account/verify_credentials.json", "", ['401'])      
      lambda {@client.verify_credentials}.should raise_error(Plancast::Unauthorized)
    end

    should "get the details of a user" do
      stub_get("/users/show.json?user_id=1", "user.json")
      user = @client.user(:user_id => 1)
      user.name.should == 'Mark Hendrickson'
      user.twitter_username.should == 'mhendric'
    end
    
    should "get a users's subscription" do
      stub_get("/users/subscriptions.json?user_id=30", "subscriptions.json")
      subscriptions = @client.subscriptions(:user_id => 30).users
      subscriptions.size.should == 25
      subscriptions.first.screen_name = 'ifindkarma'
    end
    
    should "get a user's subscribers" do
      stub_get("/users/subscribers.json?user_id=1", "subscriptions.json")
      subscribers = @client.subscribers(:user_id => 1).users
      subscribers.size.should == 25
      subscribers.first.screen_name = 'ifindkarma'
    end
    
    should "get users who are friends of a particular user on Facebook or Twitter" do
      stub_get("/users/discover_friends.json?service=twitter", "discover_friends.json")
      response = @client.discover_friends(:service => :twitter)
      subscriptions = response.users
      subscriptions.size.should == 25
      subscriptions.first.screen_name = 'graysky'
      response.has_next_page?.should == true
    end
    
    should "search for users by keyword" do
      stub_get("/users/search.json?q=mark", "users_search.json")
      response = @client.search_users('mark')
      results = response.results
      results.first.username.should == "mark"
    end

    should "create or update a subscription" do
      stub_post("/subscriptions/update.json", "update_subscription.json")
      subscription = @client.update_subscription(:user_id => 1)
      subscription.username.should == "peter"
    end
    
    should "delete a subscription" do
      stub_post("/subscriptions/destroy.json", "destroy_subscription.json")
      subscription = @client.destroy_subscription(:user_id => 1)
      subscription.username.should == "peter"
    end

    should "get the plans of a user" do
      stub_get("/plans/user.json?username=mark", "user_plans.json")
      response = @client.plans(:username => 'mark')
      plans = response.plans
      plans.first.attendance_url.should == 'http://plancast.com/a/32st'
    end
    
    should "get the home timeline of a user (his plans + his friends' plans)" do
      stub_get("/plans/home.json", "home.json")
      timeline = @client.home
      timeline.plans.size.should == 19
      timeline.plans.first.attendance_id.should == '10o'
    end
    
    should "get the details of a plan" do
      stub_get("/plans/show.json?plan_id=enf", "plan.json")
      plan = @client.plan(:plan_id => 'enf')
      plan.plan_id.should == 'enf'
      plan.creator.username.should == 'ethan'
    end
    
    should "create or update a plan" do
      stub_post("/plans/update.json", "new_plan.json")
      details = {
        :what => "Test Plancast gem",
        :when => "tomorrow"
      }
      plan = @client.update(details)
      plan.attendance_id.should == '3ag4'
    end
    
    should "add an attendance to a plan for a user" do
      stub_post("/plans/attend.json", "attend.json")
      info = {
        :attendance_id => 'dho',
        :syndicate_twitter => false
      }
      attendance = @client.attend(info)
      attendance.attendance_id.should == '3ag6'
    end
    
    should "delete or unattend a plan" do
      stub_post("/plans/destroy.json", "plan.json")
      attendance = @client.unattend(:plan_id => 'enf')
      attendance.creator.username.should == 'ethan'
    end
    
    should "search plans by keyword" do
      stub_get("/plans/search.json?q=party", "plans_search.json")
      plans = @client.search_plans(:q => 'party').plans
      plans.first.plan_id.should == "5bz"
    end
    
    should "parse datetime from a string" do
      stub_get("/plans/parse_when.json?when=next%20friday", "parse_when.json")
      date = @client.parse_when("next friday")
      date.start.year.should == 2010
      date.start.month.should == 5
      date.stop.day.should == 28
    end
    
    should "parse location from string" do
      stub_get("/plans/parse_where.json?where=london", "parse_where.json")
      locations = @client.parse_where("london")
      locations.first.latitude.should == 51.500152
      locations.first.longitude.should == -0.126236
    end

    should "create a comment" do
      stub_post("/comments/update.json", "comment.json")
      comment = @client.update_comment(:content => "hello world")
      comment.content.should == 'hello world'
    end
    
    should "delete a comment" do
      stub_post("/comments/destroy.json", "comment.json")
      comment = @client.destroy_comment(7513)
      comment.content.should == 'hello world'
    end
  
  end
  
  
  
end
