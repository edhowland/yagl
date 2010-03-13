Feature: Option command
  In order to value
  As a role
  I want feature
  
  Scenario Outline: Option command in Yaglfile
  Given I am in the "mygem" folder
  And I have a folder "bin"
  And I have a file "Yaglfile" with command "<command>" and args "<args>"
  When I run "yagl --verbose --pretend ."
  Then the output should be
  """
  <output>
  
  """

  Scenarios:
    |command|args|output|
    |option|:dummy|-d, --dummy                    Show this dummy|
    |option|:imbecil, :I, [:binary]|-I, --[no-]imbecil                  Show this imbecil|
    |option|:moron, [:binary]|-m, --[no-]moron                    Show this moron|
    |option|:witless, [:argument]|-w, --witless WITLESS          Show this witless|
  

  

  
