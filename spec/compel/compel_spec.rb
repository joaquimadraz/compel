describe Compel do

  def make_the_call(method, params)
    Compel.send(method, params) do
      param :first_name, String, required: true
      param :last_name, String, required: true
      param :birth_date, DateTime
    end
  end

  context '#compel' do

    it 'should compel' do
      params = {
        first_name: 'Joaquim',
        last_name: 'Adráz',
        birth_date: '1989-08-06T09:00:00'
      }

      expect(make_the_call(:compel?, params)).to eq(true)
    end

    it 'should not compel' do
      params = {
        first_name: 'Joaquim'
      }

      expect(make_the_call(:compel, params)).to \
        eq({
          last_name: ['is required']
        })
    end

  end

end
