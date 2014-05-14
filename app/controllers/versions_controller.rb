class VersionsController < ApplicationController

  def change
    @version = PaperTrail::Version.find(params[:version_id]).next
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    render :inline => "Success"
  end

end
