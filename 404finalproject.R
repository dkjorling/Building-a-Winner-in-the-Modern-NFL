# load required libraries
library(tidyverse)
library(rvest)
library(stringr)
library(zoo)


# Load Win% data
win_pct <- read.csv("winpct.csv")

# Load FA Spend data
fa_spend <- read.csv("fa_spend.csv")


# Load Raw Age Data
age_1 <- read.csv("team_age_13_16.csv")
age_2 <- read.csv("team_age_17_21.csv")

# Load Raw Draft Data
draft_hist <- read.csv("draft_history.csv")
dv_chart <- read.csv("dv_chart.csv" )

# Data Scraping for positional/total spending 

urls_21 <- c("https://www.spotrac.com/nfl/arizona-cardinals/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/atlanta-falcons/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/baltimore-ravens/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/buffalo-bills/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/carolina-panthers/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/chicago-bears/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/cincinnati-bengals/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/cleveland-browns/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/dallas-cowboys/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/denver-broncos/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/detroit-lions/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/green-bay-packers/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/houston-texans/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/indianapolis-colts/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/jacksonville-jaguars/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/kansas-city-chiefs/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/las-vegas-raiders/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/los-angeles-chargers/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/los-angeles-rams/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/miami-dolphins/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/minnesota-vikings/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/new-england-patriots/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/new-orleans-saints/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/new-york-giants/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/new-york-jets/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/philadelphia-eagles/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/pittsburgh-steelers/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/san-francisco-49ers/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/seattle-seahawks/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/tampa-bay-buccaneers/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/tennessee-titans/positional/2021/full-cap/",
          "https://www.spotrac.com/nfl/washington-football-team/positional/2021/full-cap/")

urls_20 <- c("https://www.spotrac.com/nfl/arizona-cardinals/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/atlanta-falcons/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/baltimore-ravens/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/buffalo-bills/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/carolina-panthers/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/chicago-bears/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/cincinnati-bengals/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/cleveland-browns/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/dallas-cowboys/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/denver-broncos/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/detroit-lions/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/green-bay-packers/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/houston-texans/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/indianapolis-colts/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/jacksonville-jaguars/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/kansas-city-chiefs/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/las-vegas-raiders/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/los-angeles-chargers/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/los-angeles-rams/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/miami-dolphins/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/minnesota-vikings/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/new-england-patriots/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/new-orleans-saints/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/new-york-giants/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/new-york-jets/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/philadelphia-eagles/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/pittsburgh-steelers/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/san-francisco-49ers/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/seattle-seahawks/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/tampa-bay-buccaneers/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/tennessee-titans/positional/2020/full-cap/",
             "https://www.spotrac.com/nfl/washington-football-team/positional/2020/full-cap/")

urls_19 <- c("https://www.spotrac.com/nfl/arizona-cardinals/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/atlanta-falcons/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/baltimore-ravens/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/buffalo-bills/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/carolina-panthers/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/chicago-bears/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/cincinnati-bengals/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/cleveland-browns/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/dallas-cowboys/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/denver-broncos/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/detroit-lions/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/green-bay-packers/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/houston-texans/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/indianapolis-colts/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/jacksonville-jaguars/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/kansas-city-chiefs/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/oakland-raiders/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/los-angeles-chargers/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/los-angeles-rams/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/miami-dolphins/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/minnesota-vikings/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/new-england-patriots/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/new-orleans-saints/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/new-york-giants/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/new-york-jets/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/philadelphia-eagles/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/pittsburgh-steelers/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/san-francisco-49ers/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/seattle-seahawks/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/tampa-bay-buccaneers/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/tennessee-titans/positional/2019/full-cap/",
             "https://www.spotrac.com/nfl/washington-redskins/positional/2019/full-cap/")

