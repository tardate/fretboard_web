describe BuildResponse do
  let(:ci_server_url)  {  }
  let(:ci_server_type) {  }
  let(:instance) { described_class.get_instance(ci_server_url, ci_server_type) }

  describe "#response" do
    subject(:response) { instance.response }

    context "when no CI config provided" do
      it "returns a dummy response" do
        expect(subject).to include("dummy_project_1")
      end
      it "uses dummy_status not status_report" do
        expect(instance).to_not receive(:status_report)
        expect(instance).to receive(:dummy_status).and_return('dummy response')
        subject
      end
    end

    context "when cruise-control config is provided" do
      let(:ci_server_url) { "http://mock.endpint" }
      let(:ci_server_type) { "xml" }
      it "instantiates the correct response builder" do
        expect(instance).to be_a(BuildResponse::CruiseControl)
        expect(instance.ci_server_url).to eql ci_server_url
      end

      context "and server returns a CruiseControl-compatible XmlStatusReport" do
        let(:mock_build_response) { mock_cruise_control_xml_status_response }
        it "returns results parsed into CSV" do
          expect(instance).to receive(:status_report).and_return(mock_build_response)
          expect(subject).to eql "project_1,CheckingModifications,Failure\nproject_2,Sleeping,Success\n"
        end
      end
    end

    context "when Circle CI config is provided" do
      let(:ci_server_url) { "http://mock.endpint" }
      let(:ci_server_type) { "circleci" }
      it "instantiates the correct response builder" do
        expect(instance).to be_a(BuildResponse::CircleCi)
        expect(instance.ci_server_url).to eql ci_server_url
      end

      context "and server returns a recent-builds response" do
        let(:mock_build_response) { mock_circle_ci_status_response(2) }
        it "returns results parsed into CSV" do
          expect(instance).to receive(:status_report).and_return(mock_build_response)
          expect(subject).to eql "my-project-0,Building,Success\nmy-project-1,Sleeping,Failed\n"
        end
      end
    end

  end

end
