require 'spec_helper'
require 'ffaker'

include Warden::Test::Helpers
Warden.test_mode!

feature Issue do
  context 'Anonymous user' do
    scenario 'Create new issue' do
      visit root_path
      expect {
        fill_in 'Reporter name', with: 'Vasija Pupkin'
        fill_in 'Reporter email', with: 'vasija@example.com'
        find('#issue_department_id').find(:xpath, '//option[1]').select_option
        fill_in 'Subject', with: Faker::Lorem.sentence(5)
        fill_in 'Description', with: Faker::Lorem.paragraph(7)
        click_button 'Submit'
      }.to change(Issue, :count).by(1)

      invite_email = ActionMailer::Base.deliveries.last
      expect(invite_email.to[0]).to eq 'vasija@example.com'

    end

    scenario 'View issue details' do
      issue = create :issue

      visit issue_path(issue)
      within("div#issue_details") do
        expect(page).to have_content(issue.reporter_name)
        expect(page).to have_content(issue.reporter_email)
        expect(page).to have_content(issue.status)
        expect(page).to have_content(issue.subject)
        expect(page).to have_content(issue.description)
      end
    end

    scenario 'Leave comment' do
      issue = create :issue
      visit issue_path(issue)
      fill_in 'comment_body', with: 'Comment from Test'
      click_on 'Submit'
      within('#comments_container') do
        expect(page).to have_content(issue.reporter_name)
        expect(page).to have_content('Comment from Test')
      end
    end

    scenario 'View issues list' do
      visit issues_path
      expect(page.current_path).to eq(new_user_session_path)
    end

  end

  context 'Logged In User' do
    before :each do
      @user = FactoryGirl.create(:user)
      login_as(@user, :scope => :user)

      @issue_1 = create :issue, subject: 'subj one'
      @issue_2 = create :issue, subject: 'subj second', status: :waiting_for_customer, user: create(:user)
      @issue_3 = create :issue, subject: 'subject three', status: :on_hold
      @issue_4 = create :issue, subject: 'subject four', status: :cancelled, user: create(:user)
      @issue_5 = create :issue, subject: 'sub five', status: :completed, user: create(:user)

    end

    scenario 'Leave comment' do
      visit issue_path(@issue_1)
      fill_in 'comment_body', with: 'Comment from logged_in user'
      find('#submit_comment').click
      within('#comments_container') do
        expect(page).to have_content(@user.username)
        expect(page).to have_content('Comment from logged_in user')
      end
    end

    scenario 'View list of issues' do
      visit issues_path
      Issue.all.each do |issue|
        within("#issue_#{issue.id}") do
          expect(page).to have_link(issue.id)
          expect(page).to have_content(issue.reporter_name)
          expect(page).to have_link(issue.subject)
          expect(page).to have_content(issue.status)
        end
      end
    end

    scenario 'View unassigned issues' do
      visit issues_path
      click_link("Unassigned")
      expect(page.all('table#issues_list tr').count). to eq 2
      within("#issues_list") do
        expect(page).to have_content(@issue_1.subject)
        expect(page).to have_content(@issue_3.subject)
      end
    end

    scenario 'View opened issues' do
      visit issues_path
      click_link("Opened")
      expect(page.all('table#issues_list tr').count).to eq 3
      within("#issues_list") do
        expect(page).to have_content(@issue_1.subject)
        expect(page).to have_content(@issue_2.subject)
        expect(page).to have_content(@issue_3.subject)
      end
    end

    scenario 'View on_hold issues' do
      visit issues_path
      click_link("On Hold")
      expect(page.all('table#issues_list tr').count).to eq 1
      within("#issue_#{@issue_3.id}") do
        expect(page).to have_content(@issue_3.subject)
      end
    end

    scenario 'View closed tickets' do
      visit issues_path
      click_link("Closed")
      expect(page.all('table#issues_list tr').count).to eq 2
      within("#issues_list") do
        expect(page).to have_content(@issue_4.subject)
        expect(page).to have_content(@issue_5.subject)
      end
    end

    feature 'Search issues' do
      scenario 'by subject' do
        visit issues_path
        fill_in 'filtered', with: 'subject'
        find('#search_button').click
        expect(page.all('table#issues_list tr').count).to eq 2
      end
      scenario 'by issue number' do
        visit issues_path
        fill_in 'filtered', with: '1'
        find('#search_button').click
        expect(page.all('table#issues_list tr').count).to eq 1
        within("#issues_list") do
          expect(page).to have_content(@issue_1.subject)
        end
      end
    end

    scenario 'List with pagination' do
      10.times { create :issue }
      visit issues_path
      expect(page.all('table#issues_list tr').count).to eq 10
    end

  end

end