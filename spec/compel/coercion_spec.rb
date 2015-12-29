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
          raise_error Compel::TypeError, "'123abc' is not a valid Integer"
      end

    end

    context 'Float' do

      it 'should coerce' do
        value = Compel::Coercion.coerce!('1.2', Float)

        expect(value).to eq(1.2)
      end

      it 'should not coerce' do
        expect(Compel::Coercion.valid?('1.a233', Float)).to eq(false)

        expect { Compel::Coercion.coerce!('1.a233', Float) }.to \
          raise_error Compel::TypeError, "'1.a233' is not a valid Float"
      end

    end

    context 'String' do

      it 'should coerce' do
        value = Compel::Coercion.coerce!('abc', String)

        expect(value).to eq('abc')
      end

      it 'should not coerce' do
        value = 1.2

        expect(Compel::Coercion.valid?(value, String)).to eq(false)

        expect { Compel::Coercion.coerce!(value, String) }.to \
          raise_error Compel::TypeError, "'#{value}' is not a valid String"
      end

    end

    context 'Date' do

      it 'should coerce with default format' do
        value = Compel::Coercion.coerce!('2015-12-22', Date)

        expect(value).to eq(Date.parse('2015-12-22'))
      end

      it 'should coerce with format' do
        value = Compel::Coercion.coerce!('22-12-2015', Date, { format: '%d-%m-%Y' })

        expect(value).to eq(Date.strptime('22-12-2015', '%d-%m-%Y'))
      end

      it 'should not coerce' do
        value = '2015-0'

        expect(Compel::Coercion.valid?(value, Date)).to eq(false)

        expect { Compel::Coercion.coerce!(value, Date) }.to \
          raise_error \
            Compel::TypeError,
            "'#{value}' is not a parsable date with format: %Y-%m-%d"
      end

      it 'should not coerce 1' do
        default_format = '%Y-%m-%d'
        value = '22-12-2015'

        expect { Compel::Coercion.coerce!(value, Date) }.to \
          raise_error \
            Compel::TypeError,
            "'#{value}' is not a parsable date with format: #{default_format}"
      end

    end

    context 'DateTime & Time' do

      it 'should coerce' do
        [DateTime, Time].each do |time_klass|
          value = Compel::Coercion.coerce!('2015-12-22', time_klass, format: '%Y-%m-%d')

          expect(value).to be_a time_klass
          expect(value.year).to eq(2015)
          expect(value.month).to eq(12)
          expect(value.day).to eq(22)
        end

      end

      it 'should coerce iso8601 format' do
        [DateTime, Time].each do |time_klass|
          value = Compel::Coercion.coerce!('2015-12-22T09:30:10', time_klass)

          expect(value).to be_a time_klass
          expect(value.year).to eq(2015)
          expect(value.month).to eq(12)
          expect(value.day).to eq(22)
          expect(value.hour).to eq(9)
          expect(value.min).to eq(30)
          expect(value.sec).to eq(10)
        end
      end

      it 'should not coerce' do
        default_format = '%FT%T'
        value = '22-12-2015'

        [DateTime, Time].each do |time_klass|
          type_down_cased = "#{time_klass}".downcase

          expect { Compel::Coercion.coerce!('22-12-2015', time_klass) }.to \
            raise_error \
              Compel::TypeError,
              "'#{value}' is not a parsable #{type_down_cased} with format: #{default_format}"
        end

      end

    end

    context 'Hash' do

      it 'should coerce' do
        value = Compel::Coercion.coerce!({
          first_name: 'Joaquim',
          last_name: 'Adráz'
        }, Hash)

        expect(value).to eq({
          'first_name' => 'Joaquim',
          'last_name' => 'Adráz'
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
          raise_error Compel::TypeError, "'123' is not a valid Hash"
      end

      it 'should not coerce 1' do
        expect { Compel::Coercion.coerce!('hash', Hash) }.to \
          raise_error Compel::TypeError, "'hash' is not a valid Hash"
      end

      it 'should not coerce 2' do
        expect { Compel::Coercion.coerce!(['hash'], Hash) }.to \
          raise_error Compel::TypeError, "'[\"hash\"]' is not a valid Hash"
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

    context 'Boolean' do

      it 'should coerce false' do
        value = Compel::Coercion.coerce!('f', Compel::Coercion::Boolean)

        expect(value).to eq(false)
      end

      it 'should coerce false 1' do
        value = Compel::Coercion.coerce!('0', Compel::Coercion::Boolean)

        expect(value).to eq(false)
      end

      it 'should coerce true' do
        value = Compel::Coercion.coerce!('t', Compel::Coercion::Boolean)

        expect(value).to eq(true)
      end

      it 'should coerce true 1' do
        value = Compel::Coercion.coerce!('true', Compel::Coercion::Boolean)

        expect(value).to eq(true)
      end

      it 'should not coerce' do
        expect{ Compel::Coercion.coerce!('trye', Compel::Coercion::Boolean) }.to \
         raise_error Compel::TypeError, "'trye' is not a valid Boolean"
      end

    end

    context 'Array' do

      it 'should not coerce' do
        expect { Compel::Coercion.coerce!(123, Compel::Coercion::Array) }.to \
          raise_error Compel::TypeError, "'123' is not a valid Array"
      end

      it 'should coerce' do
        value = Compel::Coercion.coerce!([1, 2], Compel::Coercion::Array)

        expect(value).to eq([1, 2])
      end

    end

  end

end
