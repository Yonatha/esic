class ModulosController < ApplicationController


  def carregar_dominos

    modulo = params[:modulo]

    @dominios = Object.const_get(modulo.capitalize).all()


    render :partial => "carregar_dominos", :dominios => @dominios, :layout => false


  end
end