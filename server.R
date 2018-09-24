# Data visualization for PhD careers and salaries using Shiny (server)

server <- function(input, output, session) {
  
  # First tab plots
  
  # Plot1: Degrees per year
  output$visualize_plot1 <- renderPlotly({
    
    docs_df_field_per_year <- docs_df_detailed_fields %>% filter(Field == input$Field)
    
    p <- ggplot(data = docs_df_field_per_year, aes(x=Year, y=Recipients)) + 
      geom_path(color="gray") +
      geom_point(color="steelblue") + 
      theme_minimal() 
    
    ggplotly(p)
    
  })
  
  # Plot2: Median salaries per sector
  output$visualize_plot2 <- renderPlotly({
    
    salaries_df_long_detailed_fields_specify <- salaries_df_long_detailed_fields %>% filter(Field == input$Field)
    
    p <- ggplot(data = salaries_df_long_detailed_fields_specify, aes(x=Sector, y=Salary, fill=Sector)) + 
      geom_bar(stat="identity", 
               aes(text=paste("Median salary:", Salary))) + 
      scale_fill_manual(values=c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FDAE61")) + 
      labs(x="Sector", y="Median salary") + 
      theme_minimal() + 
      theme(legend.position="none")
    
    ggplotly(p, tooltip="text")
    
    
  })
  
  # Plot3: Percent of doctorates going into each area
  output$visualize_plot3 <- renderPlotly({
    
    postgrad_commitments_df_long_detailed_fields_specify <- postgrad_commitments_df_long_detailed_fields %>% filter(Field == input$Field)
    
    p <- ggplot(data = postgrad_commitments_df_long_detailed_fields_specify, aes(x=Area, y=Percent_of_Doctorates, fill=Area)) + 
      geom_bar(stat="identity", 
               aes(text=paste("Number of doctorates:", Number_of_Doctorates, "<br>",
                              "Percent of doctorates:", Percent_of_Doctorates))) + 
      scale_fill_brewer(palette="Set2") + 
      labs(x="Area", y="Percent of doctorates") + 
      theme_minimal() +
      theme(legend.position="none") + 
      scale_x_discrete(breaks=c("USA_postdoctoral","USA_academic","USA_industry", "USA_other", "Abroad", "Unknown"),
                       labels=c("USA \n Postdoctoral", "USA \n Academic", "USA \n Industry", "USA \n Other", "Abroad", "Unknown"))
    
    ggplotly(p, tooltip="text")
    
  })
  
  # Second tab plots
  
  output$selected_choices_txt <- renderText({ 
    chosen_degree <- paste(input$SelectedVars, collapse="; ")
    paste(chosen_degree)}
  )
  
  observe({
    
    # Restrict maximum number of degrees to compare at a time to 6
    if(length(input$SelectedVars) > 6){
      updateCheckboxGroupInput(session, "SelectedVars", 
                               selected = tail(input$SelectedVars, 6))
    }
    
  }
  )
  
  # Plot1: Degrees per year (more than one input)
  output$compare_plot1 <- renderPlotly({
    
    docs_df_detailed_fields_specify <- docs_df_detailed_fields %>% filter(Field %in% c(input$SelectedVars))
    
    p <- ggplot(data = docs_df_detailed_fields_specify, aes(x=Year, y=Recipients, color=Field)) + 
      geom_line() +
      scale_color_manual(values=c("#D7191C", "#FDAE61", "#A6CEE3", "#ABDDA4", "#33A02C", "#2B83BA")) + 
      theme_minimal() 
    
    ggplotly(p)
    
  })
  
  # Plot2: Median salaries per sector (more than one input)
  output$compare_plot2 <- renderPlotly({
    
    salaries_df_long_detailed_fields_specify <- salaries_df_long_detailed_fields %>% filter(Field %in% c(input$SelectedVars))
    
    p <- ggplot(data = salaries_df_long_detailed_fields_specify, aes(x=Sector, y=Salary, fill=Field)) + 
      geom_bar(stat="identity") +  
      scale_fill_manual(values=c("#D7191C", "#FDAE61", "#A6CEE3", "#ABDDA4", "#33A02C", "#2B83BA")) + 
      theme_minimal() + 
      facet_wrap(~Field) +
      theme(axis.text.x = element_text(angle=90, hjust=1)) + 
      theme(axis.title.y=element_blank(),
            axis.title.x=element_blank(), 
            strip.background = element_blank(), #remove facet wrap label background
            strip.text.x = element_blank()) #remove facet wrap label text
    ggplotly(p)
  })
  
  # Plot3: Percent of doctorates going into each area (more than one input)
  output$compare_plot3 <- renderPlotly({
    
    postgrad_commitments_df_long_detailed_fields_specify <- postgrad_commitments_df_long_detailed_fields %>% filter(Field %in% c(input$SelectedVars))
    
    p <- ggplot(data = postgrad_commitments_df_long_detailed_fields_specify, aes(x=Area, y=Percent_of_Doctorates, fill=Field)) + 
      geom_bar(stat="identity", 
               aes(text=paste("Number:", Number_of_Doctorates))) + 
      scale_fill_manual(values=c("#D7191C", "#FDAE61", "#A6CEE3", "#ABDDA4", "#33A02C", "#2B83BA")) + 
      theme_minimal() + 
      facet_wrap(~Field) + 
      theme(axis.text.x = element_text(angle=90, hjust=1)) + 
      scale_x_discrete(breaks=c("USA_postdoctoral","USA_academic","USA_industry", "USA_other", "Abroad", "Unknown"),
                       labels=c("USA Postdoctoral", "USA Academic", "USA Industry", "USA Other", "Abroad", "Unknown")) + 
      theme(axis.title.y=element_blank(),
            axis.title.x=element_blank(), 
            strip.background = element_blank(), #remove facet wrap label background
            strip.text.x = element_blank()) #remove facet wrap label text
    
    ggplotly(p)
    
  })
  
}

