# This script goes through aws Events and gets the ids and tags of affected ec2 instneces
import boto3
from botocore.exceptions import ClientError

health_client = boto3.client('health', region_name='us-east-1')


event_filter = {
    'services': ['EC2'],
    'eventTypeCodes': ['AWS_EC2_OPERATIONAL_NOTIFICATION'],
}

response = health_client.describe_events(filter=event_filter)

for event in response['events']:
    region = event['region']
    ec2 = boto3.client('ec2', region_name=region)
    if region != 'global':
        print(f"Event ARN: {event['arn']}")
        entities = health_client.describe_affected_entities(filter={'eventArns': [event['arn']]}).get('entities', [])
        print("Affected Entities:")
        for entity in entities:
            entity_arn = entity['entityValue']
            instance_id = entity_arn.split('/')[-1]
            try:
                ec2_data = ec2.describe_instances(InstanceIds=[instance_id])
                instance = ec2_data['Reservations'][0]['Instances'][0]
                instance_name = None
                for tag in instance['Tags']:
                    if tag['Key'] == 'Name':
                        print(f"Instance id: {instance_id} | instance tags: {tag['Value']}")
            except ClientError as e:
                if e.response['Error']['Code'] == 'InvalidInstanceID.NotFound':
                    print(f"Instance id: {instance_id} no longer exists")
                    continue
    print()

