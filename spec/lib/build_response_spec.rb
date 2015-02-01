describe BuildResponse do
  let(:instance) { described_class.new(proxy_url) }

  describe "#response" do
    subject { instance.response }

    context "when proxy_url not provided" do
      let(:proxy_url) { nil }
      it "should return a dummy response" do
        expect(instance).to receive(:dummy_status).and_return('dummy response')
        expect(subject).to eql 'dummy response'
      end
    end

    context "when proxy_url provided" do
      let(:proxy_url) { 'http://mock.endpint' }

      context "and proxy returns a CruiseControl-compatible XmlStatusReport" do
        let(:mock_build_response) { mock_cruise_control_xml_status_response }
        it "should be returned parsed into CSV" do
          expect(instance.proxy_url).to eql proxy_url
          expect(instance).to receive(:status_report).and_return(mock_build_response)
          expect(subject).to eql "project_1,CheckingModifications,Failure\nproject_2,Sleeping,Success"
        end
      end
    end
  end

end