import boto3, json

client = boto3.client('sns')

def lambda_handler(event, context):

    for record in event["Records"]:

        if record['eventName'] == 'INSERT':
            new_record = record['dynamodb']['NewImage']    
            response = client.publish(
                TargetArn='arn:aws:sns:us-east-1:538578370232:POC-Topic', #THIS ARN MUST BE CHANGED.
                Message=json.dumps({'default': json.dumps(new_record)}),
                MessageStructure='json'
            )
