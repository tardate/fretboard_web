# Fetch, parse and return build status from FB_PROXY_URL
# If proxy_url is not defined, returns a dummy response instead
# Currently it only knows how to handle the CruiseControl XmlStatusReport build format
class BuildResponse

  attr_accessor :proxy_url

  def initialize(proxy_url=nil)
    self.proxy_url = proxy_url.presence
  end

  def response
    proxy_url ? to_csv : dummy_status
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
      [project['name'],project['activity'],project['lastBuildStatus']].join(',')
    end.sort.join("\n")
  end

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

  def status_report
    open(proxy_url).read
  end

end