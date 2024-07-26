module AwsUtils

  def get_branch 
    puts "Enter branch name to continue or type 'exit' to abort..."
    input = STDIN.gets.chomp  # Capture input and remove any trailing newline

    if input.downcase == 'exit'
      puts "Task aborted by the user."
      exit 1  # Exit the task with a non-zero status to indicate failure or abortion
    else
      puts "Continuing with the task..."
      return input # this is the branch to be deployed
      # Place the rest of your task logic here
    end
  end

    def to_label(name)
    "#{name}-#{Time.now.strftime('%Y-%m-%d-%H.%M.%S')}"
    end

    def update_rails_credentials(rails_env, key, value)
        raise "Please provide a key and a value. Usage: rake credentials:update[key,value]" unless key && value

        puts "Updating credentials for Rails.env = #{rails_env}, key = #{key}, value = #{value}"

        # Decrypt the existing credentials
        encrypted_content = File.read(Rails.root.join('config', 'credentials', "#{rails_env}.yml.enc"))
        master_key = File.read(Rails.root.join('config', 'credentials', "#{rails_env}.key")).strip
        decryptor = ActiveSupport::MessageEncryptor.new([master_key].pack("H*"), cipher: 'aes-128-gcm')
        credentials = YAML.load(decryptor.decrypt_and_verify(encrypted_content))

        # Update the credentials
        credentials[key] = value

        # Encrypt and save the credentials
        encrypted_data = decryptor.encrypt_and_sign(YAML.dump(credentials))
        File.open(Rails.root.join('config', 'credentials', "#{rails_env}.yml.enc"), 'wb') { |file| file.write(encrypted_data) }

        puts "Credentials updated successfully for Rails.env = #{rails_env}, key = #{key}."

    end

    def update_env_file(file_path, key, new_value)
        # Read all the lines of the file into an array
        lines = File.readlines(file_path)
        
        # A flag to track whether the key was found and updated
        key_found = false
      
        # Update the line containing the key, if it exists
        updated_lines = lines.map do |line|
          if line.strip.start_with?("#{key}=")
            key_found = true
            "#{key}=#{new_value}\n"  # Replace the existing line with the new key value
          else
            line  # Keep the existing line as is
          end
        end
      
        # Append the new key-value pair if the key was not found
        updated_lines << "#{key}=#{new_value}\n" unless key_found
      
        # Write the updated lines back to the file
        File.open(file_path, 'w') { |file| file.puts(updated_lines) }
    end
      

    def replace_ip_addresses(file_path, new_ips)
        puts "Replacing IP addresses #{new_ips} in file: #{file_path}"
        # Read the file content
        content = File.read(file_path)
        
        # Find and replace IP addresses
        ip_index = 0
        updated_content = content.gsub(/server "(\d+\.\d+\.\d+\.\d+)"/) do
            "server \"#{new_ips[ip_index]}\"".tap { ip_index += 1 if ip_index < new_ips.size }
        end
        
        # Check if all IPs have been used; if not, raise an error
        if ip_index < new_ips.size
            puts "Not all new IPs were used. Please check the number of server entries and the number of provided IPs."
        end
        
        # Write the updated content back to the file
        File.write(file_path, updated_content)
        puts "IP addresses replaced successfully in file: #{file_path}"
    end


  def run_cmd(command)
    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        # Handle stdout
        while line = stdout.gets
          puts line
        end
    
        # Optionally, you can handle errors by reading from stderr:
        while err_line = stderr.gets
          puts "Error: #{err_line}"
        end
    
        # Wait for the command to complete and fetch the exit status
        exit_status = wait_thr.value
        unless exit_status.success?
          raise "Command failed with status (#{exit_status.exitstatus})"
        end
    end    
  end

  def cleanup_amis(name_tag, region)
    puts "Cleaning up old AMIs with name: #{name_tag} in region: #{region}"
    Aws.config.update({ region: })

    ec2 = Aws::EC2::Client.new

    amis = ec2.describe_images({
      owners: ['self'],
      filters: [
        { name: "tag:Name", values: [name_tag] }
      ]
    }).images.sort_by { |ami| ami.creation_date }

    puts "Found #{amis.length} AMIs with name: #{name_tag}. Retaining 10"

    # Retain the last 10 AMIs, delete the rest
    number_to_keep = 5
    if amis.length > number_to_keep
      puts "Deleting #{amis.length - number_to_keep} old AMIs"
      amis_to_delete = amis[0...(amis.length - number_to_keep)]
    else
      puts "No old AMIs to delete"
      amis_to_delete = []  # Nothing to delete if there are fewer than or exactly 7 AMIs
    end

    amis_to_delete.each do |ami|
      begin
        ec2.deregister_image(image_id: ami.image_id)
        puts "Deregistered old AMI: #{ami.image_id} with name: #{ami.name}"
      rescue Aws::EC2::Errors::ServiceError => e
        puts "Failed to deregister AMI: #{ami.image_id}. Error: #{e.message}"
      end
    end
  end

  def create_ami_from_snapshot(args)
    puts "Creating AMI from instance: #{args}"
    ami_id = nil
    ec2 = Aws::EC2::Resource.new
    ec2_client = Aws::EC2::Client.new

    instance = ec2.instances(filters: [
      { name: 'tag:Name', values: [args[:instance_name]] },
      { name: 'instance-state-name', values: ['running'] }
    ]).first

    if instance
      puts "Found instance: #{instance.id} for name: #{args[:instance_name]}"
      # Get the volume ID associated with the instance
      volume_id = instance.block_device_mappings[0].ebs.volume_id

      # Create EBS snapshot
      resp = ec2.create_snapshot({
        description: "Snapshot of #{to_label(args[:instance_name])}",
        volume_id: volume_id  # Specify the volume ID of the instance
      })
  
      snapshot_id = resp.snapshot_id
  
      puts "Snapshot created: #{snapshot_id}"
      # Wait for snapshot completion
      ec2_client.wait_until(:snapshot_completed, snapshot_ids: [snapshot_id]) do |w|
        w.max_attempts = 30  # Adjust max attempts and delay as needed
        w.delay = 40
      end
      ec2.create_tags({
        resources: [snapshot_id],
        tags: [
          { key: 'Name', value: args[:instance_name] }
        ]
      })
      puts "Snapshot completed: #{snapshot_id} with name: #{args[:instance_name]}"

      ami_name = "#{to_label(args[:instance_name])} - #{Aws.config[:region]}"
      # Create AMI from snapshot
      ami_resp = ec2.register_image({
        name: ami_name,
        architecture: 'x86_64',
        root_device_name: '/dev/sda1', # Add this line
        block_device_mappings: [
          {
            device_name: '/dev/sda1',
            ebs: {
              snapshot_id: snapshot_id,
              volume_type: 'standard'
            }
          }
        ]
      })
  
      ami_id = ami_resp.image_id

      ec2.create_tags({
        resources: [ami_id],
        tags: [
          { key: 'Name', value: args[:instance_name] }
        ]
      })
      puts "AMI created: #{ami_id} with name: #{args[:instance_name]}"
    else
      raise "No instances found with name #{args[:instance_name]}"
    end

    ami_id
  end

  def copy_ami(ami_id, destination_region)
    # This ec2_client points to the destination region
    dest_ec2_client = Aws::EC2::Client.new(region: destination_region)
    source_ec2_client = Aws::EC2::Client.new()

    
    # Get the name tag of the source AMI
    source_ami = source_ec2_client.describe_images(image_ids: [ami_id]).images.first
    source_ami_name_tag = source_ami.tags.find { |tag| tag.key == "Name" }&.value

    puts source_ami_name_tag
    # Start the copy process from the source region
    copy_response = dest_ec2_client.copy_image({
      source_image_id: ami_id,
      source_region: source_ec2_client.config.region,
      name: "Copy-#{ami_id}"
    })

    dest_ec2_client.create_tags({
      resources: [copy_response.image_id],
      tags: [
        { key: 'Name', value: source_ami_name_tag }
      ]
    })

    puts "AMI copy started, New AMI ID: #{copy_response.image_id} in region #{destination_region}"

    # Wait for the AMI to be available
    dest_ec2_client.wait_until(:image_available, image_ids: [copy_response.image_id]) do |w|
      w.max_attempts = 20
      w.delay = 120
      puts "Waiting for AMI to be available..."
    end

    puts "AMI copy completed: #{copy_response.image_id} in region #{destination_region}"
    
  end

  def latest_ami(name_tag, region)
    puts "Getting latest AMI with name: #{name_tag} in region: #{region}"
    Aws.config.update({ region: })

    ec2 = Aws::EC2::Client.new

    latest_ami = ec2.describe_images({
      owners: ['self'],
      filters: [
        { name: "tag:Name", values: [name_tag] }
      ]
    }).images.sort_by { |ami| ami.creation_date }.last

    puts "Latest AMI found: #{latest_ami.image_id} with name: #{latest_ami.name}, date: #{latest_ami.creation_date}"
    latest_ami
  end

  def setup_pulumi_config(stack, web_server_name, db_server_name, region)
    pulumi_config = {
      "IRM-infra:#{region}_web_server_ami" => latest_ami(web_server_name, region).image_id,
      "IRM-infra:#{region}_db_server_ami" => latest_ami(db_server_name, region).image_id
    }

    pulumi_config.each do |key, value|
      puts "Setting pulumi config: #{key} => #{value}"
      `cd ../IRM-infra; pulumi config set --stack #{stack}-#{region} #{key} #{value}`
    end

    `cd ../IRM-infra; pulumi config set --stack #{stack}-#{region} region #{region}`    
  end

  def setup_infra(stack, web_server_name, db_server_name, region)    
    setup_pulumi_config(stack, web_server_name, db_server_name, region)
    puts "Running pulumi up for stack: #{stack}. (This could take a long time, please be patient)"
    # Run pulumi to setup the aws infra
    run_cmd("cd ../IRM-infra; pulumi up --stack #{stack}-#{region} --yes --color=always")
    # Get the pulumi output
    puts "Getting pulumi output"
    pulumi_output = JSON.parse(File.read "../IRM-infra/output.json")
    pulumi_output.each do |key, value|
      puts "Got pulumi output: #{key} => #{value}"
    end

    # Update the Rails credentials
    ["DB_HOST", "DB_HOST_REPLICA"].each do |key|
      rails_env = stack
      value = pulumi_output["private_ips"][key]
      update_rails_credentials(rails_env, key, value)
    end

    elastic_url = pulumi_output["private_ips"]["DB_HOST"] #pulumi_output["private_ips"]["ELASTIC_SEARCH_URL"]
    update_env_file(".env.#{stack}", "ELASTIC_SEARCH_URL", "#{elastic_url}:9200")
    redis_url = pulumi_output["private_ips"]["DB_HOST"] #pulumi_output["private_ips"]["REDIS_URL"]
    update_env_file(".env.#{stack}", "REDIS_URL", "redis://#{redis_url}:6379")

    # Update the deploy files with the new IP addresses
    replace_ip_addresses(Rails.root.join('config', 'deploy', "#{stack}.rb"), pulumi_output["public_ips"]["AppServers"][0])
    puts "\n#######################"
    puts "You need to commit your code, with the updated credentials, .env and deploy files, before deploying the app."
    puts "Please enter branch name to deploy to continue once you have committed the code."
    puts "#########################"
    branch_name = get_branch

    # Deploy the app
    run_cmd("branch=#{branch_name} LB=true bundle exec cap #{stack} recovery:delete_old_assets")
    run_cmd("branch=#{branch_name} LB=true bundle exec cap #{stack} deploy")
    # Load the DB from backups and create the replica
    run_cmd("branch=#{branch_name} bundle exec cap #{stack} recovery:load_db_from_backups")
  end

end