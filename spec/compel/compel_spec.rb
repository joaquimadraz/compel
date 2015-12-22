describe Compel do

  context '#compel' do

    def make_the_call(method, params)
      Compel.send(method, params) do
        param :first_name, String, required: true
        param :last_name, String, required: true
        param :birth_date, DateTime
      end
    end

    it 'should compel' do
      params = {
        first_name: 'Joaquim',
        last_name: 'Adráz',
        birth_date: '1989-08-06T09:00:00'
      }

      expect(make_the_call(:compel?, params)).to eq(true)
    end

    it 'should not compel for invalid params' do
      expect{ make_the_call(:compel, 1) }.to \
        raise_error Compel::InvalidParameterError, 'Compel params must be an Hash'
    end

    it 'should not compel for invalid params 1' do
      expect{ make_the_call(:compel, nil) }.to \
        raise_error Compel::InvalidParameterError, 'Compel params must be an Hash'
    end

    it 'should not compel'  do
      params = {
        first_name: 'Joaquim'
      }

      expect(make_the_call(:compel, params)).to \
        eq({
          last_name: ['is required']
        })
    end

    context 'nested Hash' do

      def make_the_call(method, params)
        Compel.send(method, params) do
          param :address, Hash do
            param :line_one, String
            param :line_two, String
            param :post_code, Hash, required: true do
              param :prefix, Integer, length: 4
              param :suffix, Integer, length: 3
            end
          end
        end
      end

      xit 'should compel' do
        params = {
          address: {
            line_one: 'Lisbon',
            line_two: 'Portugal',
            post_code: {
              prefix: 1100,
              suffix: 100
            }
          }
        }

        expect(make_the_call(:compel?, params)).to eq(true)
      end

      xit 'should not compel' do
        params = {
          address: {
            line_one: 'Lisbon',
            line_two: 'Portugal'
          }
        }

        expect(make_the_call(:compel?, params)).to eq(false)
      end

    end

  end

end
