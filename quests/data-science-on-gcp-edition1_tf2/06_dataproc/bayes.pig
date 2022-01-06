REGISTER /usr/lib/pig/piggybank.jar;

FLIGHTS = 
   LOAD 'gs://cloud-training-demos-ml/flights/tzcorr/all_flights-00000-*'
   using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'NOCHANGE') 
   AS (FL_DATE:chararray,UNIQUE_CARRIER:chararray,AIRLINE_ID:chararray,CARRIER:chararray,FL_NUM:chararray,ORIGIN_AIRPORT_ID:chararray,ORIGIN_AIRPORT_SEQ_ID:int,ORIGIN_CITY_MARKET_ID:chararray,ORIGIN:chararray,DEST_AIRPORT_ID:chararray,DEST_AIRPORT_SEQ_ID:int,DEST_CITY_MARKET_ID:chararray,DEST:chararray,CRS_DEP_TIME:datetime,DEP_TIME:datetime,DEP_DELAY:float,TAXI_OUT:float,WHEELS_OFF:datetime,WHEELS_ON:datetime,TAXI_IN:float,CRS_ARR_TIME:datetime,ARR_TIME:datetime,ARR_DELAY:float,CANCELLED:chararray,CANCELLATION_CODE:chararray,DIVERTED:chararray,DISTANCE:float,DEP_AIRPORT_LAT:float,DEP_AIRPORT_LON:float,DEP_AIRPORT_TZOFFSET:float,ARR_AIRPORT_LAT:float,ARR_AIRPORT_LON:float,ARR_AIRPORT_TZOFFSET:float,EVENT:chararray,NOTIFY_TIME:datetime);

FLIGHTS2 = FOREACH FLIGHTS GENERATE 
     (DISTANCE < 251? 0:
     (DISTANCE < 368? 1:
     (DISTANCE < 448? 2:
     (DISTANCE < 575? 3:
     (DISTANCE < 669? 4:
     (DISTANCE < 838? 5:
     (DISTANCE < 1012? 6:
     (DISTANCE < 1218? 7:
     (DISTANCE < 1849? 8:
          9))))))))) AS distbin:int,
     (DEP_DELAY < -6? 0:
     (DEP_DELAY < -5? 1:
     (DEP_DELAY < -4? 2:
     (DEP_DELAY < -3? 3:
     (DEP_DELAY < 0? 4:
     (DEP_DELAY < 3? 5:
     (DEP_DELAY < 5? 6:
     (DEP_DELAY < 11? 7:
     (DEP_DELAY < 39? 8:
          9))))))))) AS depdelaybin:int,
     (ARR_DELAY < 15? 1:0) AS ontime:int;

grouped = GROUP FLIGHTS2 BY (distbin, depdelaybin);
result = FOREACH grouped GENERATE 
           FLATTEN(group) AS (dist, delay), 
           ((double)SUM(FLIGHTS2.ontime))/COUNT(FLIGHTS2.ontime) AS ontime:double;

store result into 'gs://cloud-training-demos-ml/flights/pigoutput/' using PigStorage(',','-schema');
