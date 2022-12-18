# boss for each rusty test file
class RustyBoss
  attr_reader :tag
  
  def initialize(tag)
    @tag = tag
  end
  
  def preprocess(rem, m) rem end
  def skip_fn(m) nil end  
end

