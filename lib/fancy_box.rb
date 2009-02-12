module FancyBox
  
  # includes all the files necessary to use fancy_box
  # just put <%= include_fancy_box %> in the head of your page
  def include_fancy_box(*args)
    content = javascript_include_tag('jquery.fancybox-1.0.0.js','jquery.pngFix.pack.js',                                      
                                     'load_fancybox')
    content << "\n#{stylesheet_link_tag('fancy')}"                                
  end
  
  # the link method for fancy_box, has the same options as link_to and is fully equipped for ajax
  # EX : 
  #   link_to_box "Question", "#question" # => opens a div named question
  #   link_to_box "Google", "http://google.com" # => opens google in a fancy box
  #   link_to_box "About", "/about" # => opens the about page in a fancy_box
  #   link_to_box "About", "/about", 
  #               :title => "About Us" # => opens about page in a fancy_box with a a title
  #   link_to_box "Super Special", '#super-special', :title => :auto
  #       # => sets the title to the content
  #   link_to_box "Special Box", "#special", :box_class => "small"
  #       # => Opens #special with the class of 'small' assuming that you set it 
  #            up in load_fancybox.js
  def link_to_box(content, link, options={})
    box_class = options[:box_class].nil? ? "fancy" : options[:box_class]
    options[:title] = content if options[:title] == :auto
    options[:class] << " #{box_class}" unless options[:class].nil?
    options[:class] = "#{box_class}" if options[:class].nil?
    
    options.delete :box_class
    link_to content, link, options
  end

  # applies fancy box to an image link uses same options as link_to except first arg is image name
  # EX : 
  #   link_to_image "special.jpg"
  #   link_to_image "special.jpg", :title => "My Special Title" # => gives the pic a title
  #   link_to_image "special-thumb.jpg:special-big.jpg" 
  #       => Allows you to set a different file for the thumbnail 
  #   please note: the caption doesn't render properly if you are using a reset css file
  def link_to_image(src,options={})
    options[:class] ||= ""
    options[:class] << " fancy-img"
    link_src_ary = src.split(":")
    # if you pass a absolute path with a '/', it will know to use that instead...
    root_prefix = src.first == "/" ? "" : File.join("/","images")
    if link_src_ary.length == 1
      link_src = File.join(root_prefix, src)
    elsif link_src_ary.length == 2
      link_src = File.join(root_prefix,link_src_ary.last)
      src = File.join(root_prefix,link_src_ary.first)
    else
      raise ArgumentError, "You have too many arguments for your img src, it should be: img_src:link_src"
    end
    
    link_to image_tag(src), link_src, options
  end
  
  # allows you to create a fancy box gallery, passing an array of hashes
  # EX:
  #   fancy_gallery {:thumb => "first-thumb.jpg", :main => "first.jpg", :title => "first pic"}
  # Hash options:
  #   :thumb => "The thumbnail for the pic",
  #   :main => "The main picture to open in the fancy box",
  #   :title => "The title for your picture"
  #   NOTE: the title doesn't render properly if you are using a reset css file, 
  #         most reset css files set vertical-align: baseline, you need to change that in order
  #         for the caption to be rendered properly
  #   NOTE : if you want to change the look of the gallery, just modify the .gallery style
  def fancy_gallery(imgs=[])
    content = ""
    group_name = "group-#{random_id}"
    imgs.each do |img|
      # assemble the image src for the anchor tag
      link_src = File.join "/", "images", img[:main]
      content << link_to(image_tag(img[:thumb], :alt => ""),link_src,:rel => group_name,
                                                                     :title => img[:title])
    end
    content_tag(:div,content,:id => "gallery-#{random_id}",:class => "gallery")
  end
  
  # creates an inline fancy_box with a title
  # EX: 
  #   fancy_box :title => "My Fancy Box" do
  #     <p>Content in my fancy box</p> 
  #   end
  # OPTIONS:
  #   :title = the title of for the fancy box
  #   :title_tag = the tag for the title defaults to h3
  #   :title_options = html options for the title tag
  #   any other standard html options...
  def fancy_box(options={}, &blk)
    options[:title_tag] ||= :h3
    options[:title_options] ||= {}
    options[:style] << " display:none" unless options[:style].nil?
    options[:style] = "display:none" if options[:style].nil?
    title = content_tag(options[:title_tag], options[:title], options[:title_options])
    content = options[:title].nil? ? "\n#{capture(&blk)}" : "\n#{title}\n#{capture(&blk)}"
    %w(title title_options title_tag).each { |opt| options.delete opt.to_sym }
    concat(content_tag(:div, content, options))
  end
  
  protected
    def random_id(num_hash=9999)
      rand(num_hash)
    end
    
end