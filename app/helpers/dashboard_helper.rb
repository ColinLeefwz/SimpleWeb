module DashboardHelper
  def empty_expert_info_filter(expert_title, expert_company)
    info_arr = Array.new
    if expert_title && expert_company
      if !expert_title.empty?
        info_arr << expert_title
      end
      if !expert_company.empty?
        info_arr << expert_company 
      end
    end
    info_arr.join(", ")
  end
end
