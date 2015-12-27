require 'pry'

describe Compel::Builder do

  context 'Schema' do

    subject(:builder) { Compel::Builder::String.new }

    it 'should build new Schema for givin type' do
      expect(builder.type).to be(Compel::Coercion::String)
      expect(builder.options.keys).to eq([])
      expect(builder.required?).to be false
      expect(builder.default_value).to be nil
    end

    it 'should build Schema' do
      schema = Compel.hash.keys({
        a: Compel.float,
        b: Compel.string,
        c: Compel.hash.keys({
          cc: Compel.integer.length(1)
        }),
        d: Compel.json,
        e: Compel.time,
        f: Compel.datetime,
        g: Compel.date,
        h: Compel.integer
      })

      keys_schemas = schema.options[:keys]

      expect(keys_schemas.a.type).to be Compel::Coercion::Float
      expect(keys_schemas.b.type).to be Compel::Coercion::String
      expect(keys_schemas.c.type).to be Compel::Coercion::Hash
      expect(keys_schemas.d.type).to be Compel::Coercion::JSON
      expect(keys_schemas.e.type).to be Compel::Coercion::Time
      expect(keys_schemas.f.type).to be Compel::Coercion::DateTime
      expect(keys_schemas.g.type).to be Compel::Coercion::Date
      expect(keys_schemas.h.type).to be Compel::Coercion::Integer
    end

    context 'Builder::CommonValue' do

      context '#in, #range, #min, #max' do

        it 'should have value' do
          [:in, :range, :min, :max].each do |method|
            builder.send(method, "#{method}")
            expect(builder.options[method]).to eq("#{method}")
          end
        end

      end

    end

    context 'Builder::Common' do

      context '#is, #default' do

        it 'should have value' do
          [:is, :default].each do |method|
            builder.send(method, "#{method}")
            expect(builder.options[method]).to eq("#{method}")
          end
        end

      end

      context '#required' do

        it 'should be false' do
          expect(builder.required?).to be false
        end

        it 'should be true' do
          builder.required

          expect(builder.required?).to be true
        end

      end

      context '#length' do

        it 'should have value' do
          builder.length(5)

          expect(builder.options[:length]).to be 5
        end

        it 'should raise exception for invalid type' do
          expect { builder.length('abc') }.to \
            raise_error Compel::TypeError, "'abc' is not a valid Integer"
        end

      end

    end

    context 'Date' do

      subject(:builder) { Compel::Builder::Date.new }

      context '#format' do

        it 'should have value' do
          builder.format('%d-%m-%Y')

          expect(builder.options[:format]).to eq('%d-%m-%Y')
        end

      end

    end

    context 'String' do

      context '#format' do

        it 'should raise exception for invalid type' do
          expect { builder.format('abc') }.to \
            raise_error Compel::TypeError, "'abc' is not a valid Regexp"
        end

        it 'should have value' do
          builder.format(/1/)

          expect(builder.options[:format]).to eq(/1/)
        end

      end

    end

  end

end
