# Plancast

You've got plans, spread the word - mashup style! This is a Ruby wrapper for the [Plancast](http://plancast.com) API. 

## Installation

    sudo gem install plancast
    
### Usage

Until OAuth is supported, you'll need user credentails:

    client = Plancast::Client.new('pengwynn', '0U812')
    
Get your home timeline:

    timeline = client.home
    timeline.plans.last.what
    # =>  "Watch Jurassic Park to see if it is still good"

Get another user's timeline

    timeline = client.plans(:username => 'mark', :count => 20, :page => 3, :extensions => "attendees,comments")
    
You've got plans, spread the word:

    plan = client.update({
      :what => "Grabbing some BBQ",
      :when => "tomorrow night",
      :where => "Clark's Outpost, Tioga, TX"
    })
    
Check out even more examples in the [API Docs](http://wynnnetherland.com/projects/plancast/api/).

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Wynn Netherland. See LICENSE for details.
