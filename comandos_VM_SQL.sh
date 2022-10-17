#Databases in GCP example


#VM instance creation using CLI

#list zones and images available
gcloud compute zones list
gcloud compute images list

#create VM
gcloud compute instances create vm-mariadb --zone=us-central1-a --machine-type=n1-standard-1 \
--image-project=ubuntu-os-cloud --image-family=ubuntu-1804-lts   --scopes cloud-platform

--scopes=https://www.googleapis.com/auth/cloud-platform -



#list instances, start stop
gcloud compute instances list
gcloud compute instances start
gcloud compute instances stop
gcloud compute instances delete 
#connect SSH to instance
gcloud compute ssh vm-mariadb

#Install mariadb in VM
sudo apt-update
sudo apt-get install mariadb-server
sudo mysql_secure_installation

Example123

#connect to mariadb and create user
sudo mysql -u root -pExample13

CREATE USER 'cc_user'@'%' IDENTIFIED BY 'Example123';
GRANT ALL PRIVILEGES ON *.* TO 'big_data_user';
FLUSH PRIVILEGES;

sudo mysql -u cc_user -pExample123

#create database
CREATE DATABASE SPAIN_TENDERS;
USE SPAIN_TENDERS;

#update files for configuration
#/etc/mysql/my.cnf
[mysqld]
skip-networking=0
skip-bind-address

#/etc/mysql/mariadb.conf.d/50-server.cnf 
#bind-address 	= 127.0.0.1


#create firewall rule
gcloud compute instances list --format "get(zone)"
gcloud compute --project=testup-gcp firewall-rules create mariadb --direction=INGRESS \
--priority=1000 --network=default --action=ALLOW --rules=tcp:3306 --source-ranges=0.0.0.0/0 \
--target-tags=mariadb


#attach rule
gcloud compute instances add-tags vm-mariadb  --zone us-central1-a --tags mariadb
gcloud compute instances restart vm-mariadb


"""
CREATE TABLE TENDER_DETAIL (id int NOT NULL PRIMARY KEY AUTO_INCREMENT, tender_id int, date DATE, deadline_date DATE, deadline_length_days int, title VARCHAR(200), category VARCHAR(50), sid int, src_url VARCHAR(250), purchaser int, 
tender_type VARCHAR(50), awarded_date DATE, awarded_offers_count int, awarded_offers_supplier_id int, awarded_offers_supplier_name VARCHAR(100), awarded_offers_value float)
"""

gcloud auth login
gsutil mb -l us-central1 gs://mariadb-sqlcloud-up
gsutil cp backup_spain.sql gs://mariadb-sqlcloud-up




CREATE TABLE author (
  aid INT64,
  authorname STRING(100)
) PRIMARY KEY (aid);


CREATE TABLE book (
  aid INT64,
  bid INT64,
  bookname STRING(200)
) PRIMARY KEY (aid,bid),
INTERLEAVE IN PARENT author ON DELETE CASCADE;


#install redis
redis-cli
sudo apt-get install redis-tools
ping
ping "hello"
set foo bar
get foo

#BIG TABLE
echo $DEVSHELL_PROJECT_ID


cbt createtable emp
nano .cbtrc
project = testup-gcp
instance = mi-primer-tablota

#consultar tablota
cbt ls emp
cbt createfamily emp professional_data_cf


cbt set emp J1 personal_data_cf:name=john
cbt set emp J1 personal_data_cf:age=28

key J1
cbt read emp

cbt set emp A1 professional_data_cf:education=master