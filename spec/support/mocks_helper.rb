module MocksHelper
  def mock_cruise_control_xml_status_response
    %{<?xml version="1.0"?>
<Projects>
  <Project lastBuildStatus="Success" lastBuildLabel="abcd78f" lastBuildTime="2014-07-15T17:22:42.0000000-00:00" category="" name="project_2" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="Sleeping" webUrl="http://ci:3333/projects/project_2"/>
  <Project lastBuildStatus="Failure" lastBuildLabel="4b59251" lastBuildTime="2015-01-31T18:59:46.0000000-00:00" category="" name="project_1" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="CheckingModifications" webUrl="http://ci:3333/projects/project_1"/>
</Projects>}
  end

  def mock_circle_ci_status_response(size=30)
    results = size.times.map {|index| generate_circle_ci_status(index) }
    results.to_json
  end

  def generate_circle_ci_status(index)
    if (index % 2) == 1
      status = "failed"
      running_builds = [ ]
    else
      status = "success"
      running_builds = [{
        "pushed_at" => "2012-08-09T03:59:53Z",
        "vcs_revision" => "384211bbe72b2a22997116a78788117b3922d570",
        "build_num" => 15
      }]
    end
    {
      "vcs_url" => "https://github.com/circleci/my-project-#{index}",
      "followed" => true,
      "username" => "circleci",
      "reponame" => "my-project-#{index}",
      "branches" => {
        "master" => {
          "pusher_logins" => [ "user1" ],
          "last_non_success" => {
            "pushed_at" => "2013-02-12T21:33:14Z",
            "vcs_revision" => "1d231626ba1d2838e599c5c598d28e2306ad4e48",
            "build_num" => 22,
            "outcome" => "failed",
          },
          "last_success" => {
            "pushed_at" => "2012-08-09T03:59:53Z",
            "vcs_revision" => "384211bbe72b2a22997116a78788117b3922d570",
            "build_num" => 15,
            "outcome" => "success",
          },
          "recent_builds" => [ {
            "pushed_at" => "2013-02-12T21:33:14Z",
            "vcs_revision" => "1d231626ba1d2838e599c5c598d28e2306ad4e48",
            "build_num" => 22,
            "outcome" => status,
          }, {
            "pushed_at" => "2013-02-11T03:09:54Z",
            "vcs_revision" => "0553ba86b35a97e22ead78b0d568f6a7c79b838d",

            "build_num" => 21,
            "outcome" => "failed",
          }],
          "running_builds" => running_builds
        }
      }
    }
  end

end

RSpec.configure do |conf|
  conf.extend MocksHelper
  conf.include MocksHelper
end
