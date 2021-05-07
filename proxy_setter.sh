echo "Loading proxy_setter..."

# Sets the proxy configuration.
# As applications are using lowercase or uppercase, both are set.
# Provide the proxy variables
# - by defining the variables here
# - by loading another file with the variables via "source ./proxy-var-file.sh"
function set_proxies() {
	echo "Setting Proxies"	
	export no_proxy=localhost,127.0.0.0/8,*.local
	export http_proxy=http://$username:$password@$host:$port
	export https_proxy=http://$username:$password@$host:$port
	
	export NO_PROXY=localhost,127.0.0.0/8,*.local
	export HTTP_PROXY=http://$username:$password@$host:$port
	export HTTPS_PROXY=http://$username:$password@$host:$port
}

function unset_proxies() {
	echo "Unsetting Proxies"	
	unset {http,https,ftp}_proxy
}