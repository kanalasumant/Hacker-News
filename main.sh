#!/bin/bash

function FETCH_JSON_IN_PARALLEL_AND_SEND_EMAIL_IF_MATCH_OCCURS() {
	DATA=$(curl https://hacker-news.firebaseio.com/v0/item/$1.json)
	if [[ $(echo $DATA | grep -iP 'javascript|node|golang|elixir|clojure|youtube' | wc -l) -eq 1 ]];then
		TITLE_OF_ARTICLE=$(echo $DATA | grep -Po '(?<=)"title":".*?"(?=)')
		URL_OF_ARTICLE=$(echo $DATA | grep -Po '(?<=)"url":".*?"(?=)')
		echo $TITLE_OF_ARTICLE $URL_OF_ARTICLE >> ./FIRST_DUMP.txt
	fi
}
export -f FETCH_JSON_IN_PARALLEL_AND_SEND_EMAIL_IF_MATCH_OCCURS

function SEND_EMAIL() {
	sendEmail -f FROM-ADDRESS -t TO-ADDRESS -u "Hacker-News Update on Javascript | Node | Golang | Elixir | Clojure | YouTube" -o message-file=./FIRST_DUMP.txt -s smtp.googlemail.com:587 -xu USERNAME -xp PASSWORD -o tls=yes
}
export -f SEND_EMAIL

function  EXECUTE_MAIN_SCRIPT() {
	touch ./FIRST_DUMP.txt
	curl https://hacker-news.firebaseio.com/v0/newstories.json | grep -Po '\d+' | parallel -j0 FETCH_JSON_IN_PARALLEL_AND_SEND_EMAIL_IF_MATCH_OCCURS
	SEND_EMAIL
	rm ./FIRST_DUMP.txt
}
export -f EXECUTE_MAIN_SCRIPT

if [[ ! -f ./FIRST_DUMP.txt ]];then
	EXECUTE_MAIN_SCRIPT
else
	rm ./FIRST_DUMP.txt
	EXECUTE_MAIN_SCRIPT
fi
