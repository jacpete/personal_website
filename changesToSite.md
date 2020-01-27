# Basic Info

## menus.toml

* site_type = "person"
* highlight = true
* highlight_languages = ["r","bash","css"]  # Add support for highlighting additional languages
* highlight_style = "atom-one-dark"
* math = true
* add email
* main_menu = {align = "r", show_logo = true}

## config.toml

* title = "Jacob Peterson"
* copyright = "&copy; 2020"
* theme = "academic"
* enableGitInfo = true

## Set specific blogdown options with .Rprofile
* default to .Rmd
* author name

## Edit Authors \_index.md

## Edit files in home folder to specify what widgets are shown

## copied post and made a blog duplicate
* blogs.md
* menu.toml

## edit menu.toml to include tabs and links I want

# Specialized

## customize post archetype to be called blog-post

draft: true  
output:  
  blogdown::html_page:  
    toc: true


## edited site_footer.html
*	commented out privacy policy and terms

## script to update data from other repos

## add blog page
* create new folder
* add index with folowing in YAML

title: "Blog Posts"  # Add a page title.  
summary: "Hello!"  # Add a page description.  
date: ""  # Add today's date.  
type: "widget_page"  # Page type is a Widget Page  

* Add widget md files for blogs and tags and customize
* create custom header widget
  - add custom css with https://sourcethemes.com/academic/docs/customization/#customize-style-css
    - add assets/scss/custom.scss
    - add new h1 and h2 classes for title and subtitle
    - edit from hero.html to get down to basics of just the title for widgetTitle.html
    - note: had to keep restarting R and re-serving site to get new edits to custom.scss to load (when in doubt restart r and re-serve)
  - copy hero widget
  - create new heading class (heading.options) in toml of widgetTitle.md and reference shortcut to get parameters in the widget.html ($ho)
    - still need to add these options in
  [] need to add if thens for options


## fancypagination
* Copy script from https://glennmccomb.com/articles/how-to-build-custom-hugo-pagination/ to /layouts/partials/fancypagination.html
* Add justify-content-center class to the ul in fancypagination.html to get centering
* Add css for this section to custom.scss
* in blog.html change  
{{ partial "pagination" . }}  
to  
{{ partial "fancypagination.html" . }}  

## tag cloud
* create term_cloud.html as a partial controlling the tag cloud
* mostly copied form one source but had to edit it to get the sizing to happen automatically
* added partial call to blog.html

