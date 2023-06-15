if [[ $# -eq 0 ]];
then
    echo "Enter domain target "
    echo "ex: bash ~/script/hunt https://admin.snapp.ir snapp.ir"
    exit 1
fi
url=$1
target=$2
domainPath=`echo "$url" | unfurl domains | sed 's/\./_/g' `

if [ ! -d "~/recon/$target/$domainPath" ];then
        mkdir ~/recon/$target/$domainPath
fi
if [ ! -d "~/recon/$target/$domainPath/Vulnerability" ];then
        mkdir ~/recon/$target/$domainPath/Vulnerability
fi

echo -e "\e[1;32m[+] Hidden Dirs  ) \e[0m"
python3 ~/tools/dirsearch/dirsearch.py -u $url -e conf,config,bak,backup,swp,old,db,sql,asp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip,log,xml,js,json --deep-recursive --force-recursive --exclude-sizes=0B --random-agent --full-url -o ~/recon/$target/$domainPath/Vulnerability/dirsearch.txt
echo ""
