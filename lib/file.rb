class File
  #safe prepend to avoid exhausting RAM by storing lines
  def self.prepend_write(file_name, str)
    new_file = file_name + ".new"
    File.open(new_file, 'w') do |new_f|
      new_f.print str
      File.foreach(file_name) do |line|
        new_f.puts line
      end
    end
    File.rename(new_file, file_name) #overwrites
  end
end
