When /^I run "([^\"]*)"$/ do |arg1|
  fail("command #{arg1} failed |#{$?}|") unless IO.popen(dirs.first + '/bin/' + arg1) do |p|
    $output = p.read
  end
end

$output = ''
When /^I run local command "([^\"]*)"$/ do |arg1|
  cmd, arg = arg1.split(%r{ })
  fail("local command #{cmd} Not Found in dir #{Dir.pwd}") unless File.exists?(cmd)
  fail("local command #{cmd} with arg #{arg} failed |#{$?}|") unless IO.popen("#{cmd} #{arg}") do |io|
    $output = io.read
  end
end

Then /^the output should be$/ do |string|
  $output.should == string
end



