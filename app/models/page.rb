class Page < ActiveRecord::Base
  
  def self.path_join(path)
  	File.join(Rails.configuration.x.data.text_path, path)
  end

  def save_to_file()
    full_path = self.class.path_join(path)
  	File.write(full_path, text)
    full_path.to_s
  end

  def self.load_from_file(path)
  	page = where(path: path).first_or_create
  	page.text = File.read(self.path_join(path))
  	page.save()
  end

  # should be moved somewhere else
  def self.add_and_commit(pathes)
    g = Git.open(Rails.configuration.x.data.text_path)
    g.add(pathes)
    g.commit("added files")
  end
end