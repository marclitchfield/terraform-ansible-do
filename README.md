### Set environment variables

* TF_VAR_admin_user <remote_username>
* TF_VAR_admin_passwd <remote_password>
* TF_VAR_do_token <digital_ocean_api_token>
* TF_VAR_pub_key /Users/<local_username>/.ssh/id_rsa.pub
* TF_VAR_pvt_key /Users/<local_username>/.ssh/id_rsa
* TF_VAR_ssh_fingerprint <uploaded_ssh_fingerprint> 

### Run terraform

```
terraform get
terraform plan
terraform apply
```

### Configure ansible

Disable ssh host key checking in ~/.ansible.cfg

```
[defaults]
host_key_checking = False
```

Install terraform-inventory

```
brew install terraform-inventory
```


### Run ansible

```
ansible-playbook -i /usr/local/bin/terraform-inventory -u marquis ansible/playbook.yaml --sudo --ask-sudo-pass
```
