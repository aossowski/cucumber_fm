class Documentation::FeaturesController < Documentation::ApplicationController

  before_filter :fetch_feature, :only => [:show, :edit, :update]
  before_filter :cleanup_raw, :only => [:update]

  def index
    @highlight = 'business_overview'
    cfm
  end

  def show
  end

  def edit
  end

  def create
    if filename_invalid?
      redirect_to :action => 'index'
    elsif File.exists?(new_file_path)
      feature = CucumberFM::Feature.new(new_file_path, cfm)
      redirect_to edit_documentation_feature_path(feature.id)
    else
      feature = CucumberFM::Feature.new(new_file_path, cfm)
      feature.raw=(new_feature_raw)
      feature.save
      redirect_to edit_documentation_feature_path(feature.id)
    end
  end

  def update
    @feature.raw=(params[:raw])
    @feature.save
    redirect_to :action => :edit
  end

  private

  def fetch_feature
    @feature = CucumberFM::Feature.new(path, cfm)
  end

  def path
    File.join(cfm.path, Base64.decode64(params[:id]))
  end

  def cfm
    @cfm ||= CucumberFeatureManager.new(feature_dir_path, git_dir_path, read_config)
  end

  def cleanup_raw
    params[:raw].gsub!(/\r/, '')
  end

  def new_file_path
    File.join(feature_dir_path, read_config['dir'], "#{new_file_name}.feature")
  end

  def new_file_name
    params[:name].gsub(/[^a-zA-Z0-9]/, '_')
  end

  def new_file_feature_name
    params[:name].gsub(/(_|\.feature)/, ' ')
  end

  def new_feature_raw
    %{Feature: #{new_file_feature_name}}
  end

  def filename_invalid?
    (params[:name].blank? or params[:name].size < 4) ?
            flash[:error] = 'File name too short, at least 4 alphanumeric characters' :
            false
  end

end