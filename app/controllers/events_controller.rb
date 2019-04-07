class EventsController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    case params[:scope] 
    when 'past'
      @events = Event.past
    when 'free'
      @events = Event.free
    when 'recent'
      @events = Event.recent
    else
      @events = Event.upcoming
    end
  end

  def show
    @event = Event.find(params[:id])
    @likers = @event.likers
    
    if current_user
      @current_like = current_user.likes.find_by(event_id: @event.id)
    end

    @categories = @event.categories   
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: "Event successfuly updated!"
    else
      render :edit
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event
    else
      render :new
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url, alert: "Event successfuly deleted!"
  end

private

  def event_params
    event_params = params.require(:event).
                  permit(:name, :description, :location, :price,
                        :starts_at, :image_file_name, :capacity, :category_ids => [])
  end
end

