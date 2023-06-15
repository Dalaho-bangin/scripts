
url=$1
cat ~/recon/$url/subdomains/httprobe 




rm -rf  /tmp/js1.txt /tmp/js2.txt /tmp/js3.txt /tmp/js4.txt /tmp/subjs.txt t /tmp/xurl-js.txt
cat ~/recon/$url/subdomains/httprobe | waybackurls  | grep -iE '\.js'| grep -iEv '(\.jsp|\.json)' > /tmp/js1.txt 
cat ~/recon/$url/subdomains/httprobe | gau  | grep -iE '\.js'| grep -iEv '(\.jsp|\.json)' > /tmp/js2.txt
cat ~/recon/$url/subdomains/httprobe | hakrawler  | grep -iE '\.js' | grep -iEv '(\.jsp|\.json)' > /tmp/js3.txt 
cat ~/recon/$url/subdomains/httprobe | katana  | grep -iE '\.js' | grep -iEv '(\.jsp|\.json)' > /tmp/js4.txt 
subjs -i ~/recon/$url/subdomains/httprobe | tee -a /tmp/subjs.txt 
cat  /tmp/js1.txt /tmp/js2.txt /tmp/js3.txt /tmp/js4.txt /tmp/subjs.txt | grep -v "bootstrap.min.js" | grep -Ev  "bootstrap[a-zA-Z0-9_-]+\.js"| grep -v "jquery.min.js" | grep -v "popper.min.js" |grep -v "plugins" | grep -v  "themes" |grep -v "jquery.js"| grep -Ev "jquery[a-zA-Z0-9_-]+" | grep -Ev "jquery.[a-zA-Z0-9_-]+" | grep "$url" |  tee -a ~/recon/$url/Vulnerability/js-files.txt
rm -rf  /tmp/js1.txt /tmp/js2.txt /tmp/js3.txt /tmp/js4.txt /tmp/subjs.txt 
echo ""

 cat ~/recon/$url/Vulnerability/js-files.txt | httpx - > ~/recon/$url/Vulnerability/alive-js-files.txt
 nuclei -up
 nuclei -l ~/recon/$url/Vulnerability/alive-js-files.txt -t ~/nuclei-templates/http/exposures/ -o ~/recon/$url/Vulnerability/exposures-js-files.txt
