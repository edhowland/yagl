When /^I run "([^\"]*)"$/ do |arg1|
  fail("command #{arg1} failed |#{$?}|") unless system(dirs.first + '/bin/' + arg1)
end

When /^I run local command "([^\"]*)"$/ do |arg1|
  cmd, arg = arg1.split(%r{ })
  fail("local command #{cmd} Not Found in dir #{Dir.pwd}") unless File.exists?(cmd)
  fail("local command #{cmd} with arg #{arg} failed |#{$?}|") unless system(cmd, arg)
end




