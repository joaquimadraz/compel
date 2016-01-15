describe Compel::Validation do

  context 'required' do

    it 'should validate without errors' do
      errors = Compel::Validation.validate(123, Compel::Coercion::Integer, { required: true })

      expect(errors.empty?).to eq(true)
    end

    it 'should validate with error' do
      errors = Compel::Validation.validate(nil,  Compel::Coercion::Integer, { required: true })

      expect(errors.empty?).to eq(false)
      expect(errors).to eq(['is required'])
    end

  end

  context 'length' do

    it 'should validate without errors' do
      errors = Compel::Validation.validate(123,  Compel::Coercion::Integer, { length: 3 })

      expect(errors.empty?).to eq(true)
    end

  end

  context 'in, range' do

    def expect_be_in_range(range, value)
      [:in, :range].each do |key|
        errors = Compel::Validation.validate(value,  Compel::Coercion::String, { key => range })
        yield errors
      end
    end

    it 'should validate without errors' do
      expect_be_in_range(['PT', 'UK'], 'PT') do |errors|
        expect(errors.empty?).to eq(true)
      end
    end

    it 'should validate with errors' do
      expect_be_in_range(['PT', 'UK'], 'US') do |errors|
        expect(errors).to include('must be within ["PT", "UK"]')
      end
    end

    context 'range' do

      it 'should validate without errors' do
        errors = Compel::Validation.validate(2, Compel::Coercion::Integer, range: (1..3))

        expect(errors.empty?).to eq(true)
      end

      it 'should validate with errors' do
        errors = Compel::Validation.validate(4, Compel::Coercion::Integer, range: (1..3))

        expect(errors).to include('must be within 1..3')
      end

    end

  end

  context 'format' do

    it 'should validate with errors' do
      format = /^abcd/
      errors = Compel::Validation.validate('acb', Compel::Coercion::String, format: format)

      expect(errors).to include("must match format ^abcd")
    end

    it 'should validate without errors' do
      format = /abcd/
      errors = Compel::Validation.validate('abcd', Compel::Coercion::String, format: format)
      expect(errors.empty?).to eq(true)
    end

  end

  context 'is' do

    it 'should validate with errors' do
      errors = Compel::Validation.validate('abcd', Compel::Coercion::Integer, is: 123)
      expect(errors).to include('must be 123')
    end

    it 'should validate with errors 1' do
      errors = Compel::Validation.validate(nil, Compel::Coercion::Integer, is: 123)
      expect(errors).to include('must be 123')
    end

    it 'should validate without errors' do
      errors = Compel::Validation.validate(123, Compel::Coercion::Integer, is: 123)
      expect(errors.empty?).to eq(true)
    end

  end

  context 'min' do

    it 'should validate without errors for Integer' do
      errors = Compel::Validation.validate(2, Compel::Coercion::Integer, min: 1)

      expect(errors.empty?).to be true
    end

    it 'should validate without errors for String' do
      errors = Compel::Validation.validate('b', Compel::Coercion::String, min: 'a')

      expect(errors.empty?).to be true
    end

    it 'should validate with errors' do
      errors = Compel::Validation.validate(1, Compel::Coercion::Integer, min: 3)

      expect(errors).to include('cannot be less than 3')
    end

    it 'should validate with errors for String' do
      errors = Compel::Validation.validate('a', Compel::Coercion::String, min: 'b')

      expect(errors).to include('cannot be less than b')
    end

    it 'should validate with errors for Float' do
      errors = Compel::Validation.validate(1.54, Compel::Coercion::Float, min: 1.55)

      expect(errors).to include('cannot be less than 1.55')
    end

  end

  context 'max' do

    it 'should validate without errors' do
      errors = Compel::Validation.validate(5, Compel::Coercion::Integer, min: 5)

      expect(errors.empty?).to be true
    end

    it 'should validate with errors' do
      errors = Compel::Validation.validate(3, Compel::Coercion::Integer, max: 2)

      expect(errors).to include('cannot be greater than 2')
    end

    it 'should validate without errors for Integer' do
      errors = Compel::Validation.validate(2, Compel::Coercion::Integer, max: 3)

      expect(errors.empty?).to be true
    end

    it 'should validate without errors for String' do
      errors = Compel::Validation.validate('b', Compel::Coercion::String, max: 'd')

      expect(errors.empty?).to be true
    end

    it 'should validate with errors for String' do
      errors = Compel::Validation.validate('c', Compel::Coercion::String, max: 'b')

      expect(errors).to include('cannot be greater than b')
    end

    it 'should validate with errors for Float' do
      errors = Compel::Validation.validate(1.56, Compel::Coercion::Float, max: 1.55)

      expect(errors).to include('cannot be greater than 1.55')
    end

  end

  context 'min_length' do

    it 'should validate with errors 1' do
      errors = Compel::Validation.validate('a', Compel::Coercion::String, min_length: 2)

      expect(errors).to include('cannot have length less than 2')
    end

    it 'should validate without errors' do
      errors = Compel::Validation.validate('ab', Compel::Coercion::String, min_length: 2)

      expect(errors.empty?).to eq(true)
    end

    it 'should validate without errors 1' do
      errors = Compel::Validation.validate(3, Compel::Coercion::Integer, min_length: 2)

      expect(errors).to include('cannot have length less than 2')
    end

  end

  context 'max_length' do

    it 'should validate with errors 1' do
      errors = Compel::Validation.validate('abcdef', Compel::Coercion::String, max_length: 5)

      expect(errors).to include('cannot have length greater than 5')
    end

    it 'should validate without errors' do
      errors = Compel::Validation.validate('abcde', Compel::Coercion::String, max_length: 5)

      expect(errors.empty?).to eq(true)
    end

    it 'should validate without errors 1' do
      errors = Compel::Validation.validate(1, Compel::Coercion::Integer, max_length: 2)

      expect(errors.empty?).to eq(true)
    end

  end

end
