Feature:  Generate source/assembly from supported data sources
 
  As a developer I want to spend more time solving business problems and less time writing
  the plumbing to retrieve data from data sources since this code is very similar for each
  source.  We want to generate code to manage the access and management of the data based
  on the data source provide.  The output of the generator should be available for multiple
  languages as configured.  

  Scenario Outline:  Code Generation - Text File input type
    Given I've selected "<language>" as my output language
    And my input type is "text"
    And my source file is "<source-file>"
    And I will indicate if the file has a header here "<has-header>"
    And I select "<model-type>" as my output for the models
    And I pass the model output directory here "<model-output>"
    And I pass the service output directory here "<service-output>"
    When I run the script 
    Then I should see the the model file here "<model-file-name>"
    And  I should see the the service file here "<service-file-name>"
    

    Scenarios: Ruby Code Gen - Text Files
    | language | source-file                           | has-header | model-type | model-output | service-output | model-file-name | service-file-name |
    | ruby     | ../../spec/generator/data/allstar.txt | false      | src        | ../spec/generator/out | ../spec/generator/out | allstar_txt.rb | allstar_txt_service.rb | 
    | ruby     | ../../spec/generator/data/Allstar_with_headers.txt | true      | src        | ../spec/generator/out | ../spec/generator/out | allstar_txt.rb | allstar_txt_service.rb | 
    | ruby     | ../../spec/generator/data/Allstar_with_headers.txt | false     | src        | ../spec/generator/out | | allstar_txt.rb | | 
    | ruby     | ../../spec/generator/data/Allstar_with_headers.txt | true      | src        | ../spec/generator/out | | allstar_txt.rb | | 
    | c_sharp  | ../../spec/generator/data/allstar.txt | false      | src       | ../spec/generator/out | ../spec/generator/out | Allstartxt.cs | AllstarTxtService.cs | 
    | c_sharp  | ../../spec/generator/data/Allstar_with_headers.txt | true      | src       | ../spec/generator/out | ../spec/generator/out | Allstartxt.cs | AllstarTxtService.cs | 
    | c_sharp  | ../../spec/generator/data/Allstar_with_headers.txt | false     | src        | ../spec/generator/out | | Allstartxt.cs | | 
    | c_sharp  | ../../spec/generator/data/Allstar_with_headers.txt | true      | src        | ../spec/generator/out | | Allstartxt.cs | | 
