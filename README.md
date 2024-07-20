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

   aws eks update-kubeconifig --region us-east-1 --name demo

