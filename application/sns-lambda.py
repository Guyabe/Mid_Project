import boto3
import time

# Set up boto3 client for SSM
ssm_client = boto3.client('ssm')

def lambda_handler(event, context):
    # Step 1: Define the EC2 instance ID and the Docker command to run
    instance_id = "<YOUR-EC2-INSTANCE-ID>"  # Replace with your actual EC2 instance ID
    container_id = "bd4044b7a52d"  # Replace with your running container ID
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
    time.sleep(10)  # Wait for the command to finish (can adjust based on execution time)

    # Step 4: Get the output of the command
    try:
        output = ssm_client.get_command_invocation(
            CommandId=command_id,
            InstanceId=instance_id
        )
        # Print the command output
        print("Command output:")
        print(output['StandardOutputContent'])
        return {
            'statusCode': 200,
            'body': output['StandardOutputContent']
        }
    except Exception as e:
        print(f"Error fetching command output: {e}")
        return {
            'statusCode': 500,
            'body': 'Error fetching command output'
        }
