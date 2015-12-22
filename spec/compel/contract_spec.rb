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

end
