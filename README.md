# Neubank Loan Calculator Infrastructure
Azure 3 tier app project
This will deploy a frontend web server, a backend API server, Redis Cache (disabled due to creation time), SQL server, and blob storage.


# Reference Architecture
![image](https://github.com/Jim-Lentz/neubank/assets/52187407/e6b875f7-68fa-43ec-b6aa-9fc74eaa3b78)

# To Do
1. Add test environment
2. Add more perimeter protection such as a WAF
3. Add repo security scanning such as chekov or similar scanning tool

When adding features, create a dev branch. When pushing dev a new environment will build.
When ready for prod merge dev to prod and Github actions will add the new features.

### Create banch
git branch dev 
git checkout dev

### Make changes and push back to dev to cause GitHub Actions to deploy
git add . 
git commit -m "Your commit message"
git push origin dev

### When ready to promote to prod run the following
git checkout main 
git merge dev 
git push origin main

## If running from the command line
### Dev environment
terraform init -backend-config=key=dev-terraform.tfstate
terraform plan -var-file="./dev.tfvars"
terraform apply -var-file="./dev.tfvars"

### Prod environment
terraform init -backend-config=key=prod-terraform.tfstate
terraform plan -var-file="./prod.tfvars"
terraform apply -var-file="./prod.tfvars"



# Azure DevOps Boards
![image](https://github.com/Jim-Lentz/neubank/assets/52187407/9a8571f8-d97e-4df5-a280-16b292bdb6ba)

## CSV of DevOps board
ID,Work Item Type,Title,Assigned To,State,Area Path,Tags,Comment Count
"18","User Story","As an engineer I want to create a module for the backend api server","Jim Lentz <jimlentzaz-104@example.com>","Resolved","Neubank1",,"0"
"19","User Story","As an engineer I want to create a module for the database","Jim Lentz <jimlentzaz-104@example.com>","Resolved","Neubank1",,"0"
"17","User Story","As an engineer I want to create a module for the front end web service","Jim Lentz <jimlentzaz-104@example.com>","Resolved","Neubank1",,"0"
"23","User Story","Make repo public",,"New","Neubank1",,"0"
"22","User Story","Cleanup and update documentation","Jim Lentz <jimlentzaz-104@example.com>","Active","Neubank1",,"0"
"20","User Story","As an engineer I want to create a module for the redis cache","Jim Lentz <jimlentzaz-104@example.com>","Resolved","Neubank1",,"0"
"16","User Story","As an engineer I want to create a module for App Insights","Jim Lentz <jimlentzaz-104@example.com>","Resolved","Neubank1",,"0"
"15","User Story","As an Engineer I want to create the networking module","Jim Lentz <jimlentzaz-104@example.com>","Resolved","Neubank1",,"0"
"14","User Story","As an engineer I want to develop the module structure for Terraform","Jim Lentz <jimlentzaz-104@example.com>","Resolved","Neubank1",,"0"
"21","Epic","Closeout",,"New","Neubank1",,"0"
"13","Epic","Build Terraform Scripts",,"New","Neubank1",,"0"
"8","Epic","Setup Environment",,"New","Neubank1",,"0"
