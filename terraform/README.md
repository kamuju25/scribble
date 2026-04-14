## Install terraform on ec2 machine

for ubuntu - refer to [terraform-install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Ensure that your system is up to date and that you have installed the gnupg and software-properties-common packages. You will use these packages to verify HashiCorp's GPG signature and install HashiCorp's Debian package repository.

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```
Install HashiCorp's GPG key.

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```
Verify the GPG key's fingerprint.

```bash
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
```

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Update apt to download the package information from the HashiCorp repository.

```bash
sudo apt update
```

Install Terraform from the new repository.
```bash
sudo apt-get install terraform
```

Terraform needs permission to talk to AWS before it can create any resources. To give permission, you must provide your AWS credentials (Access Key and Secret Key).

  - First, log in to your AWS account using an IAM user (recommended) or root user.
  - Go to Security Credentials and create Access Keys for CLI usage.

<img width="927" height="740" alt="image" src="https://github.com/user-attachments/assets/c4900f19-5659-44f5-baa9-177170cf2074" />

  - Scroll down to `Accesskeys` section and click on `Create access key` and select use case `Command Line Interface (CLI)  
  - Save these keys safely because they are very sensitive.
  - Next, install the `AWS CLI` [awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) on your local machine 
  - After installation, run the command `aws configure`.

    Enter your:
      - Access Key
      - Secret Key
      - Region (like us-east-1)

  - Once configured, AWS CLI creates a hidden folder called `.aws` on your system.
  - Inside this folder, there is a credentials file that stores your keys.
  - Terraform automatically reads this credentials file.
  - Using these credentials, Terraform can make API calls to AWS.
  - Then Terraform can create resources like VPC, ECS, etc.