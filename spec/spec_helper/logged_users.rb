# frozen_string_literal: true

RSpec.shared_examples 'with logged user', shared_context: :metadata do |username|
  before do
    visit '/login'
    fill_in 'username', with: username
    fill_in 'password', with: username
    find_by_id('login-submit').click # rubocop:disable Rails/DynamicFindBy
  end

  it('User.current is filled') { expect(::User.current).not_to be_nil }
end