urls_18 <- c("https://www.spotrac.com/nfl/arizona-cardinals/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/atlanta-falcons/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/baltimore-ravens/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/buffalo-bills/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/carolina-panthers/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/chicago-bears/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/cincinnati-bengals/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/cleveland-browns/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/dallas-cowboys/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/denver-broncos/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/detroit-lions/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/green-bay-packers/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/houston-texans/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/indianapolis-colts/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/jacksonville-jaguars/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/kansas-city-chiefs/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/oakland-raiders/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/los-angeles-chargers/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/los-angeles-rams/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/miami-dolphins/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/minnesota-vikings/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/new-england-patriots/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/new-orleans-saints/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/new-york-giants/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/new-york-jets/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/philadelphia-eagles/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/pittsburgh-steelers/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/san-francisco-49ers/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/seattle-seahawks/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/tampa-bay-buccaneers/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/tennessee-titans/positional/2018/full-cap/",
             "https://www.spotrac.com/nfl/washington-redskins/positional/2018/full-cap/")

urls_17 <- c("https://www.spotrac.com/nfl/arizona-cardinals/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/atlanta-falcons/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/baltimore-ravens/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/buffalo-bills/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/carolina-panthers/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/chicago-bears/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/cincinnati-bengals/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/cleveland-browns/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/dallas-cowboys/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/denver-broncos/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/detroit-lions/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/green-bay-packers/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/houston-texans/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/indianapolis-colts/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/jacksonville-jaguars/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/kansas-city-chiefs/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/oakland-raiders/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/los-angeles-chargers/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/los-angeles-rams/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/miami-dolphins/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/minnesota-vikings/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/new-england-patriots/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/new-orleans-saints/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/new-york-giants/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/new-york-jets/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/philadelphia-eagles/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/pittsburgh-steelers/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/san-francisco-49ers/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/seattle-seahawks/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/tampa-bay-buccaneers/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/tennessee-titans/positional/2017/full-cap/",
             "https://www.spotrac.com/nfl/washington-redskins/positional/2017/full-cap/")

urls_16 <- c("https://www.spotrac.com/nfl/arizona-cardinals/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/atlanta-falcons/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/baltimore-ravens/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/buffalo-bills/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/carolina-panthers/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/chicago-bears/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/cincinnati-bengals/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/cleveland-browns/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/dallas-cowboys/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/denver-broncos/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/detroit-lions/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/green-bay-packers/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/houston-texans/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/indianapolis-colts/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/jacksonville-jaguars/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/kansas-city-chiefs/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/oakland-raiders/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/san-diego-chargers/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/los-angeles-rams/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/miami-dolphins/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/minnesota-vikings/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/new-england-patriots/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/new-orleans-saints/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/new-york-giants/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/new-york-jets/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/philadelphia-eagles/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/pittsburgh-steelers/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/san-francisco-49ers/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/seattle-seahawks/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/tampa-bay-buccaneers/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/tennessee-titans/positional/2016/full-cap/",
             "https://www.spotrac.com/nfl/washington-redskins/positional/2016/full-cap/")

urls_15 <- c("https://www.spotrac.com/nfl/arizona-cardinals/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/atlanta-falcons/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/baltimore-ravens/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/buffalo-bills/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/carolina-panthers/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/chicago-bears/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/cincinnati-bengals/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/cleveland-browns/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/dallas-cowboys/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/denver-broncos/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/detroit-lions/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/green-bay-packers/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/houston-texans/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/indianapolis-colts/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/jacksonville-jaguars/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/kansas-city-chiefs/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/oakland-raiders/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/san-diego-chargers/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/st-louis-rams/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/miami-dolphins/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/minnesota-vikings/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/new-england-patriots/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/new-orleans-saints/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/new-york-giants/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/new-york-jets/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/philadelphia-eagles/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/pittsburgh-steelers/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/san-francisco-49ers/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/seattle-seahawks/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/tampa-bay-buccaneers/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/tennessee-titans/positional/2015/full-cap/",
             "https://www.spotrac.com/nfl/washington-redskins/positional/2015/full-cap/")

