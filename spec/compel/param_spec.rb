describe Compel::Param do

  context 'default value' do

    it 'should override default value when value is given' do
      param = Compel::Param.new(:number, Integer, nil, { default: 123 })

      expect(param.value).to eq(123)
    end

    it 'should use default value when not given a value' do
      param = Compel::Param.new(:number, Integer, 123, { default: 456 })

      expect(param.value).to eq(123)
    end

  end

end
