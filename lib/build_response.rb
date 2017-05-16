require 'active_support'
require 'active_support/core_ext/hash/conversions'
require 'nokogiri'
require 'uri'
require 'open-uri'
require 'json'

# Fetch, parse and return build status from FB_PROXY_URL
# If proxy_url is not defined, returns a dummy response instead
# Currently it only knows how to handle the CruiseControl XmlStatusReport build format
class BuildResponse

  # Returns an instance of the response builder based on ci_server_type
  def self.get_instance(ci_server_url, ci_server_type)
    klass = case "#{ci_server_type}".downcase
    when "circleci"
      CircleCi
    else
      CruiseControl
    end
    klass.new(ci_server_url)
  end

  class Base

    attr_accessor :ci_server_url

    def initialize(ci_server_url=nil)
      self.ci_server_url = ci_server_url.presence
    end

    def response
      ci_server_url ? to_csv : dummy_status
    end

    protected

    # Returns a dummy CSV response for testing purposes
    def dummy_status
      return <<-EOS
  dummy_project_1,Sleeping,Success
  dummy_project_2,Sleeping,Failure
  dummy_project_3,CheckingModifications,Success
  dummy_project_4,CheckingModifications,Failure
  dummy_project_5,Building,Success
  dummy_project_6,Building,Failure
  dummy_project_7,Unknown,Success
  dummy_project_8,Unknown,Failure
      EOS
    end

    # Returns build status in a simplified csv format
    # Projects are listed in alphabetical order
    def to_csv
      to_hash['projects'].map do |project|
        [project['name'], project['activity'], project['lastBuildStatus']].join(',')
      end.sort.join("\n")
    end

    # Returns a hash of projects with critical elements lastBuildStatus, name and activity
    # {"projects"=>[
    #   {"lastBuildStatus"=>"Success", "name"=>"project_2",  "activity"=>"Sleeping", ...}
    # ]}
    # name:: project name
    # activity: (CheckingModifications,Building,Sleeping,Unknown)
    # lastBuildStatus: (Success,Unknown,Failure)
    def to_hash
      {}
    end

    def status_report
      open(ci_server_url).read
    end

  end

  class CruiseControl < Base

    def to_hash
      hash = Hash.from_xml to_xml
      {'projects' => hash['Projects']['Project']}
    end

    def to_xml
      parser.to_s
    end

    def parser
      Nokogiri::XML status_report
    end

  end

  class CircleCi < Base

    # Parse projects response to standardised hash structure
    def to_hash
      results = JSON.parse(status_report)
      projects = results.map do |result|
        if master_branch_builds = result["branches"]["master"] rescue nil
          latest_build = master_branch_builds["recent_builds"].first || {}
          status = latest_build["outcome"] || "Unknown"
          activity = master_branch_builds["running_builds"].present? ? "Building" : "Sleeping"
          {
            "lastBuildStatus"=> status.capitalize,
            "name" => result["reponame"],
            "activity" => activity
          }
        end
      end.compact
      {'projects' => projects}
    end

  end


end