urls_14 <- c("https://www.spotrac.com/nfl/arizona-cardinals/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/atlanta-falcons/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/baltimore-ravens/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/buffalo-bills/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/carolina-panthers/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/chicago-bears/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/cincinnati-bengals/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/cleveland-browns/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/dallas-cowboys/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/denver-broncos/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/detroit-lions/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/green-bay-packers/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/houston-texans/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/indianapolis-colts/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/jacksonville-jaguars/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/kansas-city-chiefs/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/oakland-raiders/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/san-diego-chargers/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/st-louis-rams/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/miami-dolphins/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/minnesota-vikings/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/new-england-patriots/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/new-orleans-saints/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/new-york-giants/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/new-york-jets/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/philadelphia-eagles/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/pittsburgh-steelers/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/san-francisco-49ers/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/seattle-seahawks/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/tampa-bay-buccaneers/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/tennessee-titans/positional/2014/full-cap/",
             "https://www.spotrac.com/nfl/washington-redskins/positional/2014/full-cap/")

urls_13 <- c("https://www.spotrac.com/nfl/arizona-cardinals/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/atlanta-falcons/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/baltimore-ravens/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/buffalo-bills/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/carolina-panthers/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/chicago-bears/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/cincinnati-bengals/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/cleveland-browns/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/dallas-cowboys/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/denver-broncos/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/detroit-lions/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/green-bay-packers/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/houston-texans/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/indianapolis-colts/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/jacksonville-jaguars/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/kansas-city-chiefs/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/oakland-raiders/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/san-diego-chargers/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/st-louis-rams/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/miami-dolphins/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/minnesota-vikings/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/new-england-patriots/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/new-orleans-saints/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/new-york-giants/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/new-york-jets/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/philadelphia-eagles/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/pittsburgh-steelers/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/san-francisco-49ers/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/seattle-seahawks/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/tampa-bay-buccaneers/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/tennessee-titans/positional/2013/full-cap/",
             "https://www.spotrac.com/nfl/washington-redskins/positional/2013/full-cap/")

# store each tibble in a list
list21 <- vector(mode = "list", length = 32)
for(i in 1:32){
        h <- read_html(urls_21[i])
        tab <- h %>% html_nodes("table")        
        tab <- tab[[2]] %>% html_table
        list21[[i]] <- tab
}

list20 <- vector(mode = "list", length = 32)
for(i in 1:32){
        h <- read_html(urls_20[i])
        tab <- h %>% html_nodes("table")        
        tab <- tab[[2]] %>% html_table
        list20[[i]] <- tab
}

list19 <- vector(mode = "list", length = 32)
for(i in 1:32){
        h <- read_html(urls_19[i])
        tab <- h %>% html_nodes("table")        
        tab <- tab[[2]] %>% html_table
        list19[[i]] <- tab
}

# for data behind login sign into site and continue scraping
login <- "https://www.spotrac.com/signin/submit"
session <-html_session(login)
form <- html_form(session)[[4]]  #in this case the submit is the 2nd form
filled_form <- set_values(form, email="dkjorling@gmail.com", 
                          password="password1")

list18 <- vector(mode = "list", length = 32)
for(i in 1:32){
        tab <- submit_form(session, filled_form) %>%
                session_jump_to(urls_18[i]) %>% html_nodes("table")
        list18[[i]] <- tab[[2]] %>% html_table
}

list17 <- vector(mode = "list", length = 32)
for(i in 1:32){
        tab <- submit_form(session, filled_form) %>%
                session_jump_to(urls_17[i]) %>% html_nodes("table")
        list17[[i]] <- tab[[2]] %>% html_table
}

list16 <- vector(mode = "list", length = 32)
for(i in 1:32){
        tab <- submit_form(session, filled_form) %>%
                session_jump_to(urls_16[i]) %>% html_nodes("table")
        list16[[i]] <- tab[[2]] %>% html_table
}

list15 <- vector(mode = "list", length = 32)
for(i in 1:32){
        tab <- submit_form(session, filled_form) %>%
                session_jump_to(urls_15[i]) %>% html_nodes("table")
        list15[[i]] <- tab[[2]] %>% html_table
}

list14 <- vector(mode = "list", length = 32)
for(i in 1:32){
        tab <- submit_form(session, filled_form) %>%
                session_jump_to(urls_14[i]) %>% html_nodes("table")
        list14[[i]] <- tab[[2]] %>% html_table
}

