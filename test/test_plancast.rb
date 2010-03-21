require 'helper'

class TestPlancast < Test::Unit::TestCase
  context "When using the UNDOCUMENTED Plancast API" do
    setup do
      @client = Plancast::Client.new('pengwynn', 'password')
    end

    should "verify credentials" do
      stub_get("/account/verify_credentials.json", "verify_credentials.json")      
      lambda {@client.verify_credentials}.should_not raise_error
    end
    
    should "return user info when verifying credentials" do
      stub_get("/account/verify_credentials.json", "verify_credentials.json")      
      user = @client.verify_credentials
      user.screen_name.should == 'pengwynn'
      user.user.status.attendees.first.screen_name.should == 'damon'
    end
    
    should "raise error on invalid credentials" do
      stub_get("/account/verify_credentials.json", "", ['401'])      
      lambda {@client.verify_credentials}.should raise_error(Plancast::Unauthorized)
    end
    
    should "return the home timeline" do
      stub_get("/plans/home_timeline.json", "home_timeline.json")
      timeline = @client.home_timeline
      timeline.plans.size.should == 25
      timeline.plans.first.plan_id.should == 'c9f'
      timeline.plans.first.user.screen_name.should == 'davemcclure'
    end
    
    should "return the user timeline for the authenticated user" do
      stub_get("/plans/user_timeline.json", "user_timeline.json")
      timeline = @client.user_timeline
      timeline.plans.first.what.should == 'Create a Plancast wrapper when the API drops'
      #timeline.plans.first.start.should == Time.at(1269302400)
    end
    
    should "create a plan" do
      stub_post("/plans/update.json", "update.json")
      details = {
        :what => "OpenBeta4",
        :when => "Thursday",
        :where => "723 n hudson, 73120",
        :syndicate_twitter => 1
      }
      plan = @client.update(details)
      plan.plan_id.should == 'utn'
      plan.is_attending?.should == true
    end
    
    should "attend a plan" do
      stub_post("/plans/attend.json?plan_id=u6i", "attend.json")
      plan = @client.attend('u6i')
      plan.attendance_id.should == '23rk'
      plan.what.should == 'Android Developer Day'
    end
    
    should "unattend a plan" do
      stub_post("/plans/destroy.json?attendance_id=23rl", "unattend.json")
      plan = @client.unattend('23rl')
      plan.attendance_id.should == '23rl'
      plan.plan_id.should == '2n7'
    end
    
    should "show plan details" do
      stub_get("/plans/show.json?attendance_id=mkg", "plan.json")
      plan = @client.plan('mkg')
      plan.attendance_id.should == 'mkg'
      plan.plan_id.should == 'c9f'
    end
    
    should "search for plans" do
      stub_get("/plans/search.json?q=bradleyjoyce", "search.json")
      results = @client.search_plans('bradleyjoyce').results
      results.first.plan_id.should == "1"
      results.first.what.should == 'Drinks'
    end
    
    should "show user details" do
      stub_get("/users/show.json?screen_name=mark", "user.json")
      user = @client.user('mark')
      user.name.should == 'Mark Hendrickson'
      user.has_twitter?.should == true
    end
    
    should"search for users" do
      stub_get("/users/search.json?q=bradleyjoyce", "user_search.json")
      results = @client.search_users('bradleyjoyce').results
      results.first.screen_name.should == "bradleyjoyce"
    end
    
    should "create a friendship" do
      stub_post("/friendships/create.json", "create_friendship.json")
      user = @client.create_friendship(35)
      user.screen_name.should == "defunkt"
    end
    
    should "list subscriptions" do
      stub_get("/users/subscriptions.json?user_id=30", "subscriptions.json")
      subscriptions = @client.subscriptions(30)
      subscriptions.size.should == 25
      subscriptions.first.screen_name = 'soph'
    end
    
    should "list subscribers" do
      stub_get("/users/subscribers.json?user_id=30", "subscribers.json")
      subscribers = @client.subscribers(30)
      subscribers.size.should == 25
      subscribers.first.screen_name = 'mark'
    end
    
    should "create comments" do
      stub_post("/comments/update.json", "comment.json")
      info = {
        :plan_id => 1,
        :text => "This is a comment"
      }
      comment = @client.create_comment(info)
      comment.text.should == 'This is a comment'
      comment.user.screen_name.should == 'pengwynn'
    end
    
  end
  
end
