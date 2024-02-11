#!/bin/bash

## Script vars ##

regions=( "us-west-1"
          "us-east-1"
          "eu-west-2"
          "eu-west-1"
          "eu-central-1")

volumesfile="/tmp/volumes.csv"

##List all volumes per region and write them to a file##
describevolume(){

  for region in ${regions[@]}; do

      aws ec2 describe-volumes --region $region --query 'Volumes[*].[VolumeId, Attachments[0].InstanceId, AvailabilityZone, Size]' --output text --profile=temp >> $volumesfile

  done

}


##As describing volumes the name comes in different lines, to get a nice output this funcion
##reads volumes file, picks the volume id, describes it, gets the volume Name tag and adds it
##to volumes file in the first column
getname(){

  while read volume; do
    vid=$(echo $volume | awk '{print $1}')
    reg=$(echo $volume | awk '{print $3}')
    reg=$(echo ${reg%?})
  
    #Uncommennt for debugging#
#   echo "volume is: $volume"
#   echo "checking $vid in $region"
#   echo "using command aws ec2 describe-volumes --region "${reg}" --volume "${vid}" --query 'Volumes[*].[Tags[?Key==\`Name\`].Value[]]' --profile=temp --output text"
    #Uncoment above for debugging#
    name=$(aws ec2 describe-volumes --region "${reg}" --volume "${vid}" --query 'Volumes[*].[Tags[?Key==`Name`].Value[]]' --profile=temp --output text)
    if [[ -z $name ]]; then
        name="None"
    fi
     sed -i 's/'"$vid"'/'"$name"'\t'"$vid"'/' $volumesfile
  done <$volumesfile

}

##Cleans up if volumes file exists
cleanup(){

  if [[ -f $volumesfile ]]; then
     rm -rf $volumesfile
  fi 

}

makecsv(){
  sed -i '1 i\"Name;vlumeId;InstanceId;AZ;Size(GB)"' $volumesfile
  sed -i 's/\t/;/g' $volumesfile
}

### SCRIPT ###

cleanup
echo "getting volume details data to $volumesfile, this might take a while ..."
describevolume
getname
makecsv
