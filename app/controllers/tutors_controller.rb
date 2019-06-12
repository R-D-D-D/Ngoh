class TutorsController < ApplicationController
  def new
    @tutor = Tutor.new
  end

  def create
    @tutor = Tutor.new(tutor_params)
    if @tutor.save
      log_in_tutor @tutor
      flash[:success] = 'Successfully registered!'
      redirect_to @tutor
    else
      render 'new'
    end
  end

  def show
    @tutor = Tutor.find(params[:id])
  end

  def edit
  end

  def update

  end

  def destroy
  end

  def students
    @title = "My Students"
    # @courses = Tutor.find(params[:id]).courses
    @students = Tutor.find(params[:id]).students_unique
    render 'tutors/show_students'
  end

  def courses
    @tutor = Tutor.find(params[:id])
    @courses = @tutor.courses.paginate(page: params[:page])
    render 'tutors/show_courses'
  end

  private

  def tutor_params
    params.require(:tutor).permit(:name, :email, :password, :password_confirmation)
  end
end
