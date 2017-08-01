class Hash

  EXTENSION_METHODS = 
  [
    {method_name: 'suc_json', success_val: 1},
    {method_name: 'fail_json', success_val: 0}
  ]

  EXTENSION_METHODS.each do |m|
    define_method m[:method_name] do 
      keys = self.keys

      if keys.include?(:success) || keys.include?('success')
        return self.to_json
      end
      self.merge!({success: m[:success_val]}).to_json
      end
  end

  # def suc_json
  #   keys = self.keys
  #   if keys.include? :success || keys.include? 'success'
  #     return self.to_json
  #   end
  #   self.merge!({success: 1}).to_json
  # end

  # def fail_json
  #   self.merge!({success: 0}).to_json
  # end
end


