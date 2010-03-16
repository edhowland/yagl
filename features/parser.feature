Feature: Parser
  In order to value
  As a role
  I want feature

  Scenario: Script command named :autorun outputs do block in template
    Given I am in the "mygem" folder
    And I have a folder "bin"
    And I have a file "Yaglfile" with contents
    """
    script :autorun do
      v = 1
      q = 2
      puts v + q * 4
      puts "done"
    end
    
    """
    And I have a file "mygem.erb" with contents
    """
    <%= autorun %>
    
    """    
    When I run "yagl -s mygem.erb ."
    Then I should have a file "bin/mygem" with contents
    """
    v = 1
    q = 2
    puts v + q * 4
    puts "done"
    
    """
    
  
  
  
