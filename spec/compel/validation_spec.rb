describe Compel::Validation do

  context '#run' do

    def validate(params, contract)
      validation = Compel::Validation.new(params, contract)
      validation.run
      validation
    end

    it 'should validate a list of params' do
      params = {
        age: 26,
        year: 2015
      }

      contract = {
        age: { type: Integer, options: { required: true, min: 25 } },
        year: { type: Integer, options: { required: true } }
      }

      validation = validate(params, contract)

      expect(validation.errors.empty?).to eq(true)
    end

  end

  context 'Param validation' do

    context 'required' do

      it 'should validate without errors' do
        errors = Compel::Validation.validate(123, { required: true })

        expect(errors.empty?).to eq(true)
      end

      it 'should validate with error' do
        errors = Compel::Validation.validate(nil, { required: true })

        expect(errors.empty?).to eq(false)
        expect(errors).to eq(['is required'])
      end

    end

  end

end
