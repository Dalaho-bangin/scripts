#!/bin/bash

if [[ $# -eq 0 ]];
then
    exit 1
fi


url=$1

if [ ! -d "~/recon/$url/nuclei" ];then
        mkdir ~/recon/$url/nuclei
fi

echo -e "\e[1;32m[+] Vulnerability Scanning - Nuclei :) \e[0m"
nuclei -up
cat ~/recon/$url/subdomains/httprobe | nuclei -severity high -rl 100 -c 10 -o ~/recon/$url/nuclei/nuclei_high.txt;
cat ~/recon/$url/subdomains/httprobe | nuclei -severity critical -rl 100 -c 10 -o ~/recon/$url/nuclei/nuclei_critical.txt;
cat ~/recon/$url/subdomains/httprobe | nuclei -tags cves -rl 100 -c 10 -o ~/recon/$url/nuclei/nuclei_cves.txt
echo ""
