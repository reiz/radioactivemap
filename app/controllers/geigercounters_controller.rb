class GeigercountersController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy

  @@image_dir = "/Users/robert/workspace/ruby/radioactivemap/public/images/"

  def create
    fileUp = params[:upload]
    filename = store_file_to_disk (fileUp)
    url = "/images/" + filename
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
    cleanup ( @geigercounter.filename )
    @geigercounter.destroy
    redirect_to geigercounter_user_path(current_user)
  end

  private

    def authorized_user
      @geigercounter = Geigercounter.find(params[:id])
      redirect_to root_path unless current_user?(@geigercounter.user)
    end

    def upload_to_s3( fileUp )
      if fileUp.nil?
        ""
      end
      filename =  fileUp['datafile'].original_filename
      filepath = fileUp['datafile'].tempfile.path
      service = S3::Service.new(:access_key_id => "AKIAJJVCE2X6JF4UGT3Q",:secret_access_key => "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")
      bucket = service.buckets[0]
      new_object = bucket.objects.build(filename)
      new_object.content = open(filepath)
      new_object.save()
      url = new_object.url()
      url
    end

    def store_file_to_disk ( fileUp )
      orig_filename =  fileUp['datafile'].original_filename
      randomName = create_random_name
      filename = randomName + orig_filename
      path = File.join(@@image_dir, filename)
      File.open(path, "wb") { |f| f.write(fileUp['datafile'].read) }
      filename;
    end

    def create_random_name
        chars = 'abcdefghijklmnopqrstuvwxyz'
        name = ""
        20.times { name << chars[rand(chars.size)] }
        name
    end

    def cleanup filename
      File.delete("#{@@image_dir}#{filename}") if File.exist?("#{@@image_dir}#{filename}")
    end

end