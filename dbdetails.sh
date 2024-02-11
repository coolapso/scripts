#!/bin/bash
#Script to get information about all RDS Instances specified regions
regions=( "us-west-1"
          "us-east-1"
          "eu-west-2"
          "eu-west-1"
          "eu-central-1")

dbdetailsfile=("/tmp/dbdetails.csv")

## Gets info about databases in each listed region. 
getinfo(){
    echo -e "Name\tDB Type\tVersion\tAZ"
    for region in ${regions[@]}; do
        aws rds describe-db-instances --region $region --profile temp --query 'DBInstances[*].[DBInstanceIdentifier, Engine, EngineVersion, AvailabilityZone]' --output text
    done

}

### Same as above but makes a csv file
makecsv(){
    echo "Generating DB Instance details csv file to $dbdetailsfile ..."
    echo "Name;DB Type;Version;AZ" > $dbdetailsfile
    for region in ${regions[@]}; do
        aws rds describe-db-instances --region $region --profile temp --query 'DBInstances[*].[DBInstanceIdentifier, Engine, EngineVersion, AvailabilityZone]' --output text >> $dbdetailsfile
    done
    sed -i 's/\t/;/g' $dbdetailsfile

}

### If -csv flag is passed then it will fetch info and make a csv file
while true; do
  case "$1" in
    -csv )
        makecsv
        exit 0
        ;;
    *   )
        getinfo
        exit 0
        ;;
  esac
done
