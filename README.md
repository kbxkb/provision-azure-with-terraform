# provision-azure-with-terraform

Provision Azure with Terraform (https://terraform.io/)
=======================================================

First, set up your development box to use terraform (These steps assume that your development box is Ubuntu, it can as well be your Azure Ubuntu development VM):

1. Install Go 1.5 (Terraform requires Golang 1.4+)
2. Set up environment variable GOROOT and add $GOROOT/bin to $PATH

[Steps 1 and 2 are shown here, but such instruction can get out of date quickly, so please make sure that you are using the latest information: http://munchpress.com/install-golang-1-5-on-ubuntu/]

3. Set up GOPATH - create a directory (e.g., "go") in your home directory, and then add this environment variable: [export GOPATH=$HOME/work]. Add it permanently via ~/.bashrc of equivalent means
4. Add $GOPATH/bin to your $PATH. Do not worry about creating the bin subdirectory right now, just update your PATH environment variable, including permanent modification tactics like ~/.bashrc
5. install git and mercurial - https://confluence.atlassian.com/bitbucket/set-up-git-and-mercurial-ubuntu-linux-269982882.html
6. cd $GOPATH; mkdir src; cd src; mkdir github.com; cd github.com; mkdir hashicorp; cd hashicorp
7. Clone terraform reporsitory (https://github.com/hashicorp/terraform) here: git clone https://github.com/hashicorp/terraform.git
8. cd terraform
9. make updatedeps (if you are using a new Azure Ubuntu VM as your development box, you will have to first run "sudo apt-get install make"
10. make
11. make dev (this will create the "terraform" binary in the bin subdirectory)
12. Add "$GOPATH/src/github.com/hashicorp/terraform/bin/" to $PATH so that you can run terraform from anywhere. If you are using an Azure Ubuntu Linux VM as your dev box, doing this is easy as running the command "ln -s $GOPATH/src/github.com/hashicorp/terraform/bin/ ~/bin" and then logging out and logging back in
 

Now, you are ready to use the code in this reporsitory
=======================================================

1. git clone this repository
2. Download your subscription's publishsettings file: https://manage.windowsazure.com/PublishSettings/index?Client=&SchemaVersion=&DisplayTenantSelector=true
3. if the publishsettings file is not on your Ubuntu dev box, scp it over to your Ubuntu development box
4. Have an environment variable AZURE_SETTINGS_FILE, and set its value as the full path of your publishsettings file. Note: if the publishsettings file path or name has spaces in it, it is better to rename it such that there are no spaces. Make the enviornment variable permanent using ~/.bashrc or similar techniques
5. First try the starter kit:
    cd provision-azure-with-terraform/azureterraformstarter
    terraform plan
    (From here on, go ahead and learn other commands from https://terraform.io/docs/index.html, and modify the tf file. Run 'terraform apply', 'terraform destroy' etc.)
6. You can try the other sample which creates a more complex setup - a virtual network, a security group, a storage account, a security-group-rule, a cloud service, an Ubuntu virtual machine in that cloud service and virtual network, and uses the terraform 'file' and 'remote-exec' provisioners to execute a shell script on the VM that is created - in this example, the shell script sends an email to certain recipients
7. NOTE: The sample will not work straight away because I have taken out perosnally identiable email account details from it and replaced it with generic placeholders. Make these changes to make it work:
    a) aaa



