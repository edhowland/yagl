Before do  
  rm_rf path('tmp', 'mygem')
  mkdir path('tmp', 'mygem') 
  pushd 'tmp'
end

After do
  popd
end


