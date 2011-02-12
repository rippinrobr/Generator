Feature: Create Code from a URL Source
 
  I want to be able to create source code from a source that is on the web.
  The the first source site produces JSON that I want to create model(s) and
  services for that will allow me to read the data online, create the necessary
  code to read the data.

  Scenario Outline:  Read data from a URL that returns JSON
    Given the source "<url>"
    And I have a model output dir of "<model_output_dir>"
    And I have a service output dir of "<service_output_dir>"
    When I run the generator to create a model and service class in the language "<language>"
    Then I should see a model class file with the name "<model_file_name>"
    And a service class file with the name "<service_file_name>"

    Scenarios:  valid options
      | url | language | model_file_name | model_output_dir | service_file_name | service_output_dir | model_output |
      | http://localhost:8098/riak/era_percentile/1979_AL | ruby | seasonal_era_percentile.rb | /tmp | seasonal_era_percentile_service.rb | /tmp | src |
      | http://localhost:8098/riak/era_percentile/1979_AL | c_sharp | SeasonalEraPercentile.cs | /tmp | SeasonalEraPercentileService.cs | /tmp | src |
