describe Compel do

  def make_the_call(method, params)
    Compel.send(method, params) do
      param :first_name, String, required: true
      param :last_name, String, required: true
      param :birth_date, DateTime
    end
  end

  context '#compel!' do

    it 'should raise InvalidParamsError exception' do
      params = {
        first_name: 'Joaquim'
      }

      expect{ make_the_call(:compel!, params) }.to \
        raise_error Compel::InvalidParamsError, 'params are invalid'
    end

    it 'shoudl raise InvalidParamsError exception with errors' do
      params = {
        first_name: 'Joaquim'
      }

      expect{ make_the_call(:compel!, params) }.to raise_error do |exception|
        expect(exception.errors).to eq({
          last_name: ['is required']
        })
      end
    end

  end

  context '#compel?' do

    it 'should return true' do
      params = {
        first_name: 'Joaquim',
        last_name: 'Adráz',
        birth_date: '1989-08-06T09:00:00'
      }

      expect(make_the_call(:compel?, params)).to eq(true)
    end

    it 'should return false' do
      params = {
        first_name: 'Joaquim'
      }

      expect(make_the_call(:compel?, params)).to eq(false)
    end

  end

  context '#compel' do

    it 'should not compel for invalid params' do
      expect{ make_the_call(:compel, 1) }.to \
        raise_error Compel::ParamTypeError, 'Compel params must be an Hash'
    end

    it 'should not compel for invalid params 1' do
      expect{ make_the_call(:compel, nil) }.to \
        raise_error Compel::ParamTypeError, 'Compel params must be an Hash'
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
          param :address, Hash, required: true do
            param :line_one, String, required: true
            param :line_two, String
            param :post_code, Hash, required: true do
              param :prefix, Integer, length: 4, required: true
              param :suffix, Integer, length: 3
              param :county, Hash do
                param :code, String, length: 2, required: true
                param :name, String
              end
            end
          end
        end
      end

      it 'should compel?' do
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

      it 'should not compel' do
        params = {
          address: {
            line_two: 'Portugal'
          }
        }

        expect(make_the_call(:compel, params)).to \
          eq({
            address: {
              line_one: ['is required'],
              post_code: ['Compel params must be an Hash']
            }
          })
      end

      it 'should not compel 1' do
        params = {
          address: {
            line_two: 'Portugal',
            post_code: {
              prefix: 1,
              county: {
                code: 'LX'
              }
            }
          }
        }

        expect(make_the_call(:compel, params)).to \
          eq({
            address: {
              line_one: ['is required'],
              post_code: {
                prefix: ['cannot have length different than 4']
              }
            }
          })
      end

      it 'should not compel 2' do
        params = {
          address: {
            post_code: {
              suffix: 1234
            }
          }
        }

        expect(make_the_call(:compel, params)).to \
          eq({
            address: {
              line_one: ['is required'],
              post_code: {
                prefix: ['is required'],
                suffix: ['cannot have length different than 3']
              }
            }
          })
      end

      it 'should not compel 3' do
        params = {
          address: {
            post_code: {
              prefix: 1100,
              suffix: 100,
              county: {}
            },
          }
        }

        expect(make_the_call(:compel, params)).to \
          eq({
            address: {
              line_one: ['is required'],
              post_code: {
                county: {
                  code: ['is required']
                }
              }
            }
          })
      end

    end

  end

end