list13 <- vector(mode = "list", length = 32)
for(i in 1:32){
        tab <- submit_form(session, filled_form) %>%
                session_jump_to(urls_13[i]) %>% html_nodes("table")
        list13[[i]] <- tab[[2]] %>% html_table
}


# Data Cleaning        
# take positional spending from tibble list and store in a df
df_21 <- data.frame(matrix(ncol = 9, nrow = 32))
for(i in 1:32){
        for(j in 1:9){
                df_21[i, j] <- list21[[i]][j,3]
        }
}

df_20 <- data.frame(matrix(ncol = 9, nrow = 32))
for(i in 1:32){
        for(j in 1:9){
                df_20[i, j] <- list20[[i]][j,3]
        }
}

df_19 <- data.frame(matrix(ncol = 9, nrow = 32))
for(i in 1:32){
        for(j in 1:9){
                df_19[i, j] <- list19[[i]][j,3]
        }
}

df_18 <- data.frame(matrix(ncol = 9, nrow = 32))
for(i in 1:32){
        for(j in 1:9){
                df_18[i, j] <- list18[[i]][j,3]
        }
}

df_17 <- data.frame(matrix(ncol = 9, nrow = 32))
for(i in 1:32){
        for(j in 1:9){
                df_17[i, j] <- list17[[i]][j,3]
        }
}

df_16 <- data.frame(matrix(ncol = 9, nrow = 32))
for(i in 1:32){
        for(j in 1:9){
                df_16[i, j] <- list16[[i]][j,3]
        }
}

df_15 <- data.frame(matrix(ncol = 9, nrow = 32))
for(i in 1:32){
        for(j in 1:9){
                df_15[i, j] <- list15[[i]][j,3]
        }
}

df_14 <- data.frame(matrix(ncol = 9, nrow = 32))
for(i in 1:32){
        for(j in 1:9){
                df_14[i, j] <- list14[[i]][j,3]
        }
}

df_13 <- data.frame(matrix(ncol = 9, nrow = 32))
for(i in 1:32){
        for(j in 1:9){
                df_13[i, j] <- list13[[i]][j,3]
        }
}

df <- rbind(df_21, df_20, df_19, df_18, df_17, df_16, df_15, df_14, df_13)


# create team_labels and year list and add to df
teams <- c("ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE", "DAL", 
           "DEN", "DET", "GB", "HOU", "IND", "JAC", "KC", "LV_OAK", "LAC",
           "LAR", "MIA", "MIN", "NE", "NO", "NYG", "NYJ", "PHI", "PIT", "SF",
           "SEA", "TB", "TEN", "WAS")
years <- c(rep(2021, 32), rep(2020, 32), rep(2019, 32), rep(2018, 32), rep(2017, 32),
           rep(2016, 32), rep(2015, 32), rep(2014, 32), rep(2013, 32))

df <- data.frame(years, rep(teams, 9), df)

colnames(df) <- c("year", "team", "qb_spend", "rb_spend", "wr_spend", "te_spend",
                  "ol_spend", "dl_spend", "lb_spend", "sec_spend", "st_spend")


# remove commas, $ and coerce to numerical
df <- as_tibble(df)
df_clean <- df %>% mutate_at(3:11, parse_number)  
df_clean <- as.data.frame(df_clean)

# add variables: total spend, normalize spend and % spend for each
df_clean <- df_clean %>% mutate(total_spend = qb_spend + rb_spend + wr_spend +
                                        te_spend+ ol_spend + dl_spend + lb_spend + sec_spend + 
                                        st_spend)
df_clean <- df_clean %>% mutate(qb_cap_share = qb_spend/ total_spend, 
                                rb_cap_share = rb_spend/ total_spend,
                                wr_cap_share = wr_spend/ total_spend,
                                te_cap_share = te_spend/ total_spend,
                                ol_cap_share = ol_spend/ total_spend,
                                dl_cap_share = dl_spend/ total_spend,
                                lb_cap_share = lb_spend/ total_spend,
                                sec_cap_share = sec_spend/ total_spend,
                                st_cap_share = st_spend/ total_spend)

