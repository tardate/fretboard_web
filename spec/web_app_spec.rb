def app
  Sinatra::Application
end

describe "Sinatra App" do

  describe "GET '/'" do
    it "loads homepage" do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe "GET '/status.csv'" do
    before do
      expect_any_instance_of(app).to receive(:ci_server_url).and_return(ci_server_url)
      expect_any_instance_of(app).to receive(:ci_server_type).and_return(ci_server_type)
    end

    context "when no CI config provided" do
      let(:ci_server_url)  {  }
      let(:ci_server_type) {  }
      it "send dummy status page" do
        get '/status.csv'
        expect(last_response).to be_ok
        expect(last_response.body).to match('dummy_project_1')
      end
    end

    context "when cruise-control config is provided" do
      let(:ci_server_url)  { "http://mock.endpint" }
      let(:ci_server_type) { "xml" }
      context "and server returns a CruiseControl-compatible XmlStatusReport" do
        let(:mock_build_response) { mock_cruise_control_xml_status_response }
        it "send status parsed into CSV" do
          expect_any_instance_of(BuildResponse::CruiseControl).to receive(:status_report).and_return(mock_build_response)
          get '/status.csv'
          expect(last_response).to be_ok
          expect(last_response.body).to eql "project_1,CheckingModifications,Failure\nproject_2,Sleeping,Success"
        end
      end
    end

  end

end
