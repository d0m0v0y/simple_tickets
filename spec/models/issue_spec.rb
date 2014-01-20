require 'spec_helper'
require 'ffaker'

describe Issue do
  describe 'issue creation' do
    before :each do
      @issue = Issue.new(
          reporter_name: Faker::Name.name,
          reporter_email: Faker::Internet.email,
          subject: Faker::Lorem.sentence(7),
          description: Faker::Lorem.paragraph(5)
      )
    end

    it 'is valid with reporter_name, reporter_email, department_id, subject, description' do
      expect(@issue).to be_valid
    end

    it 'is invalid without reporter_name' do
      @issue.reporter_name = nil
      expect(@issue).not_to be_valid
    end

    it 'is invalid without reporter_email' do
      @issue.reporter_email = nil
      expect(@issue).not_to be_valid
    end

    it 'is invalid without subject' do
      @issue.subject = nil
      expect(@issue).not_to be_valid
    end

    it 'is invalid without description' do
      @issue.description = nil
      expect(@issue).not_to be_valid
    end

    it 'has status "waiting_for_staff_respose"' do
      @issue.save
      expect(@issue.status).to eq 'waiting_for_staff_response'
    end
  end

  describe 'scoped searches' do
    before :each do
      issue_1 = create :issue, subject: 'subj one'
      issue_2 = create :issue, subject: 'subj second', status: :waiting_for_customer, user: create(:user)
      issue_3 = create :issue, subject: 'subject three', status: :on_hold
      issue_4 = create :issue, subject: 'subject four', status: :cancelled, user: create(:user)
      issue_5 = create :issue, subject: 'sub five', status: :completed, user: create(:user)
    end
    context 'new unassigned issues' do
      it 'returns all unassigned issues' do
        expect(Issue.unassigned.count).to eq 2
      end
    end
    context 'open issues' do
      it 'returns number of "open" issues' do
        expect(Issue.opened.count).to eq 3
      end
    end
    context 'on_hold issues' do
      it 'returns count of "on_hold" issues' do
        expect(Issue.on_hold.count).to eq 1
      end
    end
    context 'closed issues' do
      it 'returns number of "closed" issues' do
        expect(Issue.closed.count).to eq 2
      end
    end
  end

  describe 'class methods' do
    describe 'department name' do
      context 'department name present' do
        it 'returns name of associated department' do
          department = create :department, name: 'dep_1'
          issue = create :issue, department: department
          expect(issue.department_name).to eq department.name
        end
      end
      context 'department name is nil' do
        it 'returns nil' do
          issue = create :issue, department: nil
          expect(issue.department_name).to be_nil
        end
      end
    end
    describe 'assigned_to' do
      context 'issue is assigned' do
        it 'returns username of assignie' do
          user = create :user
          issue = create :issue, user: user
          expect(issue.assigned_to).to eq user.username
        end
      end
      context 'issue is new and does not assigned' do
        it 'returns nil' do
          issue = create :issue
          expect(issue.assigned_to).to be_nil
        end
      end
    end
  end

end