# Add win pct and playoff points to df
df_clean <- data.frame(df_clean[, 1:2], win_pct[, 3:4], df_clean[, 3:21])

# normalize total spend by year
x <- df_clean %>% group_by(year) %>% 
        summarize(mean(total_spend))
x <- x %>% mutate(year_mult = x$`mean(total_spend)`[9] 
             / x$`mean(total_spend)`)
year_mult <- x$year_mult                                
year_mult <- c(rep(year_mult, each = 32))
year_mult <- rev(year_mult)

df_clean <- data.frame(df_clean, year_mult)                                
df_clean <- df_clean %>% mutate(norm_total_spend = total_spend * year_mult)  


# normalize fa spend 
y <- fa_spend %>% group_by(year) %>% 
        summarize(mean(fa_spend))
y <- y %>% mutate(year_mult = y$`mean(fa_spend)`[9] 
                  / y$`mean(fa_spend)`)
year_mult1 <- y$year_mult                                
year_mult1 <- c(rep(year_mult, each = 32))
year_mult1 <- rev(year_mult)

fa_spend <- data.frame(fa_spend, year_mult)                                
fa_spend<- fa_spend %>% mutate(norm_fa_spend = fa_spend * year_mult)

# rank intra-year extended spend
fa_spend$extended_spend <- as.numeric(fa_spend$extended_spend)

r1 <- rank(-fa_spend$extended_spend[1:32], ties.method = "random")
r2 <- rank(-fa_spend$extended_spend[33:64], ties.method = "random")
r3 <- rank(-fa_spend$extended_spend[65:96], ties.method = "random")
r4 <- rank(-fa_spend$extended_spend[97:128], ties.method = "random")
r5 <- rank(-fa_spend$extended_spend[129:160], ties.method = "random")
r6 <- rank(-fa_spend$extended_spend[161:192], ties.method = "random")
r7 <- rank(-fa_spend$extended_spend[193:224], ties.method = "random")
r8 <- rank(-fa_spend$extended_spend[225:256], ties.method = "random")
r9 <- rank(-fa_spend$extended_spend[257:288], ties.method = "random")

ext_spend_rank <- c(r1, r2, r3, r4, r5, r6, r7, r8, r9)
fa_spend <- data.frame(fa_spend, ext_spend_rank)

# keep only columns that may be useful and join fa_spend with cleaned df
fa_spend <- data.frame(fa_spend[, 1:2], fa_spend[, 5:8],
                       fa_spend[, 12:13], fa_spend[, 16:17])

df_clean <- left_join(df_clean, fa_spend)

# clean age data and add to df
raw_age <- left_join(age_2, age_1)
raw_age <- as_tibble(raw_age)                               
class(raw_age)  
colnames(raw_age) <- c("team", 2021, 2020, 2019, 2018, 2017, 2016,
                       2015, 2014, 2013)

# remove parentheses and text within and coerce to numeric
raw_age$`2021` <- str_replace_all(raw_age$`2021`, "\\(.+?\\)", "")
raw_age$`2020` <- str_replace_all(raw_age$`2020`, "\\(.+?\\)", "")
raw_age$`2019` <- str_replace_all(raw_age$`2019`, "\\(.+?\\)", "")
raw_age$`2018` <- str_replace_all(raw_age$`2018`, "\\(.+?\\)", "")
raw_age$`2017` <- str_replace_all(raw_age$`2017`, "\\(.+?\\)", "")
raw_age$`2016` <- str_replace_all(raw_age$`2016`, "\\(.+?\\)", "")
raw_age$`2015` <- str_replace_all(raw_age$`2015`, "\\(.+?\\)", "")
raw_age$`2014` <- str_replace_all(raw_age$`2014`, "\\(.+?\\)", "")
raw_age$`2013` <- str_replace_all(raw_age$`2013`, "\\(.+?\\)", "")

raw_age <- as.data.frame(raw_age)
for(i in 2:10){
        raw_age[, i] <- as.numeric(raw_age[, i])
}

