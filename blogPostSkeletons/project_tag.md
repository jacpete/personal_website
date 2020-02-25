I want to create a custom taxonomy called 'project-tags' that can be used by the portfolio widget so I don't clutter up the default tag taxonomy that I use for blogs. I have got it almost working, but I am having trouble getting the 'All' selector to work.

You see my full progress in my `project_tags` branch at [https://github.com/jacpete/personal_website/tree/project_tags](https://github.com/jacpete/personal_website/tree/project_tags), but I will summarize my steps below.

This issue is similar to @tarheels100 issue #1483 and @HughP #1287, but I have gone through and edited the partial noted by @gcushen in [https://github.com/gcushen/hugo-academic/issues/1287#issuecomment-522093247](https://github.com/gcushen/hugo-academic/issues/1287#issuecomment-522093247)

## Create Project Tags Taxonomy
In my config.toml file, I added a new taxonomy called `project_tag`

```
[taxonomies]
  tag = "tags"
  category = "categories"
  publication_type = "publication_types"
  author = "authors"
  project_tag = "project_tags"
```

## Add Taxonomy to Project Index files
I changed the tags in my project `index.md` files to reflect the new taxonomy type in the YAML:

```
#tags:
#  - Data Science Portfolio
project_tags:
  - Data Science Portfolio
```

## Edit html layouts dealing with the tag

### Make local copies of the following layouts from the theme folder into your `/layouts` folder

* `/themes/academic/layouts/partials/widgets/portfolio.html` to `/layouts/partials/widgets/portfolio_projects.html`
* `/themes/academic/layouts/partials/portfolio_li_card.html` to `/layouts/partials/project_portfolio/portfolio_li_card.html`
  - If you want to use a different list type besides card you will need to make the edits to that particular portfolio_li_*.html file

#### portfolio_projects.html

What I did was a find and replace in the document to change all `.tag` entries to `.project_tag`. As your changing it just read through the code to ensure you aren't changing the wrong thing.

Also change the following line:  
 ` {{ partial "portfolio_li_card" (dict "widget" $st "index" $idx "item" $item "link" $link "target" $target) }}`   
 to  
 ` {{ partial "project_portfolio/portfolio_li_card" (dict "widget" $st "index" $idx "item" $item "link" $link "target" $target) }}`  
This makes the layout look for your custom list layout (again adapt to the list type you want to use).

#### portfolio_li_card.html

In this one do essentially the same thing except replace `.tags` with `.project_tags`. If I remember right there was only one you had to change in this document.

## Edit your widget settings
* In your `/content/home/projects.md` file, change the widget setting from `portfolio` to `portfolio_projects`
* Ensure your View setting is set to the layout type you want in my case `View = 3` (Card)
* Edit your `[[content.filter.buttons]]` to use `project_tag` instead of `tag`  
Example:  


```toml
[[content.filter_button]]
  name = "All"
  project_tag = "*"

[[content.filter_button]]
  name = "Data Science Portfolio"
  project_tag = "Data Science Portfolio"
```

## Continuing issues
For the most part this solution works. However I am still having a few issues. All the project tags load initially (only have 2 on my site right now) like the `All` button is selected (this is correct behavior as I have the `filter_default = 0`).  


And the correct project gets selected when I select the `Data Science Portfolio` button.  


However, if I try to go back to the `All` button nothing is selected.


In the css in my browser I can see that when the project is not showing up, the div container with the class `project-card project-item isotop-item` changes style to include the `display: none;`. I understand that this is the option that is keeping it from displaying, but I do not understand exactly where in the theme code that this selection gets turned on and off.

I did find this section in `/themes/academic/assets/js/academic.js` that might have something to do with the selection, but I currently have no experience with javascript and can't understand everything that is happening in the snippet.

```javascript
// Filter projects.
$('.projects-container').each(function(index, container) {
  let $container = $(container);
  let $section = $container.closest('section');
  let layout;
  if ($section.find('.isotope').hasClass('js-layout-row')) {
    layout = 'fitRows';
  } else {
    layout = 'masonry';
  }

  $container.imagesLoaded(function() {
    // Initialize Isotope after all images have loaded.
    $container.isotope({
      itemSelector: '.isotope-item',
      layoutMode: layout,
      masonry: {
        gutter: 20
      },
      filter: $section.find('.default-project-filter').text()
    });

    // Filter items when filter link is clicked.
    $section.find('.project-filters a').click(function() {
      let selector = $(this).attr('data-filter');
      $container.isotope({filter: selector});
      $(this).removeClass('active').addClass('active').siblings().removeClass('active all');
      return false;
    });
```

If any one has any other ideas on how to get the `All` button functioning correctly, I would be much obliged. At this point I am stumped.

