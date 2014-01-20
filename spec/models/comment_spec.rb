require 'spec_helper'
require 'ffaker'

describe Comment do
  describe 'simple model' do
    it 'is valid with body' do
      comment = Comment.new(body: Faker::Lorem.paragraph(5))
      expect(comment).to be_valid
    end
  end

  describe 'class methods' do
    describe 'author name of comment' do
      context 'from logged user' do
        it 'returns logged user username' do
          user = create :user
          comment = create :comment, user: user
          expect(comment.author).to eq user.username
        end
      end

      context 'from "customer"' do
        it 'returns reporter_name from issue' do
          comment = create :comment
          expect(comment.author).to eq comment.issue.reporter_name
        end
      end

    end
  end
end
