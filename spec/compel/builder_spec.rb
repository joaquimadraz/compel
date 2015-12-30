describe Compel::Builder do

  context 'Schema' do

    context 'Build' do

      it 'should build new Schema for givin type' do
        builder = Compel.string

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

          subject(:builder) { Compel.string }

          it 'should have value' do
            [:in, :range, :min, :max].each do |method|
              builder.send(method, "#{method}")
              expect(builder.options[method]).to eq("#{method}")
            end
          end

        end

      end

      context 'Builder::Common' do

        subject(:builder) { Compel.string }

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

        subject(:builder) { Compel.date }

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

        subject(:builder) { Compel.string }

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

    context 'Validate' do

      context 'Hash' do

        it 'should validate Hash schema' do
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

          result = schema.validate(object)

          expect(result.value).to \
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

        it 'should validate hash object from schema' do
          schema = Compel.hash.keys({
            a: Compel.float.required
          })

          expect(schema.validate({ a: nil }).errors.a).to \
            include('is required')
        end

      end

      context 'String' do

        it 'should validate Type schema' do
          schema = Compel.string.format(/^\d{4}-\d{3}$/).required
          response = schema.validate('1234')

          expect(response.errors).to \
            include("must match format ^\\d{4}-\\d{3}$")
        end

      end

      context 'Array' do

        subject(:builder) { Compel.array }

        it 'should validate nil without errors' do
          result = builder.validate(nil)

          expect(result.valid?).to be true
        end

        it 'should validate nil with errors' do
          result = builder.required.validate(nil)

          expect(result.errors[:base]).to include('is required')
        end

        it 'should validate with errors for invalid array' do
          result = builder.required.validate(1)

          expect(result.errors[:base]).to include("'1' is not a valid Array")
        end

        context '#items' do

          it 'should validate without items' do
            result = builder.validate([1, 2, 3])

            expect(result.valid?).to be true
            expect(result.value).to eq([1, 2, 3])
          end

          it 'should raise exception for invalid type' do
            expect { builder.items('a') }.to \
              raise_error Compel::TypeError, "#items must be a valid Schema"
          end

          it 'should raise exception for invalid type' do
            expect { builder.items('a') }.to \
              raise_error Compel::TypeError, "#items must be a valid Schema"
          end

          it 'should have value' do
            builder.items(Compel.integer)

            expect(builder.options[:items].class).to be(Compel::Builder::Integer)
          end

          it 'should validate all items' do
            builder.items(Compel.integer)

            result = builder.validate([1, '2', nil])

            expect(result.valid?).to be true
            expect(result.value).to eq([1, 2])
          end

          it 'should validate all items with errors' do
            builder.items(Compel.float.required)

            result = builder.validate([1, 'a', nil])

            expect(result.valid?).to be false
            expect(result.errors['1']).to include("'a' is not a valid Float")
            expect(result.errors['2']).to include('is required')
          end

          it 'should coerce all hash items' do
            builder.items(Compel.hash.keys({
              a: Compel.string.required,
              b: Compel.integer
            }))

            result = builder.validate([
              { a: 'A', b: '1' },
              { a: 'B' },
              { a: 'C', b: 3 },
            ])

            expect(result.valid?).to be true
            expect(result.value).to eq \
              [
                Hashie::Mash.new({ a: 'A', b: 1 }),
                Hashie::Mash.new({ a: 'B' }),
                Hashie::Mash.new({ a: 'C', b: 3 })
              ]
          end

          it 'should coerce all hash items with errors' do
            builder.items(Compel.hash.keys({
              a: Compel.string.required,
              b: Compel.string.format(/^abc$/).required
            }))

            result = builder.validate([
              { a: 'A', b: 'abc' },
              { a: 'B' },
              { a: 'C', b: 'abcd' },
            ])

            expect(result.valid?).to be false
            expect(result.errors['1'][:b]).to include('is required')
            expect(result.errors['2'][:b]).to include('must match format ^abc$')

            expect(result.value[0][:a]).to eq('A')
            expect(result.value[0][:b]).to eq('abc')

            expect(result.value[1][:a]).to eq('B')
            expect(result.value[1][:b]).to be_nil
            expect(result.value[1][:errors][:b]).to include('is required')

            expect(result.value[2][:a]).to eq('C')
            expect(result.value[2][:b]).to eq('abcd')
            expect(result.value[2][:errors][:b]).to \
              include('must match format ^abc$')
          end

          it 'should coerce array with hash items and nested array keys with errors' do
            builder.items(Compel.hash.keys({
              a: Compel.string,
              b: Compel.array.items(Compel.integer.required).required
            }))

            result = builder.validate([
              { a: 'C' },
              { b: [1, 2, 3] },
              { b: ['1', nil, 'a'] }
            ])

            expect(result.valid?).to be false

            expect(result.value[0][:a]).to eq('C')
            expect(result.value[0][:b]).to be_nil
            expect(result.value[1][:a]).to be_nil
            expect(result.value[1][:b]).to eq([1, 2, 3])
            expect(result.value[2][:a]).to be_nil
            expect(result.value[2][:b]).to eq([1, nil, 'a'])

            expect(result.errors['0'][:b]).to include('is required')
            expect(result.errors['2'][:b]['1']).to include('is required')
            expect(result.errors['2'][:b]['2']).to \
              include("'a' is not a valid Integer")
          end

          it 'should coerce hash with array of hashes with errors' do
            schema = Compel.hash.keys(
              actions: Compel.array.items(
                Compel.hash.keys(
                  a: Compel.string.required,
                  b: Compel.string.format(/^abc$/)
                )
              )
            )

            object = {
              other_key: 1,
              actions: [
                { a: 'A', b: 'abc' },
                { a: 'B' },
                { a: 'C', b: 'abcd' }
              ]
            }

            result = schema.validate(object)

            expect(result.value[:actions][2][:errors][:b]).to \
              include('must match format ^abc$')
          end

        end

      end

      context 'Hash' do

        subject(:builder) { Compel.hash }

        it 'should validate empty keys option' do
          schema = builder.required

          expect(schema.validate({ a: 1 }).valid?).to be true
        end

        it 'should validate nil' do
          schema = builder.required

          result = schema.validate(nil)

          expect(result.valid?).to be false
          expect(result.errors[:base]).to \
            include('is required')
        end

        it 'should validate empty keys with errors' do
          schema = builder.required.length(2)

          result = schema.validate({ a: 1 })

          expect(result.valid?).to be false
          expect(result.errors[:base]).to \
            include('cannot have length different than 2')
        end

      end

    end

  end

end
