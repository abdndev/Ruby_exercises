RSpec.describe 'Пример' do
  it 'должен работать в случае false' do
    expect(false).to be_falsy
  end

  it 'должен работать в случае true' do
    expect(false).to be_truthy
  end
end

