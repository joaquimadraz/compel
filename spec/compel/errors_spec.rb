describe Compel::Errors do

  it 'should add error' do
    errors = Compel::Errors.new
    errors.add(:first_name, 'is required')

    expect(errors.to_hash[:first_name]).to include('is required')
  end

  it 'should add multiple errors' do
    errors = Compel::Errors.new
    errors.add(:first_name, 'is required')
    errors.add(:first_name, 'is invalid')

    expect(errors.to_hash[:first_name]).to include('is required')
    expect(errors.to_hash[:first_name]).to include('is invalid')
  end

  it 'should add Compel::Errors' do
    address_errors = Compel::Errors.new
    address_errors.add(:line_one, 'is required')
    address_errors.add(:post_code, 'must be an Hash')

    errors = Compel::Errors.new
    errors.add(:address, address_errors)

    expect(errors.to_hash[:address][:line_one]).to include('is required')
    expect(errors.to_hash[:address][:post_code]).to include('must be an Hash')
  end

  it 'should add nested Compel::Errors' do
    post_code_errors = Compel::Errors.new
    post_code_errors.add(:prefix, 'is invalid')
    post_code_errors.add(:suffix, 'is required')

    address_errors = Compel::Errors.new
    address_errors.add(:line_one, 'is required')
    address_errors.add(:post_code, post_code_errors)

    errors = Compel::Errors.new
    errors.add(:address, address_errors)

    expect(errors.to_hash[:address][:line_one]).to include('is required')
    expect(errors.to_hash[:address][:post_code][:prefix]).to include('is invalid')
    expect(errors.to_hash[:address][:post_code][:suffix]).to include('is required')
  end

end
