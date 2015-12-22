describe Compel::Coercion do

  context '#run' do

    def coerce(params, contract)
      coercion = Compel::Coercion.new(params, contract)
      coercion.run
      coercion
    end

    it 'should coerce a list of params' do
      params = {
        age: 26,
        year: 2015
      }

      contract = {
        age: { type: Integer },
        year: { type: Integer }
      }

      coercion = coerce(params, contract)

      expect(coercion.errors.empty?).to eq(true)
    end

    it 'should not coerce a list of params' do
      params = {
        year: 2015,
        month: 'December'
      }

      contract = {
        year: { type: Integer },
        month: { type: Integer }
      }

      coercion = coerce(params, contract)

      expect(coercion.errors.empty?).to eq(false)
      expect(coercion.errors.to_hash).to eq({
        month: ["'December' is not a valid Integer"]
      })
    end

  end

  context 'Type coercion' do

    context 'Integer' do

      it 'should coerce' do
        value = Compel::Coercion.coerce(123, Integer)
        expect(value).to eq(123)
      end

      it 'should coerce 1' do
        value = Compel::Coercion.coerce('123', Integer)
        expect(value).to eq(123)
      end

      it 'should coerce 2' do
        value = Compel::Coercion.coerce(123.3, Integer)
        expect(value).to eq(123)
      end

      it 'should not coerce' do
        expect(Compel::Coercion.valid?('123abc', Integer)).to eq(false)

        expect { Compel::Coercion.coerce('123abc', Integer) }.to \
          raise_error Compel::InvalidParameterError, "'123abc' is not a valid Integer"
      end

    end

    context 'Hash' do

      it 'should coerce' do
        value = Compel::Coercion.coerce({
          first_name: 'Joaquim',
          last_name: 'Adráz'
        }, Hash)

        expect(value).to eq({
          first_name: 'Joaquim',
          last_name: 'Adráz'
        })
      end

      it 'should coerce 1' do
        value = Compel::Coercion.coerce({
          'first_name' => 'Joaquim',
          'last_name' => 'Adráz'
        }, Hash)

        expect(value).to eq({
          'first_name' => 'Joaquim',
          'last_name' => 'Adráz'
        })
      end

      it 'should coerce 2' do
        value = Compel::Coercion.coerce(Hashie::Mash.new({
          first_name: 'Joaquim',
          last_name: 'Adráz'
        }), Hash)

        expect(value).to eq({
          'first_name' => 'Joaquim',
          'last_name' => 'Adráz'
        })
      end

      it 'should not coerce' do
        expect { Compel::Coercion.coerce(123, Hash) }.to \
          raise_error Compel::InvalidParameterError, "'123' is not a valid Hash"
      end

      it 'should not coerce 1' do
        expect { Compel::Coercion.coerce('hash', Hash) }.to \
          raise_error Compel::InvalidParameterError, "'hash' is not a valid Hash"
      end

      it 'should not coerce 2' do
        expect { Compel::Coercion.coerce(['hash'], Hash) }.to \
          raise_error Compel::InvalidParameterError, "'[\"hash\"]' is not a valid Hash"
      end

    end

    context 'JSON' do

      it 'should coerce' do
        value = Compel::Coercion.coerce \
          "{\"first_name\":\"Joaquim\",\"last_name\":\"Adráz\"}", JSON

        expect(value).to eq({
          'first_name' => 'Joaquim',
          'last_name' => 'Adráz'
        })
      end

    end

  end

end
