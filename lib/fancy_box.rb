module FancyBox
  include Constants
  # includes all the files necessary to use fancy_box
  # just put <%= include_fancy_box %> in the head of your page
  def include_fancy_box(*args)
    content = 
         javascript_include_tag('jquery.fancy_box/jquery.fancybox-1.3.1.pack.js',
                                'jquery.fancy_box/jquery.easing-1.3.pack.js',
                                'jquery.fancy_box/load_fancybox',
                                'jquery.fancy_box/jquery.mousewheel-3.0.2.pack.js', 
                                 :cache => "fancy_box")
    content << "\n#{stylesheet_link_tag('jquery.fancybox.css')}".html_safe
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
  # 
  
  def link_to_box(content, link, options={})
    box_class = options[:box_class].nil? ? "fancy" : options[:box_class]
    elem_id = "fancylink-#{random_id}"
    options[:title] = content if options[:title] == :auto
    options[:class] << " #{box_class}" unless options[:class].nil?
    options[:class] = "#{box_class}" if options[:class].nil?
    options[:class] << " iframe" if determine_request(link) == :remote 
    options[:id] = elem_id
    link_content = link_to content, link, options
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
      has_img_path = img[:main].split("/").include?("images")
      link_src = has_img_path ? img[:main] : File.join("/", "images", img[:main])
      content << link_to(image_tag(img[:thumb], :alt => ""),link_src,:rel => group_name,
                                                                     :title => img[:title])
    end
    content_tag(:div,content,:id => "gallery-#{random_id}",:class => "gallery")
  end
  
  # creates an inline fancy_box with a title
  # EX: 
  #   Standard fancy box without link
  #     fancy_box :title => "My Fancy Box", :id => "my-box" do
  #       <p>Content in my fancy box</p> 
  #     end
  #   Fancy box with a link
  #     fancy_box :title => "My Fancy Box", :id => "my-box",
  #               :link => "My fancy box" do
  #       <p>Content in my fancy box</p>
  #     end
  # OR
  #   Fancy box with link and link options
  #     fancy_box :title => "My Fancy Box", :id => "my-box",
  #               :link => {:content => "My Fancy Box", 
  #                         :options => {:id => "box-link"}
  #                        } do
  #       <p>Content in my fancy box</p>
  #     end
  
  # OPTIONS:
  #   :title = the title of for the fancy box
  #   any other standard html options...
  #   :link => options for embedding a link or the content of the link
  #       :content => "Content of your link",
  #       :options => "html options for the anchor tag"
  
  def fancy_box(options={}, &blk)
    options[:title_tag] ||= :h3
    options[:title_options] ||= {}
    title_content = options[:title]
    title = content_tag(options[:title_tag], title_content, 
                        options[:title_options])
    link = options[:link]
    %w(title title_options title_tag link).each { |opt| options.delete opt.to_sym }
    blk = content_tag(:div, content_tag(:div, capture(&blk), options), 
                      :style => "display:none")
    if link.nil?
      blk
    else
      if link.is_a?(String)
        anchor = link_to_box(link, "##{options[:id]}", :title => title_content)
      else
        link[:options].update :title => title_content
        anchor = link_to_box(link[:content], "##{options[:id]}", link[:options])
      end
      "#{anchor}#{blk}".html_safe
    end
  end
  
  protected
    def random_id(num_hash=9999999)
      rand(num_hash*9)
    end
    
    # determines the request 
    def determine_request(req)
      return :img if IMAGE_TYPES.include?(req.split(".").last)
      return :remote if TLDS.match(req)
      return :standard
    end
    
end
