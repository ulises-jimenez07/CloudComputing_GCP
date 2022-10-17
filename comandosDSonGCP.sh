BTS=https://transtats.bts.gov/PREZIP
BASEURL="${BTS}/On_Time_Reporting_Carrier_On_Time_Performance_1987_present"
YEAR=2015
MONTH=3
curl -k -o temp.zip ${BASEURL}_${YEAR}_${MONTH}.zip

head -5 *.csv

#instead of calling temp
MONTH2=$(printf "%02d" $MONTH)

#create a temp file
TMPDIR=$(mktemp -d)


ZIPFILE=${TMPDIR}/${YEAR}_${MONTH2}.zip
curl -o $ZIPFILE ${BASEURL}_${YEAR}_${MONTH}.zip

unzip -d $TMPDIR $ZIPFILE
mv $TMPDIR/*.csv ./${YEAR}${MONTH2}.csv
rm -rf $TMPDIR


#download.sh

for MONTH in `seq 1 12`; do
   bash download.sh $YEAR $MONTH
done


#clonar el repositorio para obtener el archivo download.sh
git clone https://github.com/GoogleCloudPlatform/data-science-on-gcp

cd data-science-on-gcp

mkdir data
cd data

for MONTH in `seq 1 12`; do
      bash ../02_ingest/download.sh 2015 $MONTH
done
wc -l *.csv
 
#gcloud utilities from SDLK
gcloud config configurations activate my-config
gcloud config set project PROJECT_ID
gcloud cloud-shell ssh

#create a new bucket
PROJECT=$(gcloud config get-value project)
BUCKET=${PROJECT}-dsongcp
REGION=us-central1 #See https://cloud.google.com/storage/docs/locations
gsutil mb -l $REGION gs://$BUCKET


gsutil -m cp *.csv gs://$BUCKET/flights/raw/

#create dataset in BigQuery
bq mk dsongcp

BUCKET=${PROJECT}-dsongcp
bq load --autodetect --source_format=CSV \
   dsongcp.flights_auto \
   gs://${BUCKET}/flights/raw/201501.csv
   
   
 SELECT
    ORIGIN,
    AVG(DEPDELAY) AS dep_delay,
    AVG(ARRDELAY) AS arr_delay,
    COUNT(ARRDELAY) AS num_flights
  FROM
    dsongcp.flights_auto
  GROUP BY
    ORIGIN
ORDER BY num_flights DESC
LIMIT 10


bq mk --time_partitioning_type=DAY dsongcp.flights_auto
 ./bqload.sh $BUCKET 2015
 
#Python
#!/bin/bash
for MONTH in `seq 1 12`; do
   bash download.sh $YEAR $MONTH
done

# upload the raw CSV files to our GCS bucket
bash upload.sh

# load the CSV files into BigQuery as string columns
bash bqload.sh