# reformat team name
raw_age$team <- c("NYJ", "DET", "CLE", "CAR", "JAC", "LAR", "NYG", "IND",
                  "DAL", "CIN", "PIT", "MIN", "DEN", "MIA", "GB", "LV_OAK",
                  "LAC", "BAL", "PHI", "ATL", "WAS", "NO", "KC", "BUF",
                  "TEN", "SEA", "SF", "NE", "ARI", "TB", "HOU", "CHI")

# reformat age df and join w/ df_clean
base_df <- data.frame(years, rep(raw_age$team, 9))
avg_age <- as.matrix(raw_age[, 2:10])
avg_age <- c(avg_age)
age <- data.frame(base_df, avg_age)
colnames(age) <- c("year", "team", "avg_age")

df_clean <- left_join(df_clean, age)

#save cleaned df
write.csv(df_clean, "/Users/dylanjorling/UCLA/404\\404df.csv")

# clean draft data
draft_hist <- read.csv("draft_history.csv")
dv_chart <- read.csv("dv_chart.csv" )
draft_hist <- filter(draft_hist, year > 2009)
draft_hist <- left_join(draft_hist, dv_chart)

draft_hist$pos[draft_hist$pos %in% c("LB", "OLB", "ILB")] <- "lb"
draft_hist$pos[draft_hist$pos %in% c("S", "FS", "SS", "CB")] <- "sec"
draft_hist$pos[draft_hist$pos %in% c("C", "T", "G", "LT", "RT", "OL")] <- "ol"
draft_hist$pos[draft_hist$pos %in% c("DT", "DE")] <- "dl"
draft_hist$pos[draft_hist$pos %in% c("RB", "FB")] <- "rb"
draft_hist$pos[draft_hist$pos %in% c("K", "P", "LS")] <- "st"
draft_hist$pos <- tolower(draft_hist$pos)

qb_alloc <- rep(NA, 3054)
rb_alloc <- rep(NA, 3054)
wr_alloc <- rep(NA, 3054)
te_alloc <- rep(NA, 3054)
ol_alloc <- rep(NA, 3054)
dl_alloc <- rep(NA, 3054)
lb_alloc <- rep(NA, 3054)
sec_alloc <- rep(NA, 3054)
st_alloc <- rep(NA, 3054)
for(i in 1:3054){
        if(draft_hist[i, 3] == "qb"){
                qb_alloc[i] = draft_hist[i, 8]
        }
        else{
                qb_alloc[i] = 0
        }

}
for(i in 1:3054){
        if(draft_hist[i, 3] == "rb"){
                rb_alloc[i] = draft_hist[i, 8]
        }
        else{
                rb_alloc[i] = 0
        }
}
for(i in 1:3054){
        if(draft_hist[i, 3] == "wr"){
                wr_alloc[i] = draft_hist[i, 8]
        }
        else{
                wr_alloc[i] = 0
        }
}
for(i in 1:3054){
        if(draft_hist[i, 3] == "te"){
                te_alloc[i] = draft_hist[i, 8]
        }
        else{
                te_alloc[i] = 0
        }
}
for(i in 1:3054){
        if(draft_hist[i, 3] == "ol"){
                ol_alloc[i] = draft_hist[i, 8]
        }
        else{
                ol_alloc[i] = 0
        }
}
for(i in 1:3054){
        if(draft_hist[i, 3] == "dl"){
                dl_alloc[i] = draft_hist[i, 8]
        }
        else{
                dl_alloc[i] = 0
        }
}
for(i in 1:3054){
        if(draft_hist[i, 3] == "lb"){
                lb_alloc[i] = draft_hist[i, 8]
        }
        else{
                lb_alloc[i] = 0
        }
}
for(i in 1:3054){
        if(draft_hist[i, 3] == "sec"){
                sec_alloc[i] = draft_hist[i, 8]
        }
        else{
                sec_alloc[i] = 0
        }
}
for(i in 1:3054){
        if(draft_hist[i, 3] == "st"){
                st_alloc[i] = draft_hist[i, 8]
        }
        else{
                st_alloc[i] = 0
        }
}

