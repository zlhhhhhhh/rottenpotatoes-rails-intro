class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    if params[:sort]
      @sorting = params[:sort]
    elsif session[:sort]
      @sorting = session[:sort]
      redirect = true 
    end
    
    # access ratings from model Movie
    @all_ratings = Movie.all_ratings
    if params[:ratings]
      @ratings = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true
    else
      @all_ratings.each do |rat|
        (@ratings ||= { })[rat] = 1
      end
      redirect = true
    end
    
    # redirect to /index
    if redirect
      redirect_to movies_path(:sort => @sorting, :ratings => @ratings)  
    end
    
    #  access checked item
    if session[:ratings]
      @checked_ratings = session[:ratings].keys
    elsif
      @checked_ratings = @all_ratings
    end
    
    # Sort By title or release date.
    @movies = Movie.order(@sorting).where(rating: @checked_ratings)
  	session[:sort] = @sorting
  	session[:ratings] = @ratings
  end   

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
