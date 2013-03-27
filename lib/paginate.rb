module Paginate

  def paginate3(model,page=1, hash={},sort={},pcount= 15)
    @page =  page ? page.to_i : 1
    if @page < 0
      sort = {:_id => -1} if sort.blank?
      sort.keys.each{|k| sort[k] = sort[k]*-1}
    end
    @pcount =  pcount ? pcount.to_i : 15
    cons = model.classify.constantize
    skip = (@page.abs - 1)*@pcount
    @colls = cons.where(hash).skip(skip).limit(@pcount).sort(sort)
  end

  def paginate2(model,page=1, hash={},sort={},pcount={})
    @page =  page ? page.to_i : 1
    @pcount =  pcount ? pcount.to_i : 15
    cons = model.classify.constantize
    skip = (@page - 1)*@pcount
    cons.where(hash).skip(skip).limit(@pcount).sort(sort)
  end

  def paginate(model, page =1, hash = {}, sort={}, pcount = 15)
    @page =  page ? page.to_i : 1
    @pcount =  pcount ? pcount.to_i : 15
    cons = model.classify.constantize
    @total_entries = cons.where(hash).count
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