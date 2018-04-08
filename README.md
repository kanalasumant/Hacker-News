# Hacker-News
A bash script which fetches new stories from the official **Hacker News Firebase API**, then filters content to our desire, then sends the **title** and **url** of all the matched stories to the user's email.

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

After the above package is installed, additional packages for SSL support need to be installed as per [link](https://packages.ubuntu.com/xenial/sendemail)
To fetch these run the following commands in the terminal.
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
