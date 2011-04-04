class MeasurementsController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy

  def show
    @measurement = Measurement.find_by_name(params[:id])
    if @measurement.nil?
      redirect_to "/home"
    else
      @user = @measurement.user
      @geigercounter = @user.geigercounter
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

  private

    def authorized_user
      @measurement = Measurement.find(params[:id])
      redirect_to root_path unless current_user?(@measurement.user)
    end

end