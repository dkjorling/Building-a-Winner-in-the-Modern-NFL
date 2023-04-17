url <- "https://www.spotrac.com/nfl/arizona-cardinals/draft/2000-2022/")
h1 <- read_html(url)
tab1 <- h1 %>% html_nodes("table")        
tab1 <- tab1[[8]] %>% html_table
