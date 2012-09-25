module Paginate
  def paginate(model, hash = {}, sort={}, page =1, pcount = 15)
    @page =  page ? page.to_i : 1
    @pcount =  pcount ? pcount.to_i : 15
    cons = model.classify.constantize
    @total_entries = cons.where(hash[:sql]).length
    @last_page = (@total_entries+@pcount-1)/@pcount
    skip = (@page - 1)*@pcount
    model.constantize.where(hash[:sql]).skip(skip).limit(@pcount).sort(sort)
  end
end