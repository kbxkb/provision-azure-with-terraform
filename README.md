
Provision Azure with Terraform (https://terraform.io/)
=======================================================

First, set up your development box to use terraform (These steps assume that your development box is Ubuntu, it can as well be your Azure Ubuntu development VM):

[Steps 1 and 2 below are discussed in more detail here: http://munchpress.com/install-golang-1-5-on-ubuntu/
But such instruction can get out of date quickly, so please make sure that you are using the latest information]

1. Install Go 1.5 (Terraform requires Golang 1.4+)
2. Set up environment variable GOROOT and add $GOROOT/bin to $PATH
3. Set up GOPATH - create a directory (e.g., "go") in your home directory, and then add this environment variable: [export GOPATH=$HOME/go]. Add it permanently via ~/.bashrc or equivalent means
4. Add $GOPATH/bin to your $PATH. Do not worry about creating the bin subdirectory right now, just update your PATH environment variable, including permanent modification tactics like ~/.bashrc
5. install git and mercurial - https://confluence.atlassian.com/bitbucket/set-up-git-and-mercurial-ubuntu-linux-269982882.html
6. cd $GOPATH; mkdir src; cd src; mkdir github.com; cd github.com; mkdir hashicorp; cd hashicorp
7. Clone terraform reporsitory (https://github.com/hashicorp/terraform) here: git clone https://github.com/hashicorp/terraform.git
8. cd terraform
9. make updatedeps (if you are using a new Azure Ubuntu VM as your development box, you will have to first run "sudo apt-get install make". Also note this step will create the required directory structure inside GOPATH and download all the GO libraries that terraform depends on)
10. make
11. make dev (This step is for developers only - those who want to change terraform code and build terraform from their changes. I am assuming an audience who would love to do that, hence including it here. This will also create the "terraform" binary, along with a hoard of other useful binaries, in the bin subdirectory)
12. Add "$GOPATH/src/github.com/hashicorp/terraform/bin/" to $PATH so that you can run terraform from anywhere. If you are using an Azure Ubuntu Linux VM as your dev box, doing this is easy - just run the command "ln -s $GOPATH/src/github.com/hashicorp/terraform/bin/ ~/bin" and then log out and log back in
 

Now, you are ready to use the code in this repository
=======================================================

1. Download your subscription's publishsettings file: https://manage.windowsazure.com/PublishSettings/index?Client=&SchemaVersion=&DisplayTenantSelector=true
2. if the publishsettings file is not on your Ubuntu dev box, scp/ copy it over to your Ubuntu development box
3. Have an environment variable AZURE_SETTINGS_FILE, and set its value as the full path of your publishsettings file. Note: if the publishsettings file path or name has spaces in it, it is better to rename it such that there are no spaces. Make the enviornment variable permanent using ~/.bashrc or similar techniques
4. First try the starter kit (which just creates an azure storage account):
 * git clone this repository
 * cd provision-azure-with-terraform/azureterraformstarter
 * terraform plan
 * (From here on, go ahead and learn other commands from https://terraform.io/docs/index.html, and modify the tf file as necessary. Run 'terraform apply', 'terraform destroy' etc.)
5. If you try the other sample which creates a more complex setup (azureterraformsample directory), IT WILL NOT WORK STRAIGHT OUT OF THE BOX UNLESS YOU MAKE THE CHANGES DESCRIBED IN THE NEXT BULLET (because I have taken out perosnally identiable email account details from it and replaced it with generic placeholders). This sample creates a virtual network, a security group, a storage account, a security-group-rule, a cloud service, an Ubuntu virtual machine in that cloud service and inside the virtual network, and uses the terraform 'file' and 'remote-exec' provisioners to execute a shell script on the VM that is created - in this example, the shell script sends an email to certain recipients
6. NOTE: The sample will not work straight away because I have taken out perosnally identiable email account details from it and replaced it with generic placeholders. Make these changes to make it work:
 * a) (assuming that you git cloned and are currently inside the directory 'provision-azure-with-terraform') cd azureterraformsample
 * b) Edit sample.tf, search for "send-email", and on the line that executes the send-email.sh script, provide one or more real destination email addresses instead of 'your-email-one@your-domain.com' and 'your-email-two@your-domain.com'
 * c) Edit scripts/send-email.sh: replace {{your sender gmail address ending with @gmail.com}} with the correct sending gmail address (like testaccount@gmail.com) and replace {{password for your sender gmail account}} with the password for that gmail account. While replacing, make sure you replace the curly brackets as well! If you want, you can use an yahoo email account instead of gmail, just replace the "smtp.gmail.com:587" with "smtp.mail.yahoo.com:587", and use the yahoo email address and password instead of the gmail account credentials
7. If you make the above changes and then run 'terraform apply', you should be able to provision the resources described above and get an email to your destination email address notifying you that your linux VM is up and running!
8. A note about the sample setup: The sample setup creates a cloud service (hosted service) first. Actually, even if you do not create a cloud service first, directly creating an Azure Linux VM using terraform creates a cloud service for the VM anyway - in that case the name of the cloud service becomes same as the VM name. However, my goal with the sample was to create a load-balanced set of N VM-s behind a single cloud service. Therefore, I created the cloud service first, and my plan was to create and add VM-s to the cloud service. However, my plan was thwarted because of this bug: https://github.com/hashicorp/terraform/issues/3568. Due to this bug, you currently cannot add a 2nd or 3rd or Nth VM to an existing cloud service (you can add the 1st VM no problem). Therefore, my sample TF file only adds one VM. It also has a commented out block which shows how we *would have* added N VM-s if the bug were to get fixed!
9. A 2nd note on the sample: There is commented out code at the end that attempts to add a data disk to the VM that we created. It is commeted out because of this bug: https://github.com/hashicorp/terraform/issues/3428. We can use that block when the bug gets fixed.

Notes: This is to just get one started with terraform and azure. There are a lot of azure resources being developed, and this tutorial only touches on a basic set of these.

