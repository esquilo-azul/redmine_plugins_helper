# frozen_string_literal: true

RSpec.shared_examples 'with logged user', shared_context: :metadata do |username|
  fixtures :users

  before do
    visit '/login'
    fill_in 'username', with: username
    fill_in 'password', with: username
    find_by_id('login-submit').click # rubocop:disable Rails/DynamicFindBy
  end

  it("logged user has login \"#{username}\"") { expect(::User.current.login).to eq(username) }
end
