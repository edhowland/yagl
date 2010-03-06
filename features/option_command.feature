Feature: Option command
  In order to value
  As a role
  I want feature
  
  Scenario Outline: Option command in Yaglfile
  Given I am in the "mygem" folder
  And I have a folder "bin"
  And I have a file "Yaglfile" with command "<command>" and args "<args>"
  When I run "yagl --verbose --pretend ."
  Then I the output should be "<output>"

  Scenarios:
    |command|args|outout|
    |option|:dummy|-d, --[no]-dummy ""|
    |option|:imbecil, :I|-I --[no]-imbecil ""|
    |option|:moron, "As in non oxy-"|-m, --[no]-moron, "As in non oxy-""|
    |option|:witless, [:required]|-w, --witless, ""|
  

  

  
