class EventsController < ApplicationController
  def index
    @events = ['BugSmash', 'Hackaton', 'Kata Camp', 'Rails User Group']
  end
end 


