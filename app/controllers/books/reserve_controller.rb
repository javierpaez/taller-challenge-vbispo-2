class Books::ReserveController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    if book.available_to_reserve?
      book.reserve!(email: params[:email])
      render json: { message: "Book reserved successfully" }, status: :ok
      return
    end
    render json: { message: "Book cannot be reserved" }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end
