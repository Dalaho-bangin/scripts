if [[ $# -eq 0 ]];
then
    echo "Enter domain target "
    echo "ex: bash ~/script/hunt https://admin.snapp.ir snapp.ir"
    exit 1
fi
url=$1
target=$2
domain=`echo "$url" | unfurl  domains `
domainPath=`echo "$url" | unfurl domains | sed 's/\./_/g' `

if [ ! -d "~/recon/$target/$domainPath" ];then
        mkdir ~/recon/$target/$domainPath
fi
if [ ! -d "~/recon/$target/$domainPath/Vulnerability" ];then
        mkdir ~/recon/$target/$domainPath/Vulnerability
fi

echo $url
echo $domain
echo $domainPath


echo -e "\e[1;32m[+] Gathering JS Files ) \e[0m"
rm -rf  /tmp/js1.txt /tmp/js2.txt /tmp/js3.txt /tmp/js4.txt /tmp/subjs.txt  /tmp/subjs-$domainPath.txt /tmp/xurl-js.txt
xurlfind3r -d $domain | grep -iE '\.js' > /tmp/xurl-js.txt
waybackurls $url | grep -iE '\.js'| grep -iEv '(\.jsp|\.json)' > /tmp/js1.txt 
gau $url | grep -iE '\.js'| grep -iEv '(\.jsp|\.json)' > /tmp/js2.txt
echo "$url" | hakrawler  | grep -iE '\.js' | grep -iEv '(\.jsp|\.json)' > /tmp/js3.txt 
katana -u $url | grep -iE '\.js' | grep -iEv '(\.jsp|\.json)' > /tmp/js4.txt 
echo $url  > /tmp/subjs-$domainPath.txt
subjs -i  /tmp/subjs-$domainPath.txt | tee -a /tmp/subjs.txt 
cat /tmp/xurl-js.txt /tmp/js1.txt /tmp/js2.txt /tmp/js3.txt /tmp/js4.txt /tmp/subjs.txt | grep -v "bootstrap.min.js" | grep -Ev  "bootstrap[a-zA-Z0-9_-]+\.js"| grep -v "jquery.min.js" | grep -v "popper.min.js" |grep -v "plugins" | grep -v  "themes" |grep -v "jquery.js"| grep -Ev "jquery[a-zA-Z0-9_-]+"| grep -Ev "jquery.[a-zA-Z0-9_-]+" | grep -v "/wp-includes/" |  tee -a ~/recon/$target/$domainPath/Vulnerability/js-files.txt
rm -rf  /tmp/js1.txt /tmp/js2.txt /tmp/js3.txt /tmp/js4.txt /tmp/subjs.txt  /tmp/subjs-$domainPath.txt /tmp/xurl-js.txt
echo ""
