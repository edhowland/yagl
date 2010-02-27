Feature: something something
  In order to make gem development easier
  As a user I would like to generate a generator
  So that I have a generator script

  Scenario: Empty or missing Yaglfile
    Given I am in the "mygem" folder
    And I have a folder "bin"
    And I have a folder "templates"
    And I have a file "templates/file.rb"
    And I have no file "Yaglfile"
    When I run "yagl ."
    Then I have "bin/mygem"
    When I run local command "bin/mygem /tmp/mygem"
    Then I have "/tmp/mygem/file.rb"

  Scenario: Simple Yaglfile
    Given I am in the "mygem" folder
    And I have a folder "bin"
    And I have a folder "templates"
    And I have a folder "templates/ruby"
    And I have a folder "templates/ruby-19"
    And I have a file "templates/ruby/file.rb"
    And I have a file "templates/ruby-19/file.rb"
    And I have a file "Yaglfile" with contents "template :ruby_19"
    When I run "yagl ."
    And I run local command "bin/mygem --help"
    Then the output should be
    """
    Usage:
      mygem [options] destination
      Template Options:
         -r, --ruby                     install the ruby template
         --ruby-19                      install the ruby-19 template
      General options:
         -f, --force                    force overwriting files, don't ask
         -s, --skip                     skip file if it exists
         -q, --quiet                    runs quietly, no output
         -V, --verbose                  Show lots of output
         -v, --version                  Show this version
         -p, --pretend                  dry run, show what would have happened
         -x, --debug                    Show debugging output
         -h, --help                     Show this help
    """
