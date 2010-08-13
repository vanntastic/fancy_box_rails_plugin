FancyBox
--------

FancyBox is a rails plugin wrapper for a jquery plugin wit the same name. It's essentialy installs and gives you helper methods for using in your views. You can find the original documentation at : http://fancy.klade.lv/. Once you install you can also call it from jquery as well.

Installation
------------

* rails plugin install git://github.com/vanntastic/fancy_box_rails_plugin.git
* run rake fancy_box:install:all
* make sure you have jQuery included (e.g. <script type="text/javascript" src="http://code.jquery.com/jquery-1.4.2.min.js"></script>)
* somewhere in the head of your page, put <%= include_fancy_box %>
* That's it!

Usage
-----

To use it for inline content or remote content do:

    link_to_box "Some div", "#some-div"
    #OR
    link_to_box "google", "http://google.com"
    #OR
    link_to_box "some page", "/some/page"
    #OR to override the default fancy_box class
    link_to_box "some box", "#some-box", :box_class => "small" 

NOTE : you can also do:

    link_to "Some div", "#some-div", :class => "fancy"

To use it for images do:

    link_to_image "special.jpg"
    #OR to add in a caption
    link_to_image "special.jpg", :title => "special image"
    #OR if you want a different thumbnail pic
    link_to_image "special-thumb.jpg:special-big.jpg"

To create an image gallery with fancy boxes do:

    fancy_gallery [array of hashes]
  
    fancy_gallery {:thumb => "first-thumb.jpg", :main => "first.jpg", :title => "first pic"}
      Hash options:
        :thumb => "The thumbnail for the pic",
        :main => "The main picture to open in the fancy box",
        :title => "The title for your picture"

All the methods use standard link_to options, there are just there to save you some precious keystrokes.

NOTE : if you use a base reset css stylesheet, it will not render the caption properly, this might be due to the fact that you have td styled with vertical-align: baseline, MAKE SURE that you find that somewhere in your stylesheet and remove it or comment it out.

fancy_box method
----------------

The fancy_box helper method simply generates an inline div that allows you to add a title as well. 

EXAMPLE : 
    
     # Standard fancy box container
     fancy_box :title => "My Special Box" do
       #This is my special box with content
     end
     
     # Standard fancy box container with a link
     fancy_box :title => "My Special Box", :link => "Open Special Box" do
       #This is my special box with content
     end

OPTIONS :

    :title => "A title for your fancy_box"
    :options => standard html options for the container
    :link => "Name of link"
    OR
    :link => {:content => "Name of link", link_to_box_options}

This plugin covers the 80% use case, that basically means that it will help you create fancy boxes using convention over configuration, if you need to configure fancy_box open up load_fancybox.js and add your own settings.

Credits
-------

* based off of the fancy_box jquery plugin by : http://fancybox.net/

Copyright (c) 2009 Vann Ek, released under the MIT license
