#Ensure blogdown is installed
if (!require(blogdown)) install.packages("blogdown")

#Ensure Hugo is installed
tryCatch(blogdown::hugo_version(), error=function(cond) blogdown::install_hugo())

#Start the Server to update files for 30 seconds and then stop the server
blogdown::serve_site()
# Sys.sleep(3)
# servr::daemon_stop()


