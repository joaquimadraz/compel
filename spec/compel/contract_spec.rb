describe Compel::Contract do

  context '#complete_params' do

    it 'should build for coercion and validation' do
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

    context 'nested Hash' do

      def complete_params_for(params)
        contract = \
          Compel::Contract.new(params) do
            param :address, Hash do
              param :line_one, String
              param :line_two, String
              param :post_code, Hash, required: true do
                param :prefix, Integer, length: 4
                param :suffix, Integer, length: 3
                param :country, Hash do
                  param :code, String, length: 2, required: true
                  param :name, String
                end
              end
            end
          end

        contract.complete_params
      end

      it 'should build empty params for root key' do
        complete_params = complete_params_for({})

        expect(complete_params).to eq \
          Hashie::Mash.new({
            address: nil
          })
      end

    end

  end

  context '#conditions' do

    it 'should build with conditions block option' do
      contract = \
        Compel::Contract.new({ first_name: 'Joaquim' }) do
          param :address, Hash, required: true do
            param :post_code, String
          end
        end

      expect(contract.conditions[:address][:type]).to eq(Hash)
      expect(contract.conditions[:address][:options][:required]).to eq(true)
      expect(contract.conditions[:address][:conditions]).not_to be_nil
    end

  end

end
