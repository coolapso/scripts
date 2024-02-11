serverip=0.0.0.0

spinner(){
    local pid=$1
    local delay=0.50
    local spinstr='/-\|'
    while ps a | awk '{print $1}' | grep -q "$pid"; do
        local temp=${spinstr#?}
        printf "[%c] Waiting for ssh connection \r" "${spinstr}"
        local spinstr=${temp}${spinstr%"$temp"}
        sleep ${delay}
        printf "\\b\\b\\b\\b\\b\\b"
    done
    printf "    \\b\\b\\b\\b"
    echo -n ' '
}

checkready(){
    while true; do
        if ssh -o "ConnectTimeout=2" -o "StrictHostKeyChecking=no" root@"$serverip" 'test -f /tmp/server-config/scripts/config-vars' > /dev/null 2>&1; then
            echo "Server ready"
            break
        else
            spinner "$!"
        fi
    done
}

checkready
