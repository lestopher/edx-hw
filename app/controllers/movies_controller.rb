class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if (params[:sort].nil? || params[:ratings].nil?) && session[:sort] != nil && session[:checked_ratings] != nil
      redirect_to movies_path :sort => session[:sort], :ratings => session[:checked_ratings]
    end
    @all_ratings = Movie.new.all_ratings

    sort = params[:sort].nil? ? session[:sort] : "#{params[:sort]} ASC"

    if params[:ratings].nil?
      @checked_ratings = session[:checked_ratings]
    else
      if params[:ratings].kind_of? Array
        @checked_ratings = params[:ratings]
      else
        @checked_ratings = params[:ratings].keys
      end
    end


    @movies = Movie.where(:rating => @checked_ratings.nil? ? @all_ratings : @checked_ratings).order(sort)
    @class_css = sort.split(' ')[0]
    session[:checked_ratings] = @checked_ratings
    session[:sort] = sort.split(' ')[0] if sort != nil

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
