class PlacesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :edit, :update]

	def index
		@places = Place.all
		@places = Place.paginate(:page => params[:page], :per_page => 2)
	end

	def new
		@places = Place.new
	end

	def create
		current_user.places.create(place_params)
		redirect_to root_path
	end

	def show
		@place = Place.find(params[:id])
	end

	def edit
		@place = Place.find(params[:id])

		if @place.user != current_user
			return render text: 'Not Allowed', status: :forbidden
		end
	end

	def update
		@place = Place.find(params[:id])
		if @place.user != current_user
			return render text: 'Not Allowed', status: :forbidden
		end
		# If return was not added to our if statement, a clever user would see the error message but the below code would continue to execute and the database item would be updated.
		@place.update_attributes(place_params)
		redirect_to root_path
	end

	def destroy
		@place = Place.find(param[:id])
		@place.destroy
		redirect_to root_path
	end

	private

	def place_params
		params.require(:place).permit(:name, :description, :address)
	end

end
