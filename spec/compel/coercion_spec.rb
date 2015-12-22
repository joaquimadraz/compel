describe Compel::Coercion do

  context 'Type coercion' do

    context 'Integer' do

      it 'should coerce' do
        value = Compel::Coercion.coerce!(123, Integer)
        expect(value).to eq(123)
      end

      it 'should coerce 1' do
        value = Compel::Coercion.coerce!('123', Integer)
        expect(value).to eq(123)
      end

      it 'should coerce 2' do
        value = Compel::Coercion.coerce!(123.3, Integer)
        expect(value).to eq(123)
      end

      it 'should not coerce' do
        expect(Compel::Coercion.valid?('123abc', Integer)).to eq(false)

        expect { Compel::Coercion.coerce!('123abc', Integer) }.to \
          raise_error Compel::ParamTypeError, "'123abc' is not a valid Integer"
      end

    end

    context 'Hash' do

      it 'should coerce' do
        value = Compel::Coercion.coerce!({
          first_name: 'Joaquim',
          last_name: 'Adráz'
        }, Hash)

        expect(value).to eq({
          first_name: 'Joaquim',
          last_name: 'Adráz'
        })
      end

      it 'should coerce 1' do
        value = Compel::Coercion.coerce!({
          'first_name' => 'Joaquim',
          'last_name' => 'Adráz'
        }, Hash)

        expect(value).to eq({
          'first_name' => 'Joaquim',
          'last_name' => 'Adráz'
        })
      end

      it 'should coerce 2' do
        value = Compel::Coercion.coerce!(Hashie::Mash.new({
          first_name: 'Joaquim',
          last_name: 'Adráz'
        }), Hash)

        expect(value).to eq({
          'first_name' => 'Joaquim',
          'last_name' => 'Adráz'
        })
      end

      it 'should not coerce' do
        expect { Compel::Coercion.coerce!(123, Hash) }.to \
          raise_error Compel::ParamTypeError, "'123' is not a valid Hash"
      end

      it 'should not coerce 1' do
        expect { Compel::Coercion.coerce!('hash', Hash) }.to \
          raise_error Compel::ParamTypeError, "'hash' is not a valid Hash"
      end

      it 'should not coerce 2' do
        expect { Compel::Coercion.coerce!(['hash'], Hash) }.to \
          raise_error Compel::ParamTypeError, "'[\"hash\"]' is not a valid Hash"
      end

    end

    context 'JSON' do

      it 'should coerce' do
        value = Compel::Coercion.coerce! \
          "{\"first_name\":\"Joaquim\",\"last_name\":\"Adráz\"}", JSON

        expect(value).to eq({
          'first_name' => 'Joaquim',
          'last_name' => 'Adráz'
        })
      end

    end

  end

end
