provider "azure" {
}

# ---------------------------------------------------------------------
# VIRTUAL NETWORK
# ---------------------------------------------------------------------

resource "azure_virtual_network" "default" {
	name = "toplevelvnet"
	address_space = ["10.10.0.0/16"]
	location = "South Central US"

	subnet {
		name = "moduleone"
		address_prefix = "10.10.1.0/24"
	}
	subnet {
		name = "moduletwo"
		address_prefix = "10.10.2.0/24"
	}
	# ... (Add subnets for rest of the modules)
}

# ---------------------------------------------------------------------
# STORAGE ACCOUNT FOR THE VM-S
# ---------------------------------------------------------------------

resource "azure_storage_service" "storage" {
	name = "myvmstorage"
	location = "South Central US"
	description = "Made by Terraform"
	account_type = "Standard_LRS"
}

# ---------------------------------------------------------------------
# SECURITY GROUP (WILL PROVIDE ACL-S AT VM LEVEL) AND RULES
# ---------------------------------------------------------------------

resource "azure_security_group" "testnsg" {
	name = "mytestsnsg"
	location = "South Central US"
}

resource "azure_security_group_rule" "ssh_access" {
	depends_on = ["azure_security_group.testnsg"]
	name = "my-ssh-access-rule"
	security_group_names = ["${azure_security_group.testnsg.name}"]
	type = "Inbound"
	action = "Allow"
	priority = 200
	source_address_prefix = "*"
	source_port_range = "*"
	destination_address_prefix = "*"
	destination_port_range = "22"
	protocol = "TCP"
}

# ---------------------------------------------------------------------
# CLOUD SERVICE
# ---------------------------------------------------------------------

resource "azure_hosted_service" "myservice" {
    name = "my-cloud-service"
    location = "South Central US"
    ephemeral_contents = false
    description = "Hosted Cloud service created by Terraform"
    label = "tf-cs-01"
}

# ---------------------------------------------------------------------
# LOOP TO ADD MULTIPLE VM-S TO CLOUD SERVICE - COMMENTED DUE TO
# https://github.com/hashicorp/terraform/issues/3568
# ---------------------------------------------------------------------

#
#resource "azure_instance" "linux-vms" {
#	depends_on = ["azure_virtual_network.default", "azure_storage_service.storage", "azure_security_group.testnsg", "azure_hosted_service.myservice"]
#	name = "my-lin-vm-${count.index}"
#	hosted_service_name = "${azure_hosted_service.myservice.name}"
#	description = "my linux server ${count.index}"
#	image = "Ubuntu Server 14.04 LTS"
#	size = "Basic_A1"
#	subnet = "moduleone"
#	virtual_network = "${azure_virtual_network.default.name}"
#	storage_service_name = "${azure_storage_service.storage.name}"
#	location = "South Central US"
#	username = "Github123"
#	password = "Github123"
#	count = "3"
#	endpoint {
#		name = "SSH"
#		protocol = "tcp"
#		public_port = 22
#		private_port = 22
#	}
#	security_group = "${azure_security_group.testnsg.name}"
#}
#

# ---------------------------------------------------------------------
# ADDING SINGLE VM TO CLOUD SERVICE - WE WILL REPLACE THIS WITH A LOOP WHEN THE FOLLOWING BUG GETS FIXED
# https://github.com/hashicorp/terraform/issues/3568
# ---------------------------------------------------------------------

resource "azure_instance" "linux-vm-1" {
	depends_on = ["azure_virtual_network.default", "azure_storage_service.storage", "azure_security_group.testnsg", "azure_hosted_service.myservice"]
	name = "my-lin-vm-1"
	hosted_service_name = "${azure_hosted_service.myservice.name}"
	description = "my linux server"
	image = "Ubuntu Server 14.04 LTS"
	size = "Basic_A1"
	subnet = "moduleone"
	virtual_network = "${azure_virtual_network.default.name}"
	storage_service_name = "${azure_storage_service.storage.name}"
	location = "South Central US"
	username = "Github123"
	password = "Github123"
	count = "1"
	endpoint {
		name = "SSH"
		protocol = "tcp"
		public_port = 22
		private_port = 22
	}
	security_group = "${azure_security_group.testnsg.name}"

	provisioner "file" {
		source = "${path.module}/scripts"
		destination = "/tmp"
	}

	provisioner "remote-exec" {
		inline = [
			"sudo find /tmp/scripts \( -name \"*.sh\" -or -path \"*/bin/*\" \) -exec chmod +x {} +"
		]
	}

	provisioner "remote-exec" {
		inline = [
			"sudo /tmp/scripts/send-email.sh 'your-email-one@your-domain.com' 'your-email-two@your-domain.com'"
		]
	}
}

# ---------------------------------------------------------------------
# ADDING A DATA DISK TO THE ABOVE VM - COMMENTED OUT UNTIL THIS BUG GETS FIXED
# https://github.com/hashicorp/terraform/issues/3428
# [WE WILL PUT THIS IN A LOOP SO THAT IT GETS APPLIED TO THE VM-S ONCE VM-S ARE BEING CREATED IN A LOOP]
# ---------------------------------------------------------------------

# NOTES - adding a standard disk as South Central US location does not have Premium Storage yet
# NOTES - For premium storage disks, only differences are:
#       (a) Use the storage_service_name = one that was created with account_type = Premium_LRS
#       (b) size cannot be any number <= 1023 (which is the case with standard). It has to be either 128 (P10) or 512 (P20) or 1023 (P30)

#resource "azure_data_disk" "standard-storage-disk" {
#        depends_on = ["azure_instance.linux-vm-1"]
#        lun = 0
#        size = 250
#        storage_service_name = "${azure_storage_service.storage.name}"
#        virtual_machine = "${azure_instance.linux-vm-1.name}"
#}

