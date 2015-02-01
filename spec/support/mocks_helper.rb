module MocksHelper

  def mock_cruise_control_xml_status_response
    %{<?xml version="1.0"?>
<Projects>
  <Project lastBuildStatus="Success" lastBuildLabel="abcd78f" lastBuildTime="2014-07-15T17:22:42.0000000-00:00" category="" name="project_2" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="Sleeping" webUrl="http://ci:3333/projects/project_2"/>
  <Project lastBuildStatus="Failure" lastBuildLabel="4b59251" lastBuildTime="2015-01-31T18:59:46.0000000-00:00" category="" name="project_1" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="CheckingModifications" webUrl="http://ci:3333/projects/project_1"/>
</Projects>}
  end

end

RSpec.configure do |conf|
  conf.extend MocksHelper
  conf.include MocksHelper
end