#install.packages(c('twitter', 'syuzhet', 'tm', 'readr', 'stringr','csv'))
library(twitteR)
library(syuzhet)
library(tm)
library(readr)
library(stringr)
library(csv)

#TWITTER APP DATA
CONSUMERKEY<- MYCONSUMERKEY
CONSUMERSECRET<- MYCONSUMERSECRET
ACCESSTOKEN<- MYACCESSTOKEN
ACCESSSECRET<-  MYACCESSSECRET

runAuth<-function()
{
  origop <- options("httr_oauth_cache")
  options(httr_oauth_cache=TRUE)
  setup_twitter_oauth(CONSUMERKEY, CONSUMERSECRET, ACCESSTOKEN, ACCESSSECRET)
  options(httr_oauth_cache=origop)
}

#read in datasets


suppressWarnings(
    {
    HappyHashtags <- read_delim("C:/Users/dunca.DESKTOP-I41J7PC/Desktop/CSS 490/Project/Twitter/HappyHashtags.csv", 
                         " ", escape_double = FALSE, col_names = FALSE, 
                         trim_ws = TRUE)

    SportsHashtags <- read_delim("C:/Users/dunca.DESKTOP-I41J7PC/Desktop/CSS 490/Project/Twitter/SportsHashtags.csv", 
                             " ", escape_double = FALSE, col_names = FALSE, 
                             trim_ws = TRUE)
    
    PoliticalHashtags <- read_delim("C:/Users/dunca.DESKTOP-I41J7PC/Desktop/CSS 490/Project/Twitter/PoliticalHashtags.csv", 
                             " ", escape_double = FALSE, col_names = FALSE, 
                             trim_ws = TRUE)
    }
)


PopClass<-c('#DuckDynasty','#StarWars', '#StarTrek')
HappyClass <- as.character(unlist(HappyHashtags))
PoliticalClass <- as.character(unlist(PoliticalHashtags))
SportsClass <- as.character(unlist(SportsHashtags))
VideoGamesClass <- c('#CoD')

AddData<-function(classNums, hashTags, numEx)
{
  Classes <- c('Sports', 'Politics', 'FunNHappy', 'VideoGames', 'PopCulture')
  ClassNum <- c()
  Class <- c()
  Hash <- c()
  Year <- c()
  Month <- c()
  Day <- c()
  Time <- c()
  Text <- c()
  CleanText <- c()
  WordCount <- c()
  CharCount <- c()
  PeriodCount <- c()
  ExMarkCount <- c()
  QMarkCount <- c()
  Sentiment <- c()
  TagCount <-
  Tags <- c()
  for(k in 1:length(classNums))
  {
    hashtag <- switch(classNums[k],
                      '1' = SportsClass[sample(length(SportsClass),hashTags)],
                      '2' = PoliticalClass[sample(length(PoliticalClass),hashTags)],
                      '3' = HappyClass[sample(length(HappyClass),hashTags)],
                      '4' = VideoGamesClass[sample(length(VideoGamesClass),hashTags)],
                      '5' = PopClass[sample(length(PopClass),hashTags)])
    for(j in 1:length(hashtag))
    {
      tweets<-searchTwitter(hashtag[j], numEx, lang = 'en-us', resultType = "popular")
      if(length(tweets) > 0)
      {
        for(i in 1:length(tweets))
        {
          val<-tweets[[i]]
          ClassNum <- c(ClassNum, k)
          Class <- c(Class, Classes[k])
          Hash <- c(Hash, hashtag[j])
          Date <- FormatDate(as.string(val$created))
          Year <- c(Year, Date[1])
          Month <- c(Month, Date[2])
          Day <- c(Day, Date[3])
          Time <- c(Time, Date[4])
          Text <- c(Text, val$text)
          #CleanText <- c(CleanText, stringr::str_replace_all(val$text, "[^a-zA-Z\\s]", " "))
          CleanTxt <- Clean_String(val$text)
          WordCount <- c(WordCount, length(CleanTxt))
          CharCount <- c(CharCount, sum(str_length(CleanTxt)))
          Sentiment <- c(Sentiment, sum(get_sentiment(CleanTxt, method = "afinn")))
          punct <-  (str_replace_all(val$text, "[^,.!?#]", " "))
          QMarkCount <- c(QMarkCount, str_count(punct, "[/?]"))
          ExMarkCount <- c(ExMarkCount, str_count(punct, "[/!]"))
          PeriodCount <- c(PeriodCount, str_count(punct, "[/.]"))
          TagCount <- c(TagCount, str_count(punct, "#"))
          Tags <- c(Tags, paste(str_extract_all(val$text, "#\\S+")))
        }
      }
    }
  }
  TweetData<-data.frame(ClassNum, Class, Hash, Text, Tags, Sentiment, WordCount, CharCount, PeriodCount, QMarkCount, ExMarkCount, TagCount, Year, Month, Day, Time)
  return(TweetData)
}

Clean_String <- function(string)
{
  temp <- str_replace_all(string,"[^a-zA-Z\\s]", " ")
  temp <- tolower(temp)
  temp <- str_replace_all(temp,"[\\s]+", " ")
  temp <- str_split(temp, " ")[[1]]
  indexes <- which(temp == "")
  if(length(indexes) > 0){
    temp <- temp[-indexes]
  } 
  return(temp)
}

FormatDate <- function(dateStr)
{
  year <- substring(dateStr, 1, 4)
  month <- substring(dateStr, 6, 7)
  day <- substring(dateStr, 9, 10)
  
  time<-substring(dateStr, 12, 19)
  time<- str_replace_all(time, "[/:]", "")
  return(c(year, month, day, time))
}


CollectDataset<-function(classes = c(1,2,3), numHash = 2, numEach = 2)
{
  runAuth()
  return(suppressWarnings({AddData(classes, numHash, numEach)}))
}

FilteredDataSet<-function(classes = c(1,2,3), numHash = 2, numEach = 2, path = "C:/Users/dunca.DESKTOP-I41J7PC/Desktop/CSS 490/Project/Twitter/", Fname = "FilteredData")
{
  TweetDataSet <- CollectDataset(classes, numHash, numEach)
  FilteredData <- data.frame(TweetDataSet$ClassNum, TweetDataSet$Sentiment, TweetDataSet$WordCount, TweetDataSet$PeriodCount, TweetDataSet$QMarkCount, 
                             TweetDataSet$ExMarkCount, TweetDataSet$TagCount, TweetDataSet$Year, TweetDataSet$Month, TweetDataSet$Day, TweetDataSet$Time)
  toCSV(FilteredData, path, Fname)
  return(FilteredData)
}

toCSV <- function(dataset, path, fileName)
{
  as.csv(dataset, paste(path, fileName, ".csv"))
}
