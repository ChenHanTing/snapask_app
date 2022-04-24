class CoursesController < ApplicationController
  before_action :is_admin, only: %i[ show edit update destroy ]
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses.rb or /courses.rb.json
  def index
    @courses = Course.all
  end

  # GET /courses.rb/1 or /courses.rb/1.json
  def show
  end

  # GET /courses.rb/new
  def new
    @course = Course.new
  end

  # GET /courses.rb/1/edit
  def edit
  end

  # POST /courses.rb or /courses.rb.json
  def create
    @course = current_user.courses.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to edit_course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses.rb/1 or /courses.rb/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to edit_course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses.rb/1 or /courses.rb/1.json
  def destroy
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:topic, :description, :currency, :started_at, :ended_at, :genre_id, :url, :expiration_day)
    end

    def is_admin
      redirect_to :root unless current_user&.can_edit?
    end
end
