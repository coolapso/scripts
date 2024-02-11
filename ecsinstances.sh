#!/bin/bash

### Main Vars
regions=( "us-west-1"
          "us-east-1"
          "eu-west-2"
          "eu-west-1"
          "eu-central-1")
cfile="/tmp/clusters"
ecsfile="/tmp/ecsinstances"
instancefile="/tmp/instance"
instancedetails="/tmp/instancedetails"

### function to list ECS Clusters
getecsclusters(){
  echo -e " ::: Getting clusters list this might take a while ...\n"
  for region in ${regions[@]}; do
      aws ecs list-clusters --region $region --profile temp | grep "arn:aws:ecs" | awk -v FS='"' '{print $2}' >> $cfile 
  done
}

## Function to list clusters
listclusters(){
  cat $cfile
}

##Main Function, 
##list container instances, 
##Prints the headers nice formated text or CSV
##skips staging, test and dev instances
##calls getdata to filter info and print it nicely
ecsinstances(){
  if [[ $csv -eq 1 ]]; then

      echo " ::: Geting ECS instances details and writing to $file, this might take a while..."
      echo -e "Region;AZ;ec2Id;Type;tasks;Agent-V;docker-v;AMI;cluster-name" > $file

  else

      echo " ::: Geting Instances details, this might take a while..."
      echo -e "Region\t\tAZ\t\t\tec2id\t\tType\t\ttasks\tAgent-V\tdocker-v\t\tAMI\t\t\tcluster-name" > $instancedetails

  fi
  while read cluster; do
      if $(echo $cluster | egrep -q "staging|test|dev");then
         continue
      else
          region=$(echo $cluster | awk -F ":" '{print $4}')
          instances=$(aws ecs list-container-instances --cluster $cluster --profile=temp --region $region | grep "arn:aws:ecs" | awk -v FS='"' '{print $2}')
          for instance in ${instances[@]}; do
              getdata "$csv" "$file"

          done
      fi
  done <$cfile 
  if [[ $csv -eq 1 ]]; then
    cat $file
  else
    cat $instancedetails | (sed -u 1q; sort -k 5)
  fi
  
}


##Gets the needed data from AWS Json output and prints it nicely
getdata(){
  

  aws ecs describe-container-instances --cluster $cluster --container-instances $instance --region $region --profile=temp > $instancefile


  icluster=$(echo $cluster | awk -F ":" '{print $6}')
  ami=$(egrep "ami" $instancefile | grep "value" | awk -v FS='"' '{print $4}')
  itype=$(egrep -A 1 "ecs.instance-type" $instancefile | awk -v FS='"' '{print $4}' | tail -1 )
  az=$(egrep "$region"[a-z]{1}  $instancefile | awk -v FS='"' '{print $4}')
  agent=$(grep "agentVersion" $instancefile | awk -v FS='"' '{print $4}')
  dckrver=$(grep "DockerVersion"  $instancefile | awk -v FS='"' '{print $4}' | awk '{print $2}') 
  tasks=$(egrep "runningTasksCount" $instancefile  | awk '{print $2}') 
  ec2id=$(awk -v FS='"' '/ec2InstanceId/ {print $4}' $instancefile)



  if [[ $csv -eq 1 ]]; then
     echo -e "$region;$az;$ec2id;$itype;"${tasks//,}";$agent;$dckrver;$ami;$icluster" >> $file 
  else
     echo -e "$region\t$az\t$ec2id\t$itype\t"${tasks//,}"\t$agent\t$dckrver\t$ami\t\t$icluster" >> $instancedetails
  fi

}

##Celeanup after usage
cleanup(){
  if [[ -f $cfile ]]; then
      rm -rf $cfile
  fi
  if [[ -f $ecsfile ]]; then
      rm -rf $ecsfile; 
  fi
  if [[ -f $instancefile ]]; then
      rm -rf $instancefile
  fi
  if [[ -f $instancedetails ]]; then
    rm -rf $instancedetails
  fi
}

scriptusage(){
  echo -e " ecsdetails.sh -csv file \n
        if script is called with no arguments result will be printed in console space separated"
}


##Script is slow, so its nice to know how long it takes to run. 
starttime(){
    starth=$(date +%H)
    startm=$(date +%M)
    starts=$(date +%S)
}
endtime(){
    endh=$(date +%H)
    endm=$(date +%M)
    ends=$(date +%S)
    tth=$((endh-starth))
    ttm=$((endm-startm))
    echo "finished in: "$tth"h"$ttm"m"$ends"s"
  }


##SCRIPT
while true; do
  case "$1" in
    -csv ) 
            csv=1
            file="$2"
            starttime
            cleanup
            getecsclusters
            ecsinstances "$csv" "$file"
            cleanup
            endtime
            exit 0
        ;;
    -h | --help) scriptusage; exit 0
      ;;
    * )
            starttime
            cleanup
            getecsclusters
            ecsinstances
            endtime
            exit 0
        ;;
  esac
done
