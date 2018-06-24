class File
  #safe prepend to avoid exhausting RAM by storing lines
  def prepend_write(filename, str)
    old_file = file_name + ".old"
    new_file = file_name + ".new"
    File.rename(filename, old_file)
    File.open(new_file, 'w') do |new_f|
      new_f.print str
      File.foreach(old_file) do |line|
        new_f.puts line
      end
    end
    File.rename(new_file, filename)
    File.delete(old_file)
  end
end
