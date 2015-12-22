describe Compel::Contract do

  context '#conditions' do

    it 'should build with conditions block option' do
      contract = \
        Compel::Contract.new({ first_name: 'Joaquim' }) do
          param :address, Hash, required: true do
            param :post_code, String
          end
        end

      expect(contract.conditions[:address].type).to eq(Hash)
      expect(contract.conditions[:address].required?).to eq(true)
      expect(contract.conditions[:address].conditions?).to eq(true)
    end

  end

  context 'params' do

    it 'should return coerced params' do
      contract = \
        Compel::Contract.new(date: '2015-12-22') { param :date, DateTime }
          .validate

      expect(contract.coerced_params.date).to be_a DateTime
      expect(contract.coerced_params.date.year).to eq(2015)
      expect(contract.coerced_params.date.month).to eq(12)
      expect(contract.coerced_params.date.day).to eq(22)
    end

  end


end
