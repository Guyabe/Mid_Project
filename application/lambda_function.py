import boto3
import time

ssm_client = boto3.client('ssm')

def lambda_handler(event, context):
    # Retrieve environment variables if instance_id or container_id is dynamic
    instance_id = "i-064b4c13d50f9a0c6"  # Replace or retrieve from event/env if dynamic
    container_id = "5fed5cab9bbb"  # Replace or retrieve from event/env if dynamic
    command = f"docker exec {container_id} python3 /home/ec2-user/app.py -provide_recommendation"

    # Step 2: Send the command to the EC2 instance via SSM
    try:
        response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName="AWS-RunShellScript",
            Parameters={'commands': [command]},
        )
        command_id = response['Command']['CommandId']
        print(f"Command sent to EC2 instance {instance_id} with Command ID: {command_id}")
    except Exception as e:
        print(f"Error sending command: {e}")
        return {
            'statusCode': 500,
            'body': 'Error sending command to EC2 instance'
        }

    # Step 3: Wait for the command to complete
    while True:
        time.sleep(2)
        result = ssm_client.get_command_invocation(
            CommandId=command_id,
            InstanceId=instance_id
        )
        if result['Status'] in ('Success', 'Failed', 'Cancelled', 'TimedOut'):
            break

    # Step 4: Get the output of the command
    try:
        output = result['StandardOutputContent']
        print("Command output:")
        print(output)
        return {
            'statusCode': 200,
            'body': output
        }
    except Exception as e:
        print(f"Error fetching command output: {e}")
        return {
            'statusCode': 500,
            'body': 'Error fetching command output'
        }
