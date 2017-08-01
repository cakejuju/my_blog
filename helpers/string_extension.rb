class String
  # TODO defined method   responed_to? :marked

  def marked
    Markdown.new(self).to_html
  end

  # convert  "/n" to "/n/n"
  def two_slashN
    arr = self.gsub("\n", '叆').split("")
    
    n_array = arr.each_index.select{|i| arr[i] == '叆'}

    n_array.each do |v|
      next if ( n_array.include?(v-1) || n_array.include?(v+1) )
      arr[v] = '骉'
    end  
    new_str = arr.join('')
    new_str.gsub!("叆", "\n")
    new_str.gsub!("骉", "\n\n")

    new_str
  end
end