def hash_return(params)
  params[:page] = 1
end

p hash_return(per_page: 10)

