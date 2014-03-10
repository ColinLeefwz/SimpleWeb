class SearchController < ApplicationController

  def query
    respond_to do |format|
      format.js{
        query = "*#{params[:query]}*"

        @items = %w(VideoInterview Announcement Article Course).inject([]) do |memo, obj|
          memo + obj.constantize.search(query).records
        end

        %w(Chapter Section).each do |c|
          c.constantize.search(query).records.each do |r|
            @items << r.try(:course)
          end
        end

        @items = @items.flatten.sort{|x, y| y.updated_at <=> x.updated_at}
      }
    end
  end

  def autocomplete
    query = "*#{params[:query]}*"

    titles = %w(Article Announcement VideoInterview Course).inject([]) do |memo, obj|
      memo + obj.constantize.search(query).records.pluck(:title)
    end

    results = titles.map{|t| {val: t}}

    render json: results
  end
  
end
