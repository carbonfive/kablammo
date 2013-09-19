class String
  def is_local_dir?
    File.directory?(self)
  end
end