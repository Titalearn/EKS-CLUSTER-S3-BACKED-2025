# This is an updated Eks-cluster script.

  - make sure you provision yor vpc cluster first,provision your eks cluster and next provision your autoscaler.

 - This repository equally contains the script to add users in your EKS cluster
 
 - While creating your eks cluster,remember the user creating this cluster will be the admin.So you can add a profile in the eks directory if you wish to use another aws profile to create this account.


# Follow this steps to set up your .kube and kubernetes in your environment (Window users)

- To install kubectl on Windows you can use either Chocolatey package manager or any other package manager for windows.
  so make sure choco is install in windows.
  
- now run this commands below

  You can go to the kubernetes official ducumentation to get the updated commands in case this commands below are outdated
  https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
  
  1 choco install kubernetes-cli
  
  2 kubectl version --client
  
  3 If you're using cmd.exe, run: cd %USERPROFILE%

  4 mkdir .kube

  5 cd .kube

  6 New-Item config -type file

# The following commands will be used
- This command shows you which users is currently making api calls in your cli
  
   aws sts get-caller-identity

 - This command updates your kubeconfig with the current cluster your using.Remember to change the region to your current region and to change the demo to your cluster name.

   aws eks update-kubeconfig --region us-east-1 --name demo

- Next run the following command to see all your clusters added and your current context.If you dont have the command working on your teminal then install it using choco. Choco install kubectx

  kubectx

- Next run the following commands to get nodes.

  Kubectl get nodes

- If the previous command says Unauthorized then you need to login to the account that created this profile or any user that has access to this cluster. You can use environmental variables to export the secret key and access key of the profile as seen below

$env:AWS_ACCESS_KEY_ID="your_access_key_here"
  
$env:AWS_SECRET_ACCESS_KEY="your_secret_access_key_here"

$env:AWS_DEFAULT_REGION="your_region_here"

             or
             
set AWS_ACCESS_KEY_ID=your_access_key_here

set AWS_SECRET_ACCESS_KEY=your_secret_access_key_here

set AWS_DEFAULT_REGION=your_region_here


  run this command to check if the caller is now your user  "aws sts get-caller-identity"

  now update the cluster again.Change the region and cluster name to your own "aws eks update-kubeconfig --region us-east-1 --name demo"
  
# How to add users in your EKS cluster
creating cluster roles and clusterrolebinding

The script for users main.tf is creating two user,developer 1 and manager.

A developer group and a managers group is been created.


# Step by step to add users in your eks cluster

provision the first script called role.yaml (this will create roles in your cluster.You can always add more roles.

cd in to users and run the following commands

kubectl create -f role.yaml

kubectl create -f rbac.yaml

kubectl describe clusterrole reader.

- next you will need to generate a pgp_key  https://sl.bing.net/kMwZbOzuLWC

  click on the link above to follow the following steps

next go to pgp key and change what you fine in main.tf and replace with your own. e.g keybase:lavet to keybase:james

make sure its same user name for your keybase profile.

- Next configure a user profile for all the users you created.

  aws configure --profile developer

- Now lets add the developer in our eks cluster. You must edit the aws-auth

  kubectl edit -n kube-system cm aws-auth

- Once you run the above command it will open an edit page for your aws-auth

below the data line add this mapUsers: |
    - userarn: arn:aws:iam::654654187689:user/developer
      username: developer
      groups:
      - reader

- next stage update kubeconfig. change the profile

  aws eks update-kubeconfig --name demo --profile developer --region us-east-1

- check if the new profile ( developer) is added to config

  kubectl config view --minify

- Use tthe following command to check the permisions of the user. change the pod to other resources like secrets ,create and other to see the permissions that user has.

  kubectl auth can-i get pod

- To go back to your default profile that created the cluster or admin run the following command.

  aws eks update-kubeconfig --name demo --region us-east-1

  # How to add a manager to the cluster

  -make sure you have created roles for your manager

    Go to aws and create access and secret access for your manager.

  -Configure a profile for the manager with the following command

    aws configure --profile manager

  -Add the  access key and secret access key

    example access key  -------    exmple secret access key -------    Add them with your region
  -cd in to .aws and cat credentials to make sure the manager credentials exist.

    next run the following command " cat config " you will notice  a manager profile has been created.
    
-Next we need to add a role which the manager will use
 
    vi config

    scroll down to profile manager and add this

    role_arn = copy the role on aws and type here. \

    add also below "source_profile = manager"  change to your own profile

-Next we need to edit the configmap aws-auth
 
    " kubectl edit -n kube-system cm aws-auth "  next you will see map roles add the rolearn,username,groups,system:masters

   // mapRoles: |
         - rolearn : arn:aws:iam::654654187689:role/Manager-eks-Role
           username : manager
           groups:
           - system:masters //

  -Now lets switch to the managers profile and see what we can do

       aws eks --region us-east-1 update-kubeconfig --name demo --profile manager

  -Next run this command to see if your master can get anything withing the cluster
 
       kubectl auth can-i "*" "*"

  -Next run the following command to know the profile making the commands

       kubectl config view --minify

     

      

