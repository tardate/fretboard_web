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

    context "when proxy_url is blank" do
      it "send dummy status page" do
        expect_any_instance_of(app).to receive(:proxy_url).and_return('')
        get '/status.csv'
        expect(last_response).to be_ok
        expect(last_response.body).to match('dummy_project_1')
      end
    end

    context "when proxy_url is provided" do
      context "and proxy returns a CruiseControl-compatible XmlStatusReport" do
        let(:mock_build_response) { mock_cruise_control_xml_status_response }
        it "send status parsed into CSV" do
          expect_any_instance_of(app).to receive(:proxy_url).and_return('http://mock.endpint')
          expect_any_instance_of(BuildResponse).to receive(:status_report).and_return(mock_build_response)
          get '/status.csv'
          expect(last_response).to be_ok
          expect(last_response.body).to eql "project_1,CheckingModifications,Failure\nproject_2,Sleeping,Success"
        end
      end
    end

  end

end