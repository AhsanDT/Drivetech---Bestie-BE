class Admin::GuidelinesController < ApplicationController
  before_action :get_page, only: [:index]

  def index; end

  def get_page
    @page = Page.find_by(permalink: params[:permalink].blank? ? "terms&condition" : params[:permalink])
  end

  def edit
    @page = Page.find_by_id(params[:id])
  end
  def update
    @page = Page.find_by_id(params[:id])
    if @page.update(content: params[:content])
      render 'index'
    end
  end

end
