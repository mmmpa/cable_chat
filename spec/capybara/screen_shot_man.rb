require 'pathname'

class ScreenShotMan
  class << self
    attr_accessor :dir

    def ss_dir
      raise 'Dir required' if dir.empty?
      Pathname.new(dir)
    end

    def path_for_ss(*dirs)
      ss_dir + dirs.flatten.join('/')
    end
  end

  attr_accessor :dir, :count

  def initialize(*descriptions)
    self.dir = self.class.path_for_ss(*descriptions)
    self.count = 0
  end

  def clean!
    `find #{dir}/ -name '*.png' | xargs -r rm`
  end

  def filename!(name)
    self.count += 1
    "#{dir}/#{count}_#{name}.png"
  end
end
