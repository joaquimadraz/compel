# encoding: UTF-8

describe Compel do

  context '#run' do

    context 'User validation example' do

      def user_schema
        Compel.hash.keys({
          user: Compel.hash.keys({
            first_name: Compel.string.required,
            last_name: Compel.string.required,
            birth_date: Compel.datetime,
            age: Compel.integer,
            admin: Compel.boolean,
            blog_role: Compel.hash.keys({
              admin: Compel.boolean.required
            })
          }).required
        }).required
      end

      context 'valid' do

        it 'return coerced values' do
          object = {
            user: {
              first_name: 'Joaquim',
              last_name: 'Adráz',
              birth_date: '1989-08-06T09:00:00',
              age: '26',
              admin: 'f',
              blog_role: {
                admin: '0'
              }
            }
          }

          result = Compel.run(object, user_schema)

          expect(result.valid?).to be true
          expect(result.value).to eq \
            user: {
              first_name: 'Joaquim',
              last_name: 'Adráz',
              birth_date: DateTime.parse('1989-08-06T09:00:00'),
              age: 26,
              admin: false,
              blog_role: {
                admin: false
              }
            }
        end

      end

      context 'invalid' do

        it 'should not compel and leave other keys untouched' do
          object = {
            other_param: 1,
            user: {
              first_name: 'Joaquim'
            }
          }

          result = Compel.run(object, user_schema)

          expect(result.valid?).to be false
          expect(result.value).to eq \
            other_param: 1,
            user: {
              first_name: 'Joaquim',
            },
            errors: {
              user: {
                last_name: ['is required']
              }
            }
        end

        it 'should not compel for invalid hash' do
          result = Compel.run(1, user_schema)

          expect(result.valid?).to be false
          expect(result.errors[:base]).to include("'1' is not a valid Hash")
        end

        it 'should not compel for missing hash' do
          result = Compel.run(nil, user_schema)

          expect(result.valid?).to be false
          expect(result.errors[:base]).to include('is required')
        end

        it 'should not compel for empty hash' do
          result = Compel.run({}, user_schema)

          expect(result.valid?).to be false
          expect(result.errors[:user]).to include('is required')
        end

        it 'should not compel for missing required key'  do
          object = {
            user: {
              first_name: 'Joaquim'
            }
          }

          result = Compel.run(object, user_schema)

          expect(result.valid?).to be false
          expect(result.value).to eq \
            user:{
              first_name: 'Joaquim',
            },
            errors: {
              user: {
                last_name: ['is required']
              }
            }
        end

      end

    end

    context 'Address validation example' do

      def address_schema
        Compel.hash.keys({
          address: Compel.hash.keys({
            line_one: Compel.string.required,
            line_two: Compel.string,
            post_code: Compel.hash.keys({
              prefix: Compel.integer.length(4).required,
              suffix: Compel.integer.length(3),
              county: Compel.hash.keys({
                code: Compel.string.length(2).required,
                name: Compel.string
              })
            }).required
          }).required
        })
      end

      context 'valid' do

        it 'should compel with #run?' do
          object = {
            address: {
              line_one: 'Lisbon',
              line_two: 'Portugal',
              post_code: {
                prefix: 1100,
                suffix: 100
              }
            }
          }

          expect(Compel.run?(object, address_schema)).to eq(true)
        end

      end

      context 'invalid' do

        it 'should not compel for missing required keys' do
          object = {
            address: {
              line_two: 'Portugal'
            }
          }

          result = Compel.run(object, address_schema)

          expect(result.valid?).to be false
          expect(result.value).to eq \
            address: {
              line_two: 'Portugal'
            },
            errors: {
              address: {
                line_one: ['is required'],
                post_code: ['is required']
              }
            }
        end

        it 'should not compel missing key and length invalid' do
          object = {
            address: {
              line_two: 'Portugal',
              post_code: {
                prefix: '1',
                county: {
                  code: 'LX'
                }
              }
            }
          }

          result = Compel.run(object, address_schema)

          expect(result.valid?).to be false
          expect(result.value).to eq \
            address: {
              line_two: 'Portugal',
              post_code: {
                prefix: 1,
                county: {
                  code: 'LX'
                }
              }
            },
            errors: {
              address: {
                line_one: ['is required'],
                post_code: {
                  prefix: ['cannot have length different than 4']
                }
              }
            }
        end

        it 'should not compel for givin invalid optional value' do
          object = {
            address: {
              line_one: 'Line',
              post_code: {
                prefix: '1100',
                suffix: '100',
                county: {}
              },
            }
          }

          result = Compel.run(object, address_schema)

          expect(result.valid?).to be false
          expect(result.value).to eq \
            address: {
              line_one: 'Line',
              post_code: {
                prefix: 1100,
                suffix: 100,
                county: {}
              }
            },
            errors: {
              address: {
                post_code: {
                  county: {
                    code: ['is required']
                  }
                }
              }
            }

        end

        it 'should not compel for missing required root key' do
          object = {
            address: nil
          }

          result = Compel.run(object, address_schema)

          expect(result.valid?).to be false
          expect(result.value).to eq \
            address: nil,
            errors: {
              address: ['is required']
            }
        end

        it 'should not compel for empty object' do
          result = Compel.run({}, address_schema)

          expect(result.valid?).to be false
          expect(result.value).to eq \
            errors: {
              address: ['is required']
            }
        end

      end

    end

    context 'Boolean' do

      it 'it not compel for invalid boolean' do
        result = Compel.run(nil, Compel.boolean.required)

        expect(result.valid?).to be false
        expect(result.errors).to include('is required')
      end

      context 'required option' do

        it 'should compel with valid option' do
          expect(Compel.run?(1, Compel.boolean.required)).to be true
        end

        it 'should not compel for missing required boolean' do
          schema = Compel.hash.keys({
            admin: Compel.boolean.required
          })

          result = Compel.run({ admin: nil }, schema)

          expect(result.valid?).to be false
          expect(result.errors[:admin]).to include('is required')
        end

      end

      context 'default option' do

        it 'should compel with default option set' do
          result = Compel.run(nil, Compel.boolean.default(false))

          expect(result.value).to be false
        end

      end

      context 'is option' do

        it 'should compel' do
          expect(Compel.run?(1, Compel.boolean.is(true))).to be true
        end

        it 'should not compel' do
          result = Compel.run(0, Compel.boolean.is(true))

          expect(result.valid?).to be false
          expect(result.errors).to include('must be true')
        end

      end

    end

    context 'String' do

      context 'format option' do

        it 'should compel' do
          schema = Compel.string.format(/^\d{4}-\d{3}$/)

          expect(Compel.run?('1100-100', schema)).to be true
        end

        it 'should not compel' do
          schema = Compel.string.format(/^\d{4}-\d{3}$/)

          result = Compel.run('110-100', schema)

          expect(result.errors).to include('must match format ^\\d{4}-\\d{3}$')
        end

        it 'should not compel with custom message' do
          schema = Compel.string.format(/^\d{4}-\d{3}$/, message: 'this format is not good')

          result = Compel.run('110-100', schema)

          expect(result.errors).to include('this format is not good')
        end

      end

    end

    context 'Time' do

      context 'format option' do

        it 'should not compel' do
          schema = Compel.time
          result = Compel.run('1989-08-06', schema)

          expect(result.valid?).to be false
          expect(result.errors).to \
            include("'1989-08-06' is not a parsable time with format: %FT%T")
        end

        it 'should compel with format' do
          schema = Compel.time.format('%Y-%m-%d')
          result = Compel.run('1989-08-06', schema)

          expect(result.valid?).to be true
          expect(result.value).to eq(Time.new(1989, 8, 6))
        end

        it 'should compel by default' do
          schema = Compel.time
          result = Compel.run('1989-08-06T09:00:00', schema)

          expect(result.valid?).to be true
          expect(result.value).to eq(Time.new(1989, 8, 6, 9))
        end

        it 'should compel with iso8601 format' do
          schema = Compel.time.iso8601
          result = Compel.run('1989-08-06T09:00:00', schema)

          expect(result.valid?).to be true
          expect(result.value).to eq(Time.new(1989, 8, 6, 9))
        end

      end

    end

  end

  context 'DateTime' do

    context 'format option' do

      it 'should not compel' do
        schema = Compel.hash.keys({
          birth_date: Compel.datetime
        })

        result = Compel.run({ birth_date: '1989-08-06' }, schema)

        expect(result.valid?).to be false
        expect(result.errors[:birth_date]).to \
          include("'1989-08-06' is not a parsable datetime with format: %FT%T")
      end

      it 'should compel with format' do
        schema = Compel.hash.keys({
          birth_date: Compel.datetime.format('%Y-%m-%d')
        })

        result = Compel.run({ birth_date: '1989-08-06' }, schema)

        expect(result.valid?).to be true
        expect(result.value[:birth_date]).to eq(DateTime.new(1989, 8, 6))
      end

      it 'should compel by default' do
        schema = Compel.hash.keys({
          birth_date: Compel.datetime
        })

        result = Compel.run({ birth_date: '1989-08-06T09:00:00' }, schema)

        expect(result.valid?).to be true
        expect(result.value[:birth_date]).to eq(DateTime.new(1989, 8, 6, 9))
      end

      it 'should compel with iso8601 format' do
        schema = Compel.hash.keys({
          birth_date: Compel.datetime.iso8601
        })

        result = Compel.run({ birth_date: '1989-08-06T09:00:00' }, schema)

        expect(result.valid?).to be true
        expect(result.value[:birth_date]).to eq(DateTime.new(1989, 8, 6, 9))
      end

    end

  end

  context 'Compel methods' do

    context '#run!' do

      context 'Other Values' do

        it 'should compel valid integer' do
          result = Compel.run!(1, Compel.integer.required)

          expect(result).to eq(1)
        end

        it 'should not compel for invalid integer' do
          expect{ Compel.run!('abc', Compel.integer.required) }.to \
            raise_error Compel::InvalidObjectError, 'object has errors'
        end

      end

      context 'User validation example' do

        def make_the_call(method, hash)
          schema = Compel.hash.keys({
            first_name: Compel.string.required,
            last_name: Compel.string.required,
            birth_date: Compel.datetime
          })

          Compel.send(method, hash, schema)
        end

        it 'should compel' do
          hash = {
            first_name: 'Joaquim',
            last_name: 'Adráz',
            birth_date: DateTime.new(1988, 12, 24)
          }

          expect(make_the_call(:run!, hash)).to \
            eq \
              first_name: 'Joaquim',
              last_name: 'Adráz',
              birth_date: DateTime.new(1988, 12, 24)
        end

        it 'should raise InvalidObjectError exception for missing required key' do
          hash = {
            first_name: 'Joaquim'
          }

          expect{ make_the_call(:run!, hash) }.to \
            raise_error Compel::InvalidObjectError, 'object has errors'
        end

        it 'should raise InvalidObjectError exception with errors' do
          hash = {
            first_name: 'Joaquim'
          }

          expect{ make_the_call(:run!, hash) }.to raise_error do |exception|
            expect(exception.object).to eq \
              first_name: 'Joaquim',
              errors: {
                last_name: ['is required']
              }
          end
        end

        it 'should raise InvalidObjectError exception for missing hash' do
          expect{ make_the_call(:run!, {}) }.to \
            raise_error Compel::InvalidObjectError, 'object has errors'
        end

      end

    end

  end

end
