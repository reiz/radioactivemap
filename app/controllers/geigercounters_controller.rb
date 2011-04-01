class GeigercountersController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy

  @@BUCKET = "RoR1"

  def create
    fileUp = params[:upload]
    orig_filename =  fileUp['datafile'].original_filename
    filename = sanitize_filename(orig_filename)
    filename = create_random_name + filename
    AWS::S3::S3Object.store(filename, fileUp['datafile'].read, @@BUCKET, :access => :public_read)
    url = AWS::S3::S3Object.url_for(filename, @@BUCKET, :authenticated => false)
    @geigercounter = Geigercounter.new(params[:geigercounter])
    @geigercounter.user = current_user
    @geigercounter.filename = filename
    @geigercounter.url = url;
    if @geigercounter.save
      flash[:success] = "Geiger saved! "
      redirect_to geigercounter_user_path(current_user)
    else
      render '/users/new_geiger'
    end
  end

  def destroy
    AWS::S3::S3Object.find(@geigercounter.filename, @@BUCKET).delete
    @geigercounter.destroy
    redirect_to geigercounter_user_path(current_user)
  end

  private

    def authorized_user
      @geigercounter = Geigercounter.find(params[:id])
      redirect_to root_path unless current_user?(@geigercounter.user)
    end

    def create_random_name
        chars = 'abcdefghijklmnopqrstuvwxyz'
        name = ""
        20.times { name << chars[rand(chars.size)] }
        name
    end

    def sanitize_filename(file_name)
      just_filename = File.basename(file_name)
      just_filename.sub(/[^\w\.\-]/,'_')
    end

end