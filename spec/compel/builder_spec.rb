# encoding: UTF-8

describe Compel::Builder do

  context 'Schema' do

    context 'Build' do

      it 'should build new Schema for given type' do
        builder = Compel.string

        expect(builder.type).to be(Compel::Coercion::String)
        expect(builder.options.keys).to include(:required)
        expect(builder.required?).to be false
        expect(builder.default_value).to be nil
      end

      context 'Builder::CommonValue' do

        context '#in, #range' do

          subject(:builder) { Compel.string }

          it 'should have value' do
            [:in, :range].each do |method|
              builder.send(method, ["#{method}"])
              expect(builder.options[method][:value]).to eq(["#{method}"])
            end
          end

        end

        context '#min, #max' do

          subject(:builder) { Compel.string }

          it 'should have value' do
            [:min, :max].each do |method|
              builder.send(method, "#{method}")
              expect(builder.options[method][:value]).to eq("#{method}")
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
              expect(builder.options[method][:value]).to eq("#{method}")
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

            expect(builder.options[:length][:value]).to be 5
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

            expect(builder.options[:format][:value]).to eq('%d-%m-%Y')
          end

          it 'should have value' do
            builder.iso8601

            expect(builder.options[:format][:value]).to eq('%Y-%m-%d')
          end

        end

        context '#max' do

          it 'should set max value with string and coerce' do
            builder.max('2016-01-01')

            expect(builder.options[:max][:value]).to eq(Date.new(2016, 1, 1))
          end

        end

        context '#in' do

          it 'should set max value with string and coerce' do
            builder.in(['2016-01-01', '2016-01-02'])

            expect(builder.options[:in][:value]).to include(Date.new(2016, 1, 1))
            expect(builder.options[:in][:value]).to include(Date.new(2016, 1, 2))
          end

        end

      end

      context 'Date, DateTime and Time' do

        def each_date_builder
          [Date, DateTime, Time].each do |klass|
            builder = Compel.send("#{klass.to_s.downcase}")

            yield builder, klass
          end
        end

        context 'in' do

          def expect_raise_error_for(builder, values, klass)
            expect{ builder.in(values) }.to \
              raise_error \
                Compel::TypeError,
                  "All Builder::#{klass} #in values must be a valid #{klass}"
          end

          it 'should set in value' do
            each_date_builder do |builder, klass|
              builder.in([klass.new(2016, 1, 1), klass.new(2016, 1, 2)])

              expect(builder.options[:in][:value].length).to eq 2
            end
          end

          it 'should raise exception for invalid #in values' do
            each_date_builder do |builder, klass|
              expect_raise_error_for(builder, [klass.new(2016, 1, 1), 'invalid_date'], klass)
            end
          end

        end

        context '#max' do

          it 'should set max value' do
            each_date_builder do |builder, klass|
              builder.max(klass.new(2016, 1, 1))

              expect(builder.options[:max][:value]).to eq(klass.new(2016, 1, 1))
            end
          end

          it 'should raise exception for invalid value' do
            each_date_builder do |builder, klass|
              expect{ builder.max(1) }.to \
                raise_error \
                  Compel::TypeError,
                    "Builder::#{klass} #max value must be a valid #{klass}"
            end
          end

        end

        context '#min' do

          it 'should set min value' do
            each_date_builder do |builder, klass|
              builder.min(klass.new(2016, 1, 1))

              expect(builder.options[:min][:value]).to eq(klass.new(2016, 1, 1))
            end
          end

          it 'should raise exception for invalid value' do
            each_date_builder do |builder, klass|
              expect{ builder.min(1) }.to \
                raise_error \
                  Compel::TypeError,
                    "Builder::#{klass} #min value must be a valid #{klass}"
            end
          end

        end

      end

      context 'String' do

        subject(:builder) { Compel.string }

        context '#in' do

          it 'should set in value' do
            builder.in(['a', 'b'])

            expect(builder.options[:in][:value].length).to eq 2
          end

          it 'should raise exception for invalid item on array' do
            expect{ builder.in([1, 'b']) }.to \
              raise_error \
                Compel::TypeError,
                  "All Builder::String #in values must be a valid String"
          end

        end

        context '#format' do

          it 'should raise exception for invalid type' do
            expect { builder.format('abc') }.to \
              raise_error Compel::TypeError, "'abc' is not a valid Regexp"
          end

          it 'should have value' do
            builder.format(/1/)

            expect(builder.options[:format][:value]).to eq(/1/)
          end

        end

        context '#min_length' do

          it 'should raise exception for invalid type' do
            expect { builder.min_length('a') }.to \
              raise_error Compel::TypeError, "'a' is not a valid Integer"
          end

          it 'should have value' do
            builder.min_length(4)

            expect(builder.options[:min_length][:value]).to eq(4)
          end

        end

        context '#max_length' do

          it 'should raise exception for invalid type' do
            expect { builder.max_length('a') }.to \
              raise_error Compel::TypeError, "'a' is not a valid Integer"
          end

          it 'should have value' do
            builder.max_length(10)

            expect(builder.options[:max_length][:value]).to eq(10)
          end

        end

      end

      context 'Hash' do

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

          keys_schemas = schema.options[:keys][:value]

          expect(keys_schemas[:a].type).to be Compel::Coercion::Float
          expect(keys_schemas[:b].type).to be Compel::Coercion::String
          expect(keys_schemas[:c].type).to be Compel::Coercion::Hash
          expect(keys_schemas[:d].type).to be Compel::Coercion::JSON
          expect(keys_schemas[:e].type).to be Compel::Coercion::Time
          expect(keys_schemas[:f].type).to be Compel::Coercion::DateTime
          expect(keys_schemas[:g].type).to be Compel::Coercion::Date
          expect(keys_schemas[:h].type).to be Compel::Coercion::Integer
        end

        it 'should raise error for invalid #keys' do
          expect{ Compel.hash.keys(nil) }.to \
            raise_error(Compel::TypeError, 'Builder::Hash keys must be an Hash')
        end

        it 'should raise error for invalid #keys 1' do
          expect{ Compel.hash.keys(1) }.to \
            raise_error(Compel::TypeError, 'Builder::Hash keys must be an Hash')
        end

        it 'should raise error for invalid #keys Schema' do
          expect{ Compel.hash.keys({ a: 1 }) }.to \
            raise_error(Compel::TypeError, 'All Builder::Hash keys must be a valid Schema')
        end

      end

      context 'Array' do

        it 'should raise exception for invalid type' do
          expect { Compel.array.items('a') }.to \
            raise_error Compel::TypeError, "#items must be a valid Schema"
        end

        it 'should raise exception for invalid type' do
          expect { Compel.array.items('a') }.to \
            raise_error Compel::TypeError, "#items must be a valid Schema"
        end

        it 'should have value' do
          builder = Compel.array.items(Compel.integer)

          expect(builder.options[:items][:value].class).to be(Compel::Builder::Integer)
        end

      end

      context 'Integer' do

        context 'min' do

          it 'should build schema' do
            builder = Compel.integer.min(10)

            expect(builder.options[:min][:value]).to eq(10)
          end

          it 'should raise exception for invalid value' do
            expect{ Compel.integer.min('ten') }.to \
              raise_error \
                Compel::TypeError, 'Builder::Integer #min value must be a valid Integer'
          end

        end

      end

      context 'Any' do

        context '#if' do

          it 'should have a proc' do
            _proc = Proc.new {|value| value == 1 }

            schema = Compel.any.if(_proc)

            expect(schema.options[:if][:value]).to eq _proc
          end

          it 'should have a block with string or symbol value' do
            schema = Compel.any.if{:is_valid_one}
            expect(schema.options[:if][:value].call).to eq :is_valid_one

            schema = Compel.any.if{'is_valid_one'}
            expect(schema.options[:if][:value].call).to eq 'is_valid_one'
          end

          it 'should raise_error for missing value' do
            expect{ Compel.any.if() }.to \
              raise_error Compel::TypeError, 'invalid proc for if'
          end

          it 'should raise_error for invalid proc' do
            expect{ Compel.any.if('proc') }.to \
              raise_error Compel::TypeError, 'invalid proc for if'
          end

          it 'should raise_error for invalid proc arity' do
            expect{ Compel.any.if(Proc.new {|a, b| a == b }) }.to \
              raise_error Compel::TypeError, 'invalid proc for if'
          end

          it 'should raise_error for invalid proc 1' do
            expect{ Compel.any.if(1) }.to \
              raise_error Compel::TypeError, 'invalid proc for if'
          end

        end

      end

    end

    context 'Validate' do

      context 'Any' do

        context '#required' do

          context 'invalid' do

            it 'should validate a nil object' do
              schema = Compel.any.required

              expect(schema.validate(nil).errors).to \
                include('is required')
            end

            it 'should have an array for error messages' do
              schema = Compel.any.required(message: 'this is required')
              expect(schema.validate(nil).errors.class).to eq Array

              schema = Compel.any.required
              expect(schema.validate(nil).errors.class).to eq Array
            end

            it 'should use custom error message' do
              schema = Compel.any.required(message: 'this is required')

              expect(schema.validate(nil).errors).to \
                include('this is required')
            end

          end

          context 'valid' do

            it 'should validate nested hash object' do
              schema = Compel.hash.keys({
                a: Compel.any.required
              });

              result = schema.validate(a: { b: 1 })

              expect(result.valid?).to be true
            end

            it 'should validate nested hash object 1' do
              schema = Compel.hash.keys({
                a: Compel.any.required
              });

              result = schema.validate(a: [])

              expect(result.valid?).to be true
            end

            it 'should validate nested hash object 2' do
              schema = Compel.hash.keys({
                a: Compel.any.required
              });

              result = schema.validate(a: 1)

              expect(result.valid?).to be true
            end

            it 'should validate an array object' do
              schema = Compel.any.required

              result = schema.validate([1, 2])

              expect(result.valid?).to be true
            end

            it 'should validate an array object 1' do
              schema = Compel.any.required

              result = schema.validate([])

              expect(result.valid?).to be true
            end

            it 'should validate a string object' do
              schema = Compel.any.required

              result = schema.validate('test')

              expect(result.valid?).to be true
            end

          end

        end

        context '#is' do

          context 'invalid' do

            it 'should validate an integer' do
              schema = Compel.any.is(123)

              expect(schema.validate(122).errors).to \
                include('must be 123')

              expect(schema.validate('onetwothree').errors).to \
                include('must be 123')
            end

            it 'should validate an array' do
              schema = Compel.any.is([1, 2, 3])

              expect(schema.validate([1]).errors).to \
                include('must be [1, 2, 3]')

              expect(schema.validate([]).errors).to \
                include('must be [1, 2, 3]')
            end

            it 'should use custom error message' do
              schema = Compel.any.is(1, message: 'not one')

              expect(schema.validate('two').errors).to \
                include('not one')
            end

          end

          context 'valid' do

            it 'should validate an array' do
              schema = Compel.any.is([1, 2, 3])

              result = schema.validate([1, 2, 3])

              expect(result.valid?).to be true
            end

          end

        end

        context '#length' do

          context 'invalid' do

            it 'should not validate an instance object' do
              schema = Compel.any.length(1)

              expect(schema.validate(OpenStruct).errors).to \
                include('cannot have length different than 1')
            end

            it 'should not validate a constant object' do
              schema = Compel.any.length(1)

              expect(schema.validate(OpenStruct).errors).to \
                include('cannot have length different than 1')
            end

            it 'should use custom error message' do
              schema = Compel.any.length(2, message: '({{value}}) does not have the right size')

              expect(schema.validate(123).errors).to \
                include('(123) does not have the right size')
            end

          end

          context 'valid' do

            it 'should validate a constant object' do
              schema = Compel.any.length(10)

              result = schema.validate(OpenStruct)

              expect(result.valid?).to be true
            end

            it 'should validate a constant object' do
              schema = Compel.any.length(10)

              result = schema.validate(OpenStruct)

              expect(result.valid?).to be true
            end

            it 'should validate a constant object' do
              schema = Compel.any.length(2)

              expect(schema.validate(12).valid?).to eq(true)
            end

          end

        end

        context '#min_length' do

          context 'invalid' do

            it 'should use custom error message' do
              schema = Compel.any.min_length(2, message: 'min is two')

              expect(schema.validate(1).errors).to \
                include('min is two')
            end

          end

        end

        context '#max_length' do

          context 'invalid' do

            it 'should use custom error message' do
              schema = Compel.any.max_length(2, message: 'max is two')

              expect(schema.validate(123).errors).to \
                include('max is two')
            end

          end

        end

        context '#if' do

          class CustomValidationsKlass

            attr_reader :value

            def initialize(value)
              @value = value
            end

            def validate
              Compel.any.if{:is_custom_valid?}.validate(value)
            end

            def validate_with_lambda(lambda)
              Compel.any.if(lambda).validate(value)
            end

            private

            def is_custom_valid?(value)
              value == assert_value
            end

            def assert_value
              [1, 2, 3]
            end

          end

          context 'invalid' do

            it 'should validate with custom method' do
              def is_valid_one(value)
                value == 1
              end

              result = Compel.any.if{:is_valid_one}.validate(2)

              expect(result.valid?).to eq(false)
              expect(result.errors).to include('is invalid')
            end

            it 'should validate with lambda' do
              result = Compel.any.if(Proc.new {|value| value == 2 }).validate(1)

              expect(result.valid?).to eq(false)
              expect(result.errors).to include('is invalid')
            end

            it 'should validate within an instance method' do
              result = CustomValidationsKlass.new(1).validate

              expect(result.valid?).to eq(false)
              expect(result.errors).to include('is invalid')
            end

            it 'should validate within an instance method 1' do
              result = \
                CustomValidationsKlass.new('two')
                  .validate_with_lambda(Proc.new {|value| value == [1, 2, 3] })

              expect(result.valid?).to eq(false)
              expect(result.errors).to include('is invalid')
            end

            it 'should use custom message with parsed value' do
              schema = \
                Compel.any.if(Proc.new {|value| value == 2 }, message: 'give me a {{value}}!')

              result = schema.validate(1)

              expect(result.valid?).to eq(false)
              expect(result.errors).to include('give me a 1!')
            end

            it 'should validate a date value' do
              to_validate = '1969-01-01T00:00:00'

              def validate_time(value)
                value > Time.at(0)
              end

              result = Compel.time.if{:validate_time}.validate(to_validate)

              expect(result.valid?).to eq(false)
              expect(result.errors).to include('is invalid')
            end

            it 'should raise_error for invalid custom method arity' do
              def custom_method_arity_two(value, extra_arg)
                false
              end

              def custom_method_arity_zero
                false
              end

              expect{ Compel.integer.if{:custom_method_arity_two}.validate(1) }.to \
                raise_error ArgumentError

              expect{ Compel.integer.if{:custom_method_arity_zero}.validate(1) }.to \
                raise_error ArgumentError
            end

          end

          context 'valid' do

            it 'should validate with custom method' do
              def is_valid_one(value)
                value == 1
              end

              result = Compel.any.if{:is_valid_one}.validate(1)

              expect(result.valid?).to eq(true)
            end

            it 'should validate with custom method 1' do
              def is_valid_one(value)
                value == 1
              end

              result = Compel.any.if{|value| value == 1 }.validate(1)

              expect(result.valid?).to eq(true)
            end

            it 'should validate with lambda' do
              result = Compel.any.if(Proc.new {|value| value == 2 }).validate(2)

              expect(result.valid?).to eq(true)
            end

            it 'should validate within an instance method' do
              result = CustomValidationsKlass.new([1, 2, 3]).validate

              expect(result.valid?).to eq(true)
            end

            it 'should validate within an instance method' do
              result = CustomValidationsKlass.new([1, 2, 3]).validate
              expect(result.valid?).to eq(true)
            end

            it 'should validate within an instance method 1' do
              result = \
                CustomValidationsKlass.new([1, 2, 3])
                  .validate_with_lambda(Proc.new {|value| value == [1, 2, 3] })

              expect(result.valid?).to eq(true)
            end

            it 'should validate a date value' do
              to_validate = '1969-01-01T00:00:00'

              def validate_time(value)
                value < Time.at(0)
              end

              result = Compel.time.if{:validate_time}.validate(to_validate)

              expect(result.valid?).to eq(true)
            end

          end

        end

      end

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
              first_name: 'Joaquim',
              birth_date: '1989-0',
              address: {
                line_one: 'Lisboa',
                post_code: '1100',
                country_code: 'PT',
                line_two: '-'
              },
              errors: {
                last_name: ['is required'],
                birth_date: ["'1989-0' is not a parsable date with format: %Y-%m-%d"],
                address: {
                  post_code: ["must match format ^\\d{4}-\\d{3}$"]
                }
              }
            })
        end

        it 'should validate hash object from schema' do
          schema = Compel.hash.keys({
            a: Compel.float.required
          })

          expect(schema.validate({ a: nil }).errors[:a]).to \
            include('is required')
        end

        context '#required' do

          it 'should validate empty keys option' do
            schema = Compel.hash.required

            expect(schema.validate({ a: 1 }).valid?).to be true
          end

          it 'should validate nil' do
            schema = Compel.hash.required

            result = schema.validate(nil)

            expect(result.valid?).to be false
            expect(result.errors[:base]).to \
              include('is required')
          end

        end

        context '#is' do

          it 'should validate with errors' do
            value = { a: 1, b: 2, c: { d: 3, e: 4 }}
            schema = Compel.hash.is(value)

            result = schema.validate({ a: 1, b: 2, c: 3 })

            expect(result.errors[:base]).to \
              include("must be #{value.to_hash}")
          end

          it 'should validate without errors' do
            schema = Compel.hash.is({ a: 1, b: 2, c: 3 })

            result = schema.validate({ 'a' => 1, 'b' => 2, 'c' => 3 })
            expect(result.valid?).to be true

            result = schema.validate({ :a => 1, :b => 2, :c => 3 })
            expect(result.valid?).to be true
          end

        end

        context '#length' do

          it 'should validate empty keys with errors' do
            result = Compel.hash.length(2).validate({ a: 1 })

            expect(result.valid?).to be false
            expect(result.errors[:base]).to \
              include('cannot have length different than 2')
          end

        end

      end

      context 'String' do

        it 'should validate Type schema' do
          schema = Compel.string.format(/^\d{4}-\d{3}$/).required
          result = schema.validate('1234')

          expect(result.errors).to \
            include("must match format ^\\d{4}-\\d{3}$")
        end

        context '#url' do

          it 'should validate' do
            result = Compel.string.url.validate('http://example.com')

            expect(result.valid?).to be true
          end

          it 'should validate' do
            result = Compel.string.url.validate('http://app.com/posts/1/comments')

            expect(result.valid?).to be true
          end

          it 'should not validate' do
            result = Compel.string.url.validate('www.example.com')

            expect(result.valid?).to be false
          end

          it 'should not validate' do
            result = Compel.string.url.validate('url')

            expect(result.valid?).to be false
          end

          it 'should not validate and use custom error' do
            result = Compel.string.url(message: 'not an URL').validate('url')

            expect(result.errors).to include('not an URL')
          end

        end

        context '#email' do

          it 'should validate' do
            result = Compel.string.email.validate('example@gmail.com')

            expect(result.valid?).to be true
          end

          it 'should not validate' do
            result = Compel.string.email.validate('example@gmail')

            expect(result.valid?).to be false
          end

          it 'should not validate' do
            result = Compel.string.email.validate('email')

            expect(result.valid?).to be false
          end

          it 'should not validate and use custom error' do
            result = Compel.string.email(message: 'not an EMAIL').validate('email')

            expect(result.errors).to include('not an EMAIL')
          end

        end

      end

      context 'Array' do

        it 'should validate nil without errors' do
          result = Compel.array.validate(nil)

          expect(result.valid?).to be true
        end

        it 'should validate nil with errors' do
          result = Compel.array.required.validate(nil)

          expect(result.errors[:base]).to include('is required')
        end

        it 'should validate with errors for invalid array' do
          result = Compel.array.required.validate(1)

          expect(result.errors[:base]).to include("'1' is not a valid Array")
        end

        context '#items' do

          it 'should validate without items' do
            result = Compel.array.validate([1, 2, 3])

            expect(result.valid?).to be true
            expect(result.value).to eq([1, 2, 3])
          end

          it 'should validate all items' do
            result = Compel.array.items(Compel.integer).validate([1, '2', nil])

            expect(result.valid?).to be true
            expect(result.value).to eq([1, 2])
          end

          it 'should validate all items with errors' do
            result = Compel.array.items(Compel.float.required).validate([1, 'a', nil])

            expect(result.valid?).to be false
            expect(result.errors['1']).to include("'a' is not a valid Float")
            expect(result.errors['2']).to include('is required')
          end

          it 'should coerce all hash items' do
            builder = Compel.array.items(Compel.hash.keys({
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
                { a: 'A', b: 1 },
                { a: 'B' },
                { a: 'C', b: 3 }
              ]
          end

          it 'should coerce all hash items with errors' do
            builder = Compel.array.items(Compel.hash.keys({
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
            builder = Compel.array.items(Compel.hash.keys({
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

        context '#is' do

          it 'should validate with errors' do
            value = [1, 2, 3]
            result = Compel.array.is(value).validate([1, 2])

            expect(result.valid?).to be false
            expect(result.errors[:base]).to include("must be #{value}")
          end

          it 'should validate without errors' do
            result = Compel.array.is(['a', 'b', 'c']).validate(['a', 'b', 'c'])

            expect(result.valid?).to be true
          end

        end

      end

      context 'DateTime' do

        it 'should validate with errors' do
          result = Compel.datetime.validate('1989-0')

          expect(result.valid?).to be false
          expect(result.errors).to \
            include("'1989-0' is not a parsable datetime with format: %FT%T")
        end

      end

      context 'Integer' do

        context '#in' do

          context 'invalid' do

            it 'should use custom error message' do
              schema = Compel.integer.in([1, 2], message: 'not in 1 or 2')

              expect(schema.validate(3).errors).to \
                include('not in 1 or 2')
            end

          end

        end

        context '#range' do

          context 'invalid' do

            it 'should use custom error message' do
              schema = Compel.integer.range([1, 2], message: 'not between 1 or 2')

              expect(schema.validate(3).errors).to \
                include('not between 1 or 2')
            end

          end

        end

        context '#min' do

          context 'invalid' do

            it 'should use custom error message' do
              schema = Compel.integer.min(5, message: 'min is five')

              expect(schema.validate(4).errors).to \
                include('min is five')
            end

          end

        end

        context '#max' do

          context 'invalid' do

            it 'should use custom error message' do
              schema = Compel.integer.max(5, message: 'max is five')

              expect(schema.validate(6).errors).to \
                include('max is five')
            end

          end

        end

      end

    end

  end

end
