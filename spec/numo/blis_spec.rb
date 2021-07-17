# frozen_string_literal: true

RSpec.describe Numo::BLIS do
  it 'has a version number' do
    expect(Numo::BLIS::VERSION).not_to be nil
    expect(Numo::BLIS::BLIS_VERSION).not_to be nil
  end
end
