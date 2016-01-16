if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter "spec/"
    add_filter "vendor/"
    add_group "Services",     "app/services"
    add_group "Policies",     "app/policies"
    add_group "Jobs",         "app/jobs"
  end
end