alloc_df <- data.frame(qb_alloc, rb_alloc, wr_alloc, te_alloc, ol_alloc,
                       dl_alloc, lb_alloc, sec_alloc, st_alloc)
draft_hist <- data.frame(draft_hist, alloc_df)

#create grouped draft history df

x1 <- draft_hist %>% group_by(team, year) %>% 
        summarise(team_draft_val = sum(value))
x2 <- draft_hist %>% group_by(team, year) %>% 
        summarise(qb_alloc = sum(qb_alloc),
                  rb_alloc = sum(rb_alloc),
                  wr_alloc = sum(wr_alloc),
                  te_alloc = sum(te_alloc),
                  ol_alloc = sum(ol_alloc),
                  dl_alloc = sum(dl_alloc),
                  lb_alloc = sum(lb_alloc),
                  sec_alloc = sum(sec_alloc),
                  st_alloc = sum(st_alloc))
grouped_dh <- left_join(x1, x2)

# create rolling average data frame of draft capital spent by position group

y1 <- filter(grouped_dh, team== "ARI")
y2 <- filter(grouped_dh, team== "ATL")
y3 <- filter(grouped_dh, team== "BAL")
y4 <- filter(grouped_dh, team== "BUF")
y5 <- filter(grouped_dh, team== "CAR")
y6 <- filter(grouped_dh, team== "CHI")
y7 <- filter(grouped_dh, team== "CIN")
y8 <- filter(grouped_dh, team== "CLE")
y9 <- filter(grouped_dh, team== "DAL")
y10 <- filter(grouped_dh, team== "DEN")
y11 <- filter(grouped_dh, team== "DET")
y12 <- filter(grouped_dh, team== "GB")
y13 <- filter(grouped_dh, team== "HOU")
y14 <- filter(grouped_dh, team== "IND")
y15 <- filter(grouped_dh, team== "JAC")
y16 <- filter(grouped_dh, team== "KC")
y17 <- filter(grouped_dh, team== "LV_OAK")
y18 <- filter(grouped_dh, team== "LAC")
y19 <- filter(grouped_dh, team== "LAR")
y20 <- filter(grouped_dh, team== "MIA")
y21 <- filter(grouped_dh, team== "MIN")
y22 <- filter(grouped_dh, team== "MIN")
y23 <- filter(grouped_dh, team== "NE")
y24 <- filter(grouped_dh, team== "NO")
y25 <- filter(grouped_dh, team== "NYG")
y26 <- filter(grouped_dh, team== "NYJ")
y27 <- filter(grouped_dh, team== "PHI")
y28 <- filter(grouped_dh, team== "SF")
y29 <- filter(grouped_dh, team== "SEA")
y30 <- filter(grouped_dh, team== "TB")
y31 <- filter(grouped_dh, team== "TEN")
y32 <- filter(grouped_dh, team== "WAS")

y_list <- list(y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, 
               y13, y14, y15, y16, y17, y18, y19, y20, y21, y22, 
               y23, y24, y25, y26, y27, y28, y29, y30, y31, y32)

roll_ttl_alloc <- vector(mode = "list", length = 32)
for(i in 1:32){
        roll_ttl_alloc[[i]] <- rollmean(y_list[[i]]$team_draft_val, 4, align = "right")
}
roll_ttl_alloc <- unlist(roll_ttl_alloc)
roll_ttl_alloc[roll_ttl_alloc<0] <- 0

roll_qb_alloc <- vector(mode = "list", length = 32)
for(i in 1:32){
        roll_qb_alloc[[i]] <- rollmean(y_list[[i]]$qb_alloc, 4, align = "right")
}
roll_qb_alloc <- unlist(roll_qb_alloc)
roll_qb_alloc[roll_qb_alloc<0] <- 0

roll_rb_alloc <- vector(mode = "list", length = 32)
for(i in 1:32){
        roll_rb_alloc[[i]] <- rollmean(y_list[[i]]$rb_alloc, 4, align = "right")
}
roll_rb_alloc <- unlist(roll_rb_alloc)
roll_rb_alloc[roll_rb_alloc<0] <- 0

