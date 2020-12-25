class Admin::SitesController < ApplicationController
  layout 'admin'

  before_action :set_site

  def edit
    authorize(@site)
  end

  def update
    authorize(@site)

    if @site.update(site_params)
      redirect_to edit_admin_site_path
    else
      render :edit
    end
  end

  def delete_image
    if params[:type] == 'favicon'
      @site.favicon&.purge
    elsif params[:type] == 'og_image'
      @site.og_image&.purge
    elsif params[:type] == 'main_images'
      @site.main_images.find(params[:blob_id])&.purge
    end
    redirect_to edit_admin_site_path
  end

  private

  def site_params
    params.require(:site).permit(:name, :subtitle, :description, :favicon, :og_image, main_images: [])
  end

  def set_site
    @site = Site.find(current_site.id)
  end
end
