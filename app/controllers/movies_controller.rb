class MoviesController < ApplicationController

helper_method :checked_rating?
helper_method :highlight

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    @checked = @all_ratings
    
    if params[:ratings]
      session[:ratings] = params[:ratings] 
    end
    if params[:sort]
      session[:sort] = params[:sort]
    end
    
    if session[:ratings]
      @checked = session[:ratings].keys
    end

    @movies = Movie.where(:rating => @checked).order(session[:sort])
    
  end
  
  def checked_rating?(rating)
    return true if session[:ratings].nil? or session[:ratings].include? rating
  end
  
  def highlight(col)
    if not session[:sort].nil? and session[:sort].to_s == col
      return "highlight"
    else 
      return nil
    end
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
