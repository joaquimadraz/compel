describe Compel::Builder do

  context 'Schema' do

    subject(:builder) { Compel::Builder::String.new }

    it 'shoudl' do
      object = {
        first_name: 'Joaquim',
        birth_date: '1989-0',
        address: {
          line_one: 'Lisboa',
          post_code: '1100',
          country_code: 'PT'
        }
      }

      schema = Compel.hash.keys({
        first_name: Compel.string.required,
        last_name: Compel.string.required,
        birth_date: Compel.date.iso8601,
        address: Compel.hash.keys({
          line_one: Compel.string.required,
          line_two: Compel.string.default('-'),
          post_code: Compel.string.format(/^\d{4}-\d{3}$/).required,
          country_code: Compel.string.in(['PT', 'GB']).default('PT')
        })
      })

      result = Compel.run(object, schema)

      expect(result).to \
        eq({
          "first_name" => "Joaquim",
          "birth_date" => "1989-0",
          "address" => {
            "line_one" => "Lisboa",
            "post_code" => "1100",
            "country_code" => "PT",
            "line_two" => "-"
          },
          "errors" => {
            "last_name" => ["is required"],
            "birth_date" => ["'1989-0' is not a parsable date with format: %Y-%m-%d"],
            "address" => {
              "post_code" => ["must match format ^\\d{4}-\\d{3}$"]
            }
          }
        })
    end

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

    it 'should validate hash object from schema' do
      schema = Compel.hash.keys({
        a: Compel.float.required
      })

      expect(schema.validate({ a: nil }).errors.a).to \
        include('is required')
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

        it 'should have value' do
          builder.iso8601

          expect(builder.options[:format]).to eq('%Y-%m-%d')
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

      context '#min_length' do

        it 'should raise exception for invalid type' do
          expect { builder.min_length('a') }.to \
            raise_error Compel::TypeError, "'a' is not a valid Integer"
        end

        it 'should have value' do
          builder.min_length(4)

          expect(builder.options[:min_length]).to eq(4)
        end

      end

      context '#max_length' do

        it 'should raise exception for invalid type' do
          expect { builder.max_length('a') }.to \
            raise_error Compel::TypeError, "'a' is not a valid Integer"
        end

        it 'should have value' do
          builder.max_length(10)

          expect(builder.options[:max_length]).to eq(10)
        end

      end

    end

  end

end
