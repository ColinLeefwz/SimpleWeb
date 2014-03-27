class SearchController < ApplicationController

  def query
    respond_to do |format|
      format.js{
        query = "*#{params[:query]}*"
        records = weight_based_sort(query)

        @items = records.inject([]) do |memo, obj|
          memo << obj[:type].constantize.find(obj[:id])
        end
      }
    end
  end

  def autocomplete

    query = "*#{params[:query]}*"
    records = weight_based_sort(query)

    results = records.inject([]) do |memo, obj|
      memo << {val: obj[:type].constantize.where(id: obj[:id]).pluck(:title)}
    end

    render json: results
  end


  private
  def weight_based_sort(query)
    results = %w(VideoInterview Announcement Article Course).inject([]) do |memo, obj|
      memo << obj.constantize.search(query)
    end

    records = []

    results.each do |collection|
      collection.each do |hit|
        records << {type: hit._type.camelize, id: hit._source.id, score: hit._score}
      end
    end

    records.sort{|x,y| y[:score] <=> x[:score]}
  end

end
