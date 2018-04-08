#!/bin/bash

# Main function which fetches data from Hacker News Firebase API, filters keywords of interest and add only the matches to 
# FIRST_DUMP.txt file in the same directory as this script.
function FETCH_JSON_IN_PARALLEL_AND_SEND_EMAIL_IF_MATCH_OCCURS() {
	DATA=$(curl https://hacker-news.firebaseio.com/v0/item/$1.json)
	if [[ $(echo $DATA | grep -iP 'javascript|node|golang|elixir|clojure|youtube' | wc -l) -eq 1 ]];then
		TITLE_OF_ARTICLE=$(echo $DATA | grep -Po '(?<=)"title":".*?"(?=)')
		URL_OF_ARTICLE=$(echo $DATA | grep -Po '(?<=)"url":".*?"(?=)')
		echo $TITLE_OF_ARTICLE $URL_OF_ARTICLE >> ./FIRST_DUMP.txt
	fi
}
export -f FETCH_JSON_IN_PARALLEL_AND_SEND_EMAIL_IF_MATCH_OCCURS

# A function which sends email to user defined to addresses with the matched Titles and URLs stored in the FIRST_DUMP.txt file.
# For this script to work this function (send-email) has to be configured with the from, to addresses 
# and also the smtp username and password, which in this case is gmail.
function send-email() {
	sendEmail -f FROM-ADDRESS -t TO-ADDRESS -u "Hacker-News Update on Javascript | Node | Golang | Elixir | Clojure | YouTube" -o message-file=./FIRST_DUMP.txt -s smtp.googlemail.com:587 -xu USERNAME -xp PASSWORD -o tls=yes
}
export -f send-email

# Function which first creates the FIRST_DUMP.txt file, fetches the latest stories pipes this output to grep,
# which then filters the IDs and pipes them to the GNU parallel program whcih parallelizes by sending each line from the input received
# to a new spawned process which inturn calls main function defined above. After this operation copmpletes for all IDs the send-email function is called
function  EXECUTE_MAIN_SCRIPT() {
	touch ./FIRST_DUMP.txt
	curl https://hacker-news.firebaseio.com/v0/newstories.json | grep -Po '\d+' | parallel -j0 FETCH_JSON_IN_PARALLEL_AND_SEND_EMAIL_IF_MATCH_OCCURS
	send-email
	rm ./FIRST_DUMP.txt
}
export -f EXECUTE_MAIN_SCRIPT

# This is the start of the script. It checks if a file by name FIRST_DUMP.txt exists and if it does, it removes it and starts the main
# script, else it removes FIRST_DUMP.txt and starts the main script. The reason a check is performed so that if a file with same name
# already exists we want fresh matches from this session to be stored and sent through the email and do not wanna append it to the 
# older version of this file.
if [[ ! -f ./FIRST_DUMP.txt ]];then
	EXECUTE_MAIN_SCRIPT
else
	rm ./FIRST_DUMP.txt
	EXECUTE_MAIN_SCRIPT
fi
