Before do  
  rm_rf path('tmp', 'mygem')
  mkdir path('tmp', 'mygem') 
  pushd 'tmp'
end

After do
  popd
end


Then /^the output should be$/ do |string|
  pending # express the regexp above with the code you wish you had
end
