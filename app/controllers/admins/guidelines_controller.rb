class Admins::GuidelinesController < ApplicationController
  before_action :authenticate_admin!
  before_action :get_page, only: [:index]
  before_action :find_page, only: [:edit, :update]

  def index; end

  def edit; end

  def update
    if @page.update(content: params[:content])
      redirect_to admins_guidelines_path+ "?permalink=#{@page.permalink}"
    end
  end

  private

  def find_page
    @page = Page.find_by_id(params[:id])
  end

  def get_page
    @page = Page.find_by(permalink: params[:permalink].blank? || params[:permalink] == "terms" ? "terms&condition" : params[:permalink])
  end
end
