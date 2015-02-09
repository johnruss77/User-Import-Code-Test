require 'tempfile'

class ProjectsController < ApplicationController
	def index	
		params[:search] ||= {:name => ''}
	end

	def search
	    @search = false
	    if params[:search][:view_all].to_bool == true
	      @projects = Project.all.order(:name)
	      @search = true
	    elsif params[:search][:name].empty? 
	      flash.now[:error] = 'Please enter some search criteria!'
	    else
	      @search = true
	      # if a name has been entered, this will be searched on
	      @projects = Project.all.order(:name)
	      @projects = @projects.where('name ILIKE(?)', params[:search][:name] + '%') if params[:search][:name].present?
	      
	      flash.now[:notice] = 'No projects Found' if @projects.nil?
	    end
	    render :index
	end

	def show
		@project = Project.find(params[:id])
	end

	def update
		@project = Project.find(params[:id])

	    if params[:import].nil?
	      flash.now[:error] = 'You need to select a file to upload';
	      render :show
		else
		    #relevant parameters passed into Importer class

		    import_type = 'User'

		    importer = Importer.new(
		      parser: CSVParser.new({:import_file => params[:import].tempfile, :association => @project}),
		      import_type: import_type,
		      association_type: 'memberships',
		      existence_check: :email
		    )

		    # import function called which will create new users and associate them
		    # to the project via memeberships
		    importer.import

		    redirect_to index

	  	end
	end
end