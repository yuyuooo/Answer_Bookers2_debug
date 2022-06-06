class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search_result
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model =='User'
      @records = User.looks(@method, @content)
    else
      @records = Book.looks(@method, @content)
    end
  end
end
