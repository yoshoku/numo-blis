# frozen_string_literal: true

RSpec.describe Numo::BLIS do
  it 'has version numbers', :aggregate_failures do
    expect(Numo::BLIS::VERSION).not_to be_nil
    expect(Numo::BLIS::BLIS_VERSION).not_to be_nil
    expect(Numo::BLIS::LAPACK_VERSION).not_to be_nil
  end

  it 'has library pathes', :aggregate_failures do
    expect(Numo::Linalg::Loader.libs.size).to eq(2)
    expect(Numo::Linalg::Loader.libs).to include(include('libblis'))
    expect(Numo::Linalg::Loader.libs).to include(include('liblapacke'))
  end

  it 'performs linear algebra computation' do
    a = Numo::DFloat.new(5, 20).rand
    c = a.dot(a.transpose)
    evl, evc = Numo::Linalg.eigh(c)
    d = evc.dot(evl.diag).dot(evc.transpose)
    err = Math.sqrt(((c - d)**2).sum)
    expect(err).to be <= 1e-10
  end
end
