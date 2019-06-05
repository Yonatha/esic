class SystemController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  layout "dashboard", :only => :dashboard

  def dashboard

  end

end