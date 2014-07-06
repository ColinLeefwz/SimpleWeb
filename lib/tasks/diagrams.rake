namespace :doc do
  namespace :diagram do
    task :models_svg do
      sh "railroad -i -l -a -m -M | dot -Tsvg | sed 's/font-size:14.00/font-size:11.00/g' > doc/models.svg"
    end

    task :controllers_svg do
      sh "railroad -i -l -C | neato -Tsvg | sed 's/font-size:14.00/font-size:11.00/g' > doc/controllers.svg"
    end
    
    task :models do
      sh "railroad -i -l -a -m -M | dot -Tpng > doc/models.png"
    end

    task :controllers do
      sh "railroad -i -l -C | neato -Tpng > doc/controllers.png"
    end    
    
    
  end

  task :diagrams => %w(diagram:models diagram:controllers)
  
end

