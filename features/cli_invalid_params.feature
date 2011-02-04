Feature: Generator Command Line Interface

  As a user  
  I want to generate code from a data source at the command line 
  that allows me to access the source data.

  Scenario Outline: start generation from command line with invalid options
    Given I have not started the script
    When I start a generation job with "<cmd_1>" "<val_1>" and no "<cmd_2>" "<val_2>"
    Then I should see "<msg_0>"
    And I should see "<msg_1>"

    Scenarios: no options
      | cmd_1 | val_1 | cmd_2 | val_2 | msg_0             | msg_1                      | msg_2                         |
      |       |       |       |       | Required Options: | --input-type, -i  db\|text | --language, -l  ruby\|c_sharp |

    Scenarios: one required option
      | cmd_1        | val_1   | cmd_2        | val_2 | msg_0             | msg_1                      | msg_2                         |
      | --input-type | db      | -tada        |       | Required Options: | --input-type, -i  db\|text | --language, -l  ruby\|c_sharp |
      | --i 	     | db      | -lala        |       | Required Options: | --input-type, -i  db\|text | --language, -l  ruby\|c_sharp |
      | --language   | c_sharp | -in          |       | Required Options: | --input-type, -i  db\|text | --language, -l  ruby\|c_sharp |
      | --l 	     | db      | -tt          |       | Required Options: | --input-type, -i  db\|text | --language, -l  ruby\|c_sharp |

  Scenario Outline: start generation from command line with valid options that have invalid values
    Given I have not started the script
    When I start a generation job with "<cmd_1>" "<val_1>" and no "<cmd_2>" "<val_2>"
    And I should see "<msg_1>"
    And I should see "<msg_2>"

    Scenarios: required options present but one has an invalid value
      | cmd_1        | val_1   | cmd_2        | val_2   | msg_1                             | msg_2                              |
      | --input-type | db      | --language   | ada     | 'ada' is not a supported language | Supported Languages: ruby, c_sharp |
      | -i           | db      | -l           | C++     | 'C++' is not a supported language | Supported Languages: ruby, c_sharp |
      | --input-type | from    | --language   | ruby    | 'from' is not a supported input type  | Supported Input Types: text, db |
      | -i 	     | blah    | --language   | ruby    | 'blah' is not a supported input type  | Supported Input Types: text, db |

  Scenario Outline: Start generation from command line with valid required options and optionals missing their values
    Given I have not started the script
    When I start a generation job with "<cmd_1>" "<val_1>" "<cmd_2>" "<val_2>" "<cmd_3>" "<val_3>"
    Then I should see "<msg_0>"
    And I should see "<msg_1>"

    Scenarios: Missing Optional Values
      | cmd_1 | val_1 | cmd_2 | val_2 | cmd_3   | val_3 | msg_0                                   | msg_1                                |
      | -i    | db    | -l    | ruby  | -m      | ears  | 'ears' is not a supported output option | Supported Output Options: emit, src (default) |
      | -i    | db    | -l    | ruby  | --model | ears  | 'ears' is not a supported output option | Supported Output Options: emit, src (default) |

  Scenario Outline: Start generation from command line with valid required options and optionals missing its value (no set of valid options)
    Given I have not started the script
    When I start a generation job with "<cmd_1>" "<val_1>" "<cmd_2>" "<val_2>" "<cmd_3>" "<val_3>"
    Then I should see "<msg_0>"

    Scenarios: Missing Value
      | cmd_1 | val_1 | cmd_2 | val_2 | cmd_3   | val_3 | msg_0 |
      | -i    | db    | -l    | ruby  | -a      |       | -a \| --assembly requires a name (.NET only) | 
      | -i    | db    | -l    | ruby  | --assembly |    | -a \| --assembly requires a name (.NET only) |
      | -i    | db    | -l    | ruby  | -mn      |       | -mn \| --model-namespace requires a name | 
      | -i    | db    | -l    | ruby  | --model-namespace |    | -mn \| --model-namespace requires a name |
      | -i    | db    | -l    | ruby  | -mod      |       | -mod \| --model-output-dir requires a valid directory | 
      | -i    | db    | -l    | ruby  | --model-output-dir | c:\zzzz | -mod \| --model-output-dir requires a valid directory | 
      | -i    | db    | -l    | ruby  | -sod      |       | -sod \| --service-output-dir requires a valid directory | 
      | -i    | db    | -l    | ruby  | --model-output-dir |       | -mod \| --model-output-dir requires a valid directory | 
      | -i    | db    | -l    | ruby  | -sod      |       | -sod \| --service-output-dir requires a valid directory | 
      | -i    | db    | -l    | ruby  | --service-output-dir |       | -sod \| --service-output-dir requires a valid directory | 
      | -i    | db    | -l    | ruby  | -imp |       | -imp \| --imports requires at least a name and can be a comma-delimeted list | 
      | -i    | db    | -l    | ruby  | --imports |       | -imp \| --imports requires at least a name and can be a comma-delimeted list | 

  Scenario Outline: When I pass the quiet command-line option I should see no output from the script
    Given I have not started the script
    When I start a generation job with "<cmd_1>" "<val_1>" "<cmd_2>" "<val_2>" "<cmd_3>" "<val_3>" "<cmd_4>"
    Then I should see no output

    Scenarios: quiet mode
      | cmd_1      | val_1   | cmd_2        | val_2     | cmd_3 | val_3                                 | cmd_4 |
      | -l         | ruby    | -i           | text      | -sf   | ../spec/generator/data/allstar.txt | -q    |
      | --language | c_sharp | --input-type | text      | -sf   | ../spec/generator/data/allstar.txt | --quiet | 

  Scenario Outline:  When I pass the -h or --help command I should see the usage message displayed
    Given I have not started the script
    When I pass the command "<cmd>"
    Then I should see "Required Options:"
    And I should see "--input-type, -i  db|text"
    And I should see "--language, -l    ruby|c_sharp"
    And I should see ""
    And I should see "Optional:"
    And I should see "--assembly, -a  name of the output assembly (.NET only)"
    And I should see "--service-output-dir, -sod  the name of the directory to place the service source"
    And I should see "--help, -h  displays this message"
    And I should see "--imports, -i   the name of the libraries to include in the generated source" 
    And I should see "--model, -m  src | emit (.NET only) - indicates how you want the model code created"
    And I should see "--model-output-dir, -mod  the name of the directory to place the model source/dll"
    And I should see "--quite, -q  runs the script without writing output"

    Scenarios: help flags
      | cmd |
      | -h  |
      | --help |
