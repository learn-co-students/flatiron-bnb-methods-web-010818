class ListingsController < ApplicationController
  before_action :find_listing, only: [:show, :edit, :update]

  def index
    @listings = Listing.all
  end

  def show
  end

  def edit
    #code
  end

  def update
    #code
  end

  private

  def find_listing
    @listing = Listing.find_by(params[:id])
  end
end
