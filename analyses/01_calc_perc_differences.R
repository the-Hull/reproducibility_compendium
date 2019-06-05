
# Packages ----------------------------------------------------------------

library(dplyr)
library(tidyr)
library(ggplot2)


# # Load data ---------------------------------------------------------------
# 
# load("data/pop_data.rda")

# Data exploration --------------------------------------------------------

## Total population 2016 in million

pop_data %>% 
    filter(year == 2016) %>% 
    summarise_if(is.numeric, sum) 

## Population by Region

pop_data %>% 
    filter(year == 2016) %>% 
    group_by(region) %>% 
    summarise(mean_pop_mil = mean(population, na.rm = T),
              sum_pop_mil = sum(population, na.rm = T))

## 10 largest countries

pop_data %>% 
    dplyr::filter(year == 2016) %>%
    dplyr::arrange(desc(population)) %>% 
    dplyr::select(country_name, region, population)
head(10)

## 10 smallest countries

pop_data %>% 
    dplyr::filter(year == 2016) %>%
    dplyr::arrange(population) %>% 
    dplyr::select(country_name, region, population)
head(10)


## Percent change per region in last 10 years

region_change <- 
    pop_data %>% 
    filter(year == 2016 | year == 2006) %>% 
    group_by(region, year) %>% 
    summarise(sum_pop_mil = sum(population,na.rm = T))%>% 
    tidyr::spread(key = year, value = sum_pop_mil) %>% 
    mutate(perc_change = (`2016` - `2006`) / `2006`) %>% 
    arrange(perc_change)


## Percent change per country in last 10 years


country_change <- 
    pop_data %>% 
    filter(year == 2016 | year == 2006) %>% 
    group_by(country_name, year) %>% 
    summarise(sum_pop_mil = sum(population,na.rm = T)) %>% 
    tidyr::spread(key = year, value = sum_pop_mil) %>% 
    mutate(perc_change = ((`2016` - `2006`) / `2006`) * 100 )  %>% 
    mutate(change_fac = case_when(perc_change > 0 ~ "gain",
                                  perc_change < 0 ~ "loss",
                                  TRUE ~ "black")) %>% 
    arrange(perc_change) %>% 
    ungroup() %>% 
    left_join(pop_data %>% select(country_name, region), by = "country_name") %>% 
    distinct()


cols <- c("#ffb14e",
"#0000ff")


country_change %>% 
    ggplot(aes(x = reorder(country_name, region),
               y = perc_change,
               fill = region)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    theme_minimal()





country_change %>% 
    group_by(region) %>% 
    # arrange(perc_change, .by_group = T) %>% 
    ggplot(aes(x = reorder(country_name, -perc_change),
               y = perc_change,
               group = region, fill = change_fac)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    theme_minimal() +
    facet_wrap(~region, scales = "free_y")


country_change %>% 
    group_by(region) %>% 
    mutate(p_rank_top_5 = perc_change  %>% percent_rank()) %>% 
    filter(p_rank_top_5 <=  .25 | p_rank_top_5 >= .75) %>%
    ggplot(aes(x = reorder(country_name, -perc_change),
               y = perc_change,
               group = region, fill = change_fac)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    theme_minimal() +
    facet_wrap(~region, scales = "free_y") +
    xlab("Change (%)") +
    ylab("Country") +
    ggtitle("Country-level opulation change between 2006 and 2016",
            subtitle = "for most extreme change (top 25%) divided by World Regions") +
    labs(caption = "Source: World Bank, 2018")
    



extreme_change <- country_change %>% 
    group_by(region) %>% 
    mutate(p_rank_top_5 = perc_change  %>% percent_rank()) %>% 
    filter(p_rank_top_5 <=  .025 | p_rank_top_5 >= .975) 

pop_data[pop_data$country_name %in% extreme_change$country_name, ] %>% 
    ggplot(aes(x = as.numeric(year),
               y = population,
               color = country_name)) +
    # geom_bar(stat = "identity") +
    geom_rect(xmin = 2006, xmax = 2016, ymin = -Inf, ymax = Inf, fill = "gray90", col = NA, alpha = .1) +
    geom_line() +
    # coord_flip() +
    theme_minimal() +
    facet_grid(region~., scales = "free_y") +
    xlab("Change (%)") +
    ylab("Country") +
    ggtitle("Country-level opulation change between 2006 and 2016",
            subtitle = "for most extreme change (top 25%) divided by World Regions") +
    labs(caption = "Source: World Bank, 2018")
