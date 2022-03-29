#!/bin/bash
#---------------------------------------------------------------------------------------------#
# This script is used for the configuration of kubectl 
#---------------------------------------------------------------------------------------------#
#Check if kubectl is already configured
if ! command -v kubectl &> /dev/null
then
        echo "kubectl could not be found"
        echo "Do you want to download specific version y/n"
        read answer
        if [ $answer == "y" ];
        then
                echo "Please provide version number" ;
                read version ;
                #append v in fron of version if not added ;
                echo $version | grep -v "v" && version=v$version ; 
                # Download kubectl exectuable ;
                curl -LO "https://dl.k8s.io/release/$version/bin/linux/amd64/kubectl" ;
                # Download kubectl checksum ;
                curl -LO "https://dl.k8s.io/$version/bin/linux/amd64/kubectl.sha256" ;
        else
                echo "Downloadng latest of the kubectl" ;
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" ;
                curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" ;
        fi
        # Chekcsum match
        echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check | grep "OK" > /dev/null ;
        if [ $? -eq 0 ] ;
        then 
                sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        else 
                echo "Kindly confirm version from https://kubernetes.io/releases/ or check connectivity" ;
        fi
else
        echo "Kubectl is already configured"
        exit
fi
