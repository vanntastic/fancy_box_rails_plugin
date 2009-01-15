module FancyBox
  
  # includes all the files necessary to use fancy_box
  # just put <%= include_fancy_box %> in the head of your page
  def include_fancy_box
    content = javascript_include_tag('jquery.fancybox-1.0.0.js','jquery.pngFix.pack.js',                                      
                                     'load_fancybox')
    content << "\n#{stylesheet_link_tag('fancy')}"                                
  end
  
  # the link method for fancy_box, has the same options as link_to and is fully equipped for ajax
  # EX : 
  #   link_to_box "Question", "#question" # => opens a div named question
  #   link_to_box "Google", "http://google.com" # => opens google in a fancy box
  #   link_to_box "About", "/about" # => opens the about page in a fancy_box
  def link_to_box(content, link, options={})
    options[:class] ||= ""
    options[:class] << " fancy"
    link_to content, link, options
  end

  # applies fancy box to an image link uses same options as link_to except first arg is image name
  # EX : 
  #   link_to_image "special.jpg"
  #   link_to_image "special.jpg", :title => "My Special Title" # => gives the pic a title
  #   please note: the title doesn't render properly if you are using a reset css file
  def link_to_image(src,options={})
    options[:class] ||= ""
    options[:class] << " fancy-img"
    link_src = File.join "/", "images", src
    link_to image_tag(src), link_src, options
  end
  
  # allows you to create a fancy box gallery, 
  # EX:
  #   fancy_gallery "first.jpg:A optional title", "second.jpg:A optional title"
  #   just pass in a list of strings and an optional title with a ":"
  #   please note: the title doesn't render properly if you are using a reset css file
  def fancy_gallery(*imgs)
    content = ""
    group_name = "group-#{random_id}"
    imgs.each do |img|
      src = img.split(":").first
      title = img.split(":").length == 1 ? "" : img.split(":").last
      # assemble the image src for the anchor tag
      link_src = File.join "/", "images", src
      content << link_to(image_tag(src, :alt => ""),link_src,:rel => group_name,:title => title)
    end
    content_tag(:div,content,:id => "gallery-#{random_id}",:class => "gallery")
  end
  
  protected
    def random_id(num_hash=9999)
      rand(num_hash)
    end
end