DR<-"C:/Users/cody8/OneDrive/Documentos/Lib/Finder"

# Copy installation scripts (JavaScript, icons, infobefore.txt, package_manager.R, launch_app.R)
copy_installation(app_dir = DR)

# If your users need R installed:
get_R(app_dir = DR, R_version = "2.2.1")

# Create batch file
create_bat(app_name = "Finder1", app_dir = DR)

# Create app config file
create_config(app_name = "Finder1", app_dir = DR,
              pkgs = c("jsonlite", "shiny", "magrittr", "dplyr", "caret", "xkcd",
                       "purrr","assertthat","readr","textreadr"))

# Build the iss script
start_iss(app_name = "Finder1") %>%
  
  # C-like directives
  directives_section(R_version   = "2.2.1", 
                     include_R   = TRUE,
                     app_version = "0.1.2",
                     publisher   = "JCV", 
                     main_url    = "yourcompany.com") %>%
  
  # Setup Section
  setup_section(output_dir  = "wizard", 
                app_version = "0.1.2",
                default_dir = "pf", 
                privilege   = "high",
                inst_readme = "pre-install instructions.txt", 
                setup_icon  = "myicon.ico",
                pub_url     = "https://jcval94.shinyapps.io/ilight/", 
                sup_url     = "github.com/jcval94/Finder/issues",
                upd_url     = "github.com/jcval94") %>%
  
  # Languages Section
  languages_section() %>%
  
  # Tasks Section
  tasks_section(desktop_icon = FALSE) %>%
  
  # Files Section
  files_section(app_dir = DR, file_list = "path/to/extra/files") %>%
  
  # Icons Section
  icons_section(app_desc       = "This is my local shiny app",
                app_icon       = "notdefault.ico",
                prog_menu_icon = FALSE,
                desktop_icon   = FALSE) %>%
  
  # Execution & Pascal code to check registry during installation
  # If the user has R, don't give them an extra copy
  # If the user needs R, give it to them
  run_section() %>%
  code_section() %>%
  
  # Write the Inno Setup script
  writeLines(file.path(DR, "My AppName.iss"))

# Check your files, then
compile_iss()
