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

    context 'length' do

      it 'should validate without errors' do
        errors = Compel::Validation.validate(123, { length: 3 })

        expect(errors.empty?).to eq(true)
      end

    end

    context 'in, within, range' do

      def expect_be_in_within_range(range, value)
        [:in, :within].each do |key|
          errors = Compel::Validation.validate(value, { key => range })
          yield errors
        end
      end

      it 'should validate without errors' do
        expect_be_in_within_range(['PT', 'UK'], 'PT') do |errors|
          expect(errors.empty?).to eq(true)
        end
      end

      it 'should validate with errors' do
        expect_be_in_within_range(['PT', 'UK'], 'US') do |errors|
          expect(errors).to eq(['must be within ["PT", "UK"]'])
        end
      end

      context 'range' do

        it 'should validate without errors' do
          errors = Compel::Validation.validate(2, range: (1..3))

          expect(errors.empty?).to eq(true)
        end

        it 'should validate with errors' do
          errors = Compel::Validation.validate(4, range: (1..3))

          expect(errors).to eq(['must be within 1..3'])
        end

      end

    end

  end

end
