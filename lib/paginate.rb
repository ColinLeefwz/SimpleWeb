module Paginate
  def paginate(model_or_array, page =1, hash = {}, sort={}, pcount = 15)
    @page =  page ? page.to_i : 1
    @pcount =  pcount ? pcount.to_i : 15
    cons = model_or_array.classify.constantize
    @total_entries = cons.where(hash).length
    @last_page = (@total_entries+@pcount-1)/@pcount
    skip = (@page - 1)*@pcount
    cons.where(hash).skip(skip).limit(@pcount).sort(sort)
  end

  def paginate_arr(model_or_array, page =1, pcount = 15)
    @page =  page ? page.to_i : 1
    @pcount =  pcount ? pcount.to_i : 15
    @total_entries = model_or_array.length
    @last_page = (@total_entries+@pcount-1)/@pcount
    skip = (@page - 1)*@pcount
    model_or_array[skip, @pcount]
  end


end