local helpers = {}

helpers.reverse_table = function(t)
  local new_table = {}

  for i = #t, 1, -1 do
    table.insert(new_table, t[i])
  end

  return new_table
end


return helpers
