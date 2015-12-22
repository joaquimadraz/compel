describe Compel::Contract do

  context '#complete_params' do

    it 'should build complete_params for coercion and validation' do
      contract = \
        Compel::Contract.new({ first_name: 'Joaquim' }) do
          param :first_name, String, required: true
          param :last_name, String, required: true
        end

      expect(contract.complete_params).to eq \
        Hashie::Mash.new({
          first_name: 'Joaquim',
          last_name: nil
        })
    end

  end

end
