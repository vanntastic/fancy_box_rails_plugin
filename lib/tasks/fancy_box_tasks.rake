require 'fileutils'

PUBLIC = File.join Rails.root, "public"
CSS = File.join PUBLIC, "stylesheets"
JS = File.join PUBLIC, "javascripts", "jquery.fancy_box"
IMGS = File.join PUBLIC, "images"
FANCY_BOX_PATH = File.join Rails.root, "vendor", "plugins", "fancy_box_rails_plugin"

namespace :fancy_box do
  
  namespace :install do
    
    desc 'Install the css files'
    task :css do
      css_files = Dir.glob(File.join(FANCY_BOX_PATH, "css", "*.css"))
      FileUtils.cp_r css_files, CSS
      puts "CSS Files installed."
    end
    
    desc 'Installs the js files'
    task :js do
      Dir.mkdir JS unless File.exists?(JS)
      js_files = Dir.glob(File.join(FANCY_BOX_PATH,"js","*"))
      FileUtils.cp_r js_files, JS
      puts "JS Files installed."
    end
    
    desc 'Installs the images'
    task :images do
      public_path = File.join(IMGS,"fancy_box")
      Dir.mkdir public_path unless File.exists?(public_path)
      imgs = Dir.glob(File.join(FANCY_BOX_PATH,"images","*.{png,gif}"))
      FileUtils.cp_r imgs, public_path
      puts "Images installed."
    end
    
    desc 'Installs everything'
    task :all, 
         :needs => ['fancy_box:install:css', 'fancy_box:install:js', 'fancy_box:install:images'] do
      puts "Fancybox has been installed!"
      puts "--"
      puts "Just put <%= include_fancy_box %> in the head of your page"
    end
    
  end
  
end
