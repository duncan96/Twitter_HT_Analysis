# Twitter Hashtag Analysis Project

This all began as a Twitter hashtag classification project for a simple pattern recognition study.  

The project includes a set of R functions in TwitterSentiment.R to search Twitter for entries containing hashtags from one of three pre-defined classes (happy, political and sports).
The search terms are stored in CSV files, and were generated by searching out the most popular hashtags of each type.  In the future I hope to automate the collection of popular hashtags terms, so that the program can continue to create class listing that are relevant.
The R functions parse the data contained in the tweets and store the data in a new CSV file which is then saved in the directory.  This file can then be read into TwitterSentiment.m, which generates visual representations of the relations in the dataset.
