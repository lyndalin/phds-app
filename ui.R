# Data visualization for PhD careers and salaries using Shiny (ui)

ui <- dashboardPage(skin = "blue",
                    dashboardHeader(
                      title = "PhD Careers"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Visualize", tabName = "dashboard", icon = icon("eye")),
                        menuItem("Compare", tabName = "compare", icon = icon("signal")), 
                        menuItem("Notes", tabName = "notes", icon = icon("sticky-note")), 
                        menuItem("Source Code", icon = icon("file-code-o"), 
                                 href = "https://github.com/lyndalin/phds-app")
                      )
                    ),
                    dashboardBody(
                      tabItems(
                        # First tab content
                        tabItem(tabName = "dashboard",
                                fluidRow(
                                  box(
                                    title = "Choose PhD Degree",
                                    status="primary", 
                                    solidHeader = TRUE,
                                    selectInput("Field", "Field:", choices=unique(docs_df_detailed_fields$Field), selected="All fields")
                                  ), 
                                  box(
                                    title= "Number of PhD degrees over the years", 
                                    status = "warning", 
                                    solidHeader=TRUE,
                                    collapsible = TRUE,
                                    plotlyOutput("visualize_plot1", height = 300)
                                  ), 
                                  box(
                                    title = "Median salary per sector (2016)", 
                                    status = "success",
                                    solidHeader = TRUE,
                                    collapsible = TRUE,
                                    plotlyOutput("visualize_plot2", height = 300)
                                  ), 
                                  box(
                                    title = "Percentage of graduates going into each area (2016)", 
                                    status = "danger", 
                                    solidHeader = TRUE,
                                    collapsible = TRUE,
                                    plotlyOutput("visualize_plot3", height = 300)
                                  ) 
                                )
                        ),
                        
                        # Second tab content
                        tabItem(tabName = "compare",
                                h2("Compare across degrees"), 
                                h3("NOTE: You can only compare 6 degrees at a time"), 
                                
                                fluidRow(
                                  column(width=3,
                                         checkboxGroupInput("SelectedVars", "Degree:", choices=unique(docs_df_detailed_fields$Field), selected = "All fields"), 
                                         hr(),
                                         p(strong("You selected:")), 
                                         textOutput("selected_choices_txt")
                                  ), 
                                  column(width=9, 
                                         box(
                                           title= "Number of PhD degrees over the years", 
                                           status = "warning", 
                                           width=12, 
                                           solidHeader=TRUE,
                                           collapsible = TRUE, 
                                           plotlyOutput("compare_plot1") 
                                         ), 
                                         box(
                                           title = "Median salary per sector (2016)", 
                                           status = "success",
                                           width=12, 
                                           solidHeader = TRUE,
                                           collapsible = TRUE, 
                                           plotlyOutput("compare_plot2")
                                         ), 
                                         box(
                                           title = "Percentage of graduates going into each area (2016)", 
                                           status = "danger", 
                                           width = 12,
                                           solidHeader = TRUE,
                                           collapsible = TRUE, 
                                           plotlyOutput("compare_plot3") 
                                         )
                                  )
                                )

                        ), 
                        
                        # Third tab content
                        tabItem(tabName = "notes",
                                h2("Notes about data visualization"), 
                                tags$ul(
                                  tags$li("Data were obtained from the", a(href="https://www.nsf.gov/statistics/srvydoctorates/", "Survey of Earned Doctorates (SED).")), 
                                  tags$li("The plots for median salaries are approximations for some of the fields. This is because the SED survey reported detailed fields for number of doctorates earned over the years but broader fields for the salaries. For example, there were 1147 History PhD recipients in 2016 but the salaries dataset does not contain salary information for History PhDs specifically. Rather, it combines salaries information for ALL Humanities and Arts, including History, Letters, Foreign Languages and literature, etc. So the median salaries for History in the plots was approximated from the reported salaries for all Humanities and Arts PhDs."), 
                                  tags$li("The plots for percent of graduates going into each area is out of everyone who reported definite postgraduate commitments. Since not everyone reported their postgraduate commitments, the numbers (N) don't match those in the plot for total number of PhDs - for a specific field - received in 2016."), 
                                  tags$li("In addition, similar to the median salaries plots, the percent of graduates going into each area had further approximations due to the reporting of different fields in the dataset for earned doctorates over the years and that for postgraduate commitments (though the fields in the postgraduate commitments dataset were more detailed than the ones in the salaries dataset, resulting in less approximations of this kind when compared to the salaries dataset)."), 
                                  tags$li("Certain information was not available in the postgraduate commitments dataset and thus some plots won't show. This mainly affects the following fields: Teacher education and Other education. Other fields, such as Foreign languages and literature and Health Sciences, were missing information for number of doctorates going into specific areas in the USA or Abroad so parts of those plots will be msising as well.")
                                )
                        )
                      )
                    )
)
