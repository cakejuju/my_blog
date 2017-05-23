class Hash
  def suc_json
    self.merge!({success: 1}).to_json
  end

  def fail_json
    self.merge!({success: 0}).to_json
  end
end