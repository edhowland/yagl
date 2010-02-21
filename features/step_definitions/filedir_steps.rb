

Given /^I am in the "([^\"]*)" folder$/ do |arg1|
  Dir.chdir arg1
end

Given /^I have a folder "([^\"]*)"$/ do |arg1|
  mkdir_p path(*arg1.split(/\//))
end

Given /^I have a file "([^\"]*)"$/ do |arg1|
  touch arg1
end

Given /^I have no file "([^\"]*)"$/ do |arg1|
  rm_f arg1
end

Then /^I have "([^\"]*)"$/ do |arg1|
  fail "#{arg1} doesn't exist" unless File.exists?(arg1)
end

Given /^I have a file "([^\"]*)" with contents "([^\"]*)"$/ do |arg1, arg2|
  File.open(arg1,'w+') do |f|
    f.write(arg2)
  end
end




