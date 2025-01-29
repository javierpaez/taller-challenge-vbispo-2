
require 'rails_helper'

RSpec.describe "Books Reserve API", type: :request do
  let(:author) { Author.create!(name: "J.K. Rowling") }
  let(:book) { Book.create!(title: "Book 1", author_id: author.id, publication_date: 3.days.ago, rating: 3) }
  
  describe "POST /books/:id/reserve" do
    it "is successful when reserve a book not checked out or reserved" do
      email = "john@doe.com"
      post book_reserve_path(book), params: { email: }

      expect(response).to have_http_status(:success)

      book.reload
      expect(book.reservation_email).to eq email
      expect(book.status.to_sym).to eq :reserved
    end

    it "doesn't allow to reserve a book checked out" do
      # Arrange
      email = "john@doe.com"
      book.update(status: :checked_out)

      # Act
      post book_reserve_path(book), params: { email: }

      # Assert
      expect(response).to have_http_status(:unprocessable_entity)

      book.reload
      expect(book.reservation_email).not_to eq email
      expect(book.status.to_sym).to eq :checked_out
    end

    it "doesn't allow to reserve a book reserved" do
      # Arrange
      email = "john@doe.com"
      book.reserve!(email: "jane@doe.com")

      # Act
      post book_reserve_path(book), params: { email: }

      # Assert
      expect(response).to have_http_status(:unprocessable_entity)

      book.reload
      expect(book.reservation_email).not_to eq email
      expect(book.status.to_sym).to eq :reserved
    end
  end
end