roll_wr_alloc <- vector(mode = "list", length = 32)
for(i in 1:32){
        roll_wr_alloc[[i]] <- rollmean(y_list[[i]]$wr_alloc, 4, align = "right")
}
roll_wr_alloc <- unlist(roll_wr_alloc)
roll_wr_alloc[roll_wr_alloc<0] <- 0

roll_te_alloc <- vector(mode = "list", length = 32)
for(i in 1:32){
        roll_te_alloc[[i]] <- rollmean(y_list[[i]]$te_alloc, 4, align = "right")
}
roll_te_alloc <- unlist(roll_te_alloc)
roll_te_alloc[roll_te_alloc<0] <- 0

roll_ol_alloc <- vector(mode = "list", length = 32)
for(i in 1:32){
        roll_ol_alloc[[i]] <- rollmean(y_list[[i]]$ol_alloc, 4, align = "right")
}
roll_ol_alloc <- unlist(roll_ol_alloc)
roll_ol_alloc[roll_ol_alloc<0] <- 0

roll_dl_alloc <- vector(mode = "list", length = 32)
for(i in 1:32){
        roll_dl_alloc[[i]] <- rollmean(y_list[[i]]$dl_alloc, 4, align = "right")
}
roll_dl_alloc <- unlist(roll_dl_alloc)
roll_dl_alloc[roll_dl_alloc<0] <- 0

roll_lb_alloc <- vector(mode = "list", length = 32)
for(i in 1:32){
        roll_lb_alloc[[i]] <- rollmean(y_list[[i]]$lb_alloc, 4, align = "right")
}
roll_lb_alloc <- unlist(roll_lb_alloc)
roll_lb_alloc[roll_lb_alloc<0] <- 0

roll_sec_alloc <- vector(mode = "list", length = 32)
for(i in 1:32){
        roll_sec_alloc[[i]] <- rollmean(y_list[[i]]$sec_alloc, 4, align = "right")
}
roll_sec_alloc <- unlist(roll_sec_alloc)
roll_sec_alloc[roll_sec_alloc<0] <- 0

roll_st_alloc <- vector(mode = "list", length = 32)
for(i in 1:32){
        roll_st_alloc[[i]] <- rollmean(y_list[[i]]$st_alloc, 4, align = "right")
}
roll_st_alloc <- unlist(roll_st_alloc)
roll_st_alloc[roll_st_alloc<0] <- 0

roll_df <- data.frame(roll_ttl_alloc, roll_qb_alloc, roll_rb_alloc, roll_wr_alloc, 
                      roll_te_alloc, roll_ol_alloc, roll_dl_alloc, roll_lb_alloc, 
                      roll_sec_alloc, roll_st_alloc)

# combine rolling average df with grouped df
grouped_dh <- grouped_dh %>% filter(year > 2012)
new_dh_df <- data.frame(grouped_dh, roll_df)

#add rolling percent allocation variables
new_dh_df <- new_dh_df %>% mutate(qb_pa = roll_qb_alloc / roll_ttl_alloc,
                                  rb_pa = roll_rb_alloc / roll_ttl_alloc,
                                  wr_pa = roll_wr_alloc / roll_ttl_alloc,
                                  te_pa = roll_te_alloc / roll_ttl_alloc,
                                  ol_pa = roll_ol_alloc / roll_ttl_alloc,
                                  dl_pa = roll_dl_alloc / roll_ttl_alloc,
                                  lb_pa = roll_lb_alloc / roll_ttl_alloc,
                                  sec_pa = roll_sec_alloc / roll_ttl_alloc,
                                  st_pa = roll_st_alloc / roll_ttl_alloc,)

#remove intermediate variables and combine w/ clean df
new_dh_df <- new_dh_df %>% select(year, team, qb_pa, rb_pa, wr_pa, te_pa, ol_pa,
                                  dl_pa, lb_pa, sec_pa, st_pa)
df_final <- left_join(df_clean, new_dh_df)
df_final_clean <- df_final[, -c(5:14, 24, 26:29)]

# save final df
write.csv(df_final_clean, "/Users/dylanjorling/UCLA/\404dffinal.csv")
