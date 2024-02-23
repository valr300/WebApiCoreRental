Notes for installing the WebApiCoreRental 
-----------------------------------------

The WebApiCoreRental has the purpose of collecting Data for the "Vallands Rental System 1.0"
This product can be found in OpenSim at the Valland Shop,   see http://www.vallands.ca  for more information.

You need dotnet    6.0  to run  the WebApiCoreRental.

These steps assume your know what you are doing. As i can barely help you myself.  
You must be the owner of your system , as you will need the root power.


This document show the installation on :

Linux  Ubuntu 22.04.2 LTS" 
nginx/1.18.0 (Ubuntu) 
MySql Database  8.0.36-0ubuntu0.22.04.1
dotnet    6.0.127 [/usr/lib/dotnet/sdk]


It should be compatible for windows and probably MariaDB, although i havent tested it, and of course the installation will vary , 
in that case use my these notes as a roughly guides.

Note that for these step and further down the road, you really need to know what you are doing, 
and taking these steps i did here wont necessarely mean a success on your installation 
as your installation might be slighly different than mine, 
however, i think that if i show you what i did, it might help you find what you need to do, 
adapting these instructions to your own environment.
And i am not responsible in any way shape or form on what ever you do on your system.
Take backups before proceding.


Step 1 :  Get the package 
-------------------------
You will need the latest version of WebApiCoreRental , you can get it here :  https://github.com/valr300/WebApiCoreRental
You can get the package only, the source aren't needed.


Create  folder       /var/www/RentalApi   on your linux Machine :

sudo mkdir /var/www/RentalApi


Put the package  in  /var/www/RentalApi  :
cd {the place you put the package}
sudo cp -r * /var/www/RentalApi



Step 2 : Create the Database
----------------------------
Execute the following script in your Database MySql  :
 
Rental_Rentals.sql  		will build the database Rental and the Tables
Rental_routines.sql             will build the stored procs  


Step 3 : Create The user database for the Rental database
----------------------------------------------------------
execute the following line 

mysql -u root --password
(enter your mysql password, or if you haven't set password for MySQL server, type "mysql -u root" instead)
You can even use MySQL Command Line Client on Start menu on Windows. After login, create user and database for OpenSimulator.
or if you prefer proceed to create you user via the Workbench, much easier !.

CREATE USER 'Rental'@'localhost' IDENTIFIED BY 'YOURPASSWORD';
GRANT ALL PRIVILEGES ON Rental.* TO 'Rental'@'localhost';



Step 4 : Add your API to Nginx
-------------------------------

you will need to edit your sites-available/default and add the API. 

sudo vi /etc/nginx/sites-available/default 
add these line in the server{} definition ( the Http 80 section only will be enough, as the server will only be accessed locally, change YOURPORT by the Port number you want your service to run) 

       location /RU/ {
                    proxy_pass         http://localhost:YOURPORT;
                    proxy_http_version 1.1;
                    proxy_set_header   Upgrade $http_upgrade;
                    proxy_set_header   Connection keep-alive;
                    proxy_set_header   Host $host;
                    proxy_cache_bypass $http_upgrade;
                    proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
                    proxy_set_header   X-Forwarded-Proto $scheme;
         }



sudo service nginx reload  

( at this point it would be wise to check if your web site is still working, make sure you did'nt cause any mess)



Step 5 : Configuring and Testing the WebApiCore 
-----------------------------------------------

edit  connectionString in the /var/www/RentalApi/appsettings.json  :

cd /var/www/RentalApi
sudo vi appsettings.json
and add the following line :


   "ConnectionStrings": {
               "RentalApi": "server=localhost;user=Rental;database=Rental;port=3306;password=YOURPASSWORD"
                 }

then test the API :

sudo dotnet WebApiCoreRental.dll        : to check if it works (it should be waiting for request, press ctrl-c to exit)
					  proceed to fix any error it could give you	



Step 6 : Configuring the Service
---------------------------------
You will create the following file to create your new service

sudo vi /etc/systemd/system/kestrel-WebApiCoreRental.service 

and add the following lines (replacing the YOURPORT by the port number you want your service to run on) :

[Unit]
Description=RentalApi

[Service]
WorkingDirectory=/var/www/RentalApi
ExecStart=/usr/bin/dotnet /var/www/RentalApi/WebApiCoreRental.dll --urls http://localhost:YOURPORT
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=dotnet-example
User=www-data
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target


Step 7 : Enabling the Service
-----------------------------

sudo systemctl enable kestrel-WebApiCoreRental.service

Step 8 : Starting the Service
-----------------------------

sudo systemctl stop kestrel-WebApiCoreRental.service 
sudo systemctl start kestrel-WebApiCoreRental.service 

to check if it is running :

sudo systemctl status kestrel-WebApiCoreRental.service 

proceed to fix any error it could give you, you can use the following command to help you :	

journalctl -f
sudo systemctl status nginx 


Step 9 : Opening the port on your OpenSim installation
------------------------------------------------------


change the OpenSim.ini to allow the port connection (replacing the YOURPORT by the port number you want your service to run on) :

OutboundDisallowForUserScriptsExcept = 127.0.0.1:YOURPORT


then restart your region


Step 10 :  Tell the Rental system your Server URL
--------------------------------------------------

Click on the Rental Server to Access the Settings Menu
Select "Stats", then "ServerURL"  and enter your server URL
should be something like this :  (replacing the YOURPORT by the port number you want your service to run on)

http://localhost:YOURPORT/RU/

At this point everything should be working. You can Rent, and you should see the Data coming in your Database

Select * from Rentals order by RentalTimeStamp








