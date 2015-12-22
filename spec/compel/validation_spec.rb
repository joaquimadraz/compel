describe Compel::Validation do

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
