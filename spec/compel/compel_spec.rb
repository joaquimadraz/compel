describe Compel do

  context '#run' do

    def make_the_call(method, hash)
      schema = Compel.hash.keys({
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
      })

      Compel.send(method, hash, schema)
    end

    it 'should compel returning coerced values' do
      hash = {
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

      expect(make_the_call(:run, hash)).to eq \
        Hashie::Mash.new({
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
        })
    end

    it 'should not compel and leave other hash untouched' do
      hash = {
        other_param: 1,
        user: {
          first_name: 'Joaquim'
        }
      }

      expect(make_the_call(:run, hash)).to eq \
        Hashie::Mash.new({
          other_param: 1,
          user: {
            first_name: 'Joaquim',
          },
          errors: {
            user: {
              last_name: ['is required']
            }
          }
        })
    end

    it 'should not compel for invalid hash' do
      expect{ make_the_call(:run, 1) }.to \
        raise_error Compel::TypeError, 'must be an Hash'
    end

    it 'should not compel for invalid hash 1' do
      expect{ make_the_call(:run, nil) }.to \
        raise_error Compel::TypeError, 'must be an Hash'
    end

    it 'should not compel'  do
      hash = {
        user: {
          first_name: 'Joaquim'
        }
      }

      expect(make_the_call(:run, hash)).to eq \
        Hashie::Mash.new({
          user:{
            first_name: 'Joaquim',
          },
          errors: {
            user: {
              last_name: ['is required']
            }
          }
        })
    end

    context 'nested Hash' do

      def make_the_call(method, hash)
        schema = Compel.hash.keys({
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

        Compel.send(method, hash, schema)
      end

      it 'should run?' do
        hash = {
          address: {
            line_one: 'Lisbon',
            line_two: 'Portugal',
            post_code: {
              prefix: 1100,
              suffix: 100
            }
          }
        }

        expect(make_the_call(:run?, hash)).to eq(true)
      end

      it 'should not compel' do
        hash = {
          address: {
            line_two: 'Portugal'
          }
        }

        expect(make_the_call(:run, hash)).to eq \
          Hashie::Mash.new({
            address: {
              line_two: 'Portugal'
            },
            errors: {
              address: {
                line_one: ['is required'],
                post_code: ['is required']
              }
            }
          })
      end

      it 'should not compel 1' do
        hash = {
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

        expect(make_the_call(:run, hash)).to eq \
          Hashie::Mash.new({
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
          })
      end

      it 'should not compel 2' do
        hash = {
          address: {
            post_code: {
              suffix: '1234'
            }
          }
        }

        expect(make_the_call(:run, hash)).to eq \
          Hashie::Mash.new({
            address: {
              post_code: {
                suffix: 1234
              }
            },
            errors: {
              address: {
                line_one: ['is required'],
                post_code: {
                  prefix: ['is required'],
                  suffix: ['cannot have length different than 3']
                }
              }
            }
          })
      end

      it 'should not compel 3' do
        hash = {
          address: {
            post_code: {
              prefix: '1100',
              suffix: '100',
              county: {}
            },
          }
        }

        expect(make_the_call(:run, hash)).to eq \
          Hashie::Mash.new({
            address: {
              post_code: {
                prefix: 1100,
                suffix: 100,
                county: {}
              }
            },
            errors: {
              address: {
                line_one: ['is required'],
                post_code: {
                  county: {
                    code: ['is required']
                  }
                }
              }
            }
          })

      end

      it 'should not compel 4' do
        hash = {
          address: nil
        }

        expect(make_the_call(:run, hash)).to eq \
          Hashie::Mash.new({
            address: nil,
            errors: {
              address: ['is required']
            }
          })
      end

      it 'should not compel 5' do
        expect(make_the_call(:run, {})).to eq \
          Hashie::Mash.new({
            errors: {
              address: ['is required']
            }
          })
      end

    end

  end

  context 'Compel methods' do

    def make_the_call(method, hash)
      schema = Compel.hash.keys({
        first_name: Compel.string.required,
        last_name: Compel.string.required,
        birth_date: Compel.datetime
      })

      Compel.send(method, hash, schema)
    end

    context '#run!' do

      it 'should raise InvalidHashError exception' do
        hash = {
          first_name: 'Joaquim'
        }

        expect{ make_the_call(:run!, hash) }.to \
          raise_error Compel::InvalidHashError, 'hash has errors'
      end

      it 'should raise InvalidHashError exception with errors' do
        hash = {
          first_name: 'Joaquim'
        }

        expect{ make_the_call(:run!, hash) }.to raise_error do |exception|
          expect(exception.object).to eq \
            Hashie::Mash.new(first_name: 'Joaquim')

          expect(exception.errors).to eq \
            Hashie::Mash.new(last_name: ['is required'])
        end
      end

    end

    context '#run?' do

      it 'should return true' do
        hash = {
          first_name: 'Joaquim',
          last_name: 'Adráz',
          birth_date: '1989-08-06T09:00:00'
        }

        expect(make_the_call(:run?, hash)).to eq(true)
      end

      it 'should return false' do
        hash = {
          first_name: 'Joaquim'
        }

        expect(make_the_call(:run?, hash)).to eq(false)
      end

    end

  end


end
