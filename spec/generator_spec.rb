require 'spec_helper'

describe PageObjectGenerator do
  subject { PageObjectGenerator }

  describe '#process' do
    let(:input) { URI('http://localhost:3000/schedule/visits/state/all') }
    let(:input_options) { {user: 'ExecutionDM', password: 'test123'} }
    let(:output) { subject.create_module_scaffold(input, input_options) }

    it 'separates url' do
      output
    end
  end
end
