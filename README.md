# Hacker-News
A bash script/program which fetches new stories from the official **Hacker News Firebase API**, then filters content to our desire, then sends the **title** and **url** of all the matched stories to the user's email.

## Configuration
### Tested on:
- Distribution: Ubuntu 16.04.3 LTS
- Codename: Xenial

Now since the final part of the script is to send an email, and since we use an email client package called sendemail, we will need to fetch the package.

Run the following command to update package lists for existing packages and also to list new available packages for this distro. Everytime a command starts with sudo, you will be prompted for the root password. Enter the password and the packages will be udpated.
```console
foo@bar:~$ sudo apt-get update
```

After the update, install the package by typing the following command in the terminal.
```console
foo@bar:~$ sudo apt-get install sendemail
```

After the above package is installed, additional packages for SSL support need to be installed as per [link](https://packages.ubuntu.com/xenial/sendemail). To fetch these run the following commands in the terminal.
```console
foo@bar:~$ sudo apt-get install libio-socket-ssl-perl libnet-ssleay-perl
```

***Note: To run the script main.sh, execute permissions are required. One can enable permissions by typing the following command in the terminal***
```console
foo@bar:~$ chmod +x main.sh
# or
foo@bar:~$ chmod 700 main.sh
foo
```
To run the script type the following command in the terminal

```console
foo@bar:~$ ./main.sh
```

## Functionality
This program is useful when run as a **cron job** approximately once every 12 hours, to avoid missing new stories but accepting a few duplicated ones.

The script starts by checking if a file by name **FIRST_DUMP.txt** exists and if it does, it removes it and starts the main
script, else it removes FIRST_DUMP.txt and starts the main script. The reason a check is performed so that if a file with same name
already exists we want fresh matches from this session to be stored and sent through the email and do not wanna append it to the 
older version of this file.
### This program is split into 3 main functions and each of the function is described as follows:
#### EXECUTE_MAIN_SCRIPT
This is an orchestrator function which first **creates** the **FIRST_DUMP.txt** file, **fetches the latest stories** and **pipes** this output to **grep**, which then **filters the IDs** which are **integers** and pipes them to the **GNU parallel** program which **parallelizes** by sending each line from the input received to a new **spawned process** which inturn calls main function **FETCH_JSON_IN_PARALLEL_AND_SEND_EMAIL_IF_MATCH_OCCURS**. After this operation completes for all IDs the **send-email** function is called.

#### FETCH_JSON_IN_PARALLEL_AND_SEND_EMAIL_IF_MATCH_OCCURS
This is the most **important** function which fetches data from **Hacker News Firebase API**, **filters keywords** of interest and adds only the matches to **FIRST_DUMP.txt** file in the same directory as this script.

#### SEND_EMAIL
A function which sends email to user defined to addresses with the matched Titles and URLs stored in the FIRST_DUMP.txt file. For this script to work this function (send-email) has to be configured with the from, to addresses and also the smtp username and password, which in this case is gmail.

## Future Updates
To give the users the ability to add and **parse arguments** to the script such as **filter** words separated by **commas in a string**,  **email configuration** parameters such as a **From Address**, **To Address**, **SMTP Username** and **SMTP Password** with the help of **flags**.

***NOTE: Feel free to submit PRs as new branches. I will certainly take a look at them.***

## License

Copyright © 2017, [Sumant Kanala](https://github.com/kanalasumant).
Released under the [GNU General Public License v3.0](LICENSE).

***
