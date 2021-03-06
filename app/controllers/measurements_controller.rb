class MeasurementsController < ApplicationController

  before_filter :authenticate,    :except => :show
  before_filter :authorized_user, :only   => :destroy

  def show
    @measurement = Measurement.find_by_name(params[:id])
    if @measurement.nil?
      redirect_to "/home"
    else
      @user = @measurement.user
      @geigercounter = @user.geigercounter
      @comment = Comment.new
    end
  end

  def create
    @measurement = current_user.measurements.build(params[:measurement])
    if @measurement.save
      flash[:success] = "Measurement saved!"
      redirect_to root_path
    else
      @feed_items = []
      render '/page/home'
    end
  end

  def destroy
    @measurement.destroy
    redirect_back_or root_path
  end

  def comment
    @measurement = Measurement.find_by_name(params[:id])
    comment = @measurement.comments.build(comment)
    comment.content = params[:comment][:content]
    comment.user = current_user
    comment.save
    redirect_to @measurement
  end

  private

    def authorized_user
      @measurement = Measurement.find(params[:id])
      redirect_to root_path unless current_user?(@measurement.user)
    end

end