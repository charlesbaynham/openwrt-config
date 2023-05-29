ssh_host="houseabsolute"

# Load secrets
source .secrets

# Prepare staging area
rm -r dist || true
mkdir -p dist/

# Parse secrets into config files
for f in config/*
do
	echo "parse $f"
    envsubst < $f > dist/$(basename $f)
done

# Copy required files to device
ssh houseabsolute <<'ENDSSH'
    echo SSH connection successful
    echo Preparing staging directory on router
    rm -r /tmp/git_uci_config || true
    mkdir /tmp/git_uci_config
ENDSSH

echo Copying config files with SFTP
scp dist/* ${ssh_host}:/tmp/git_uci_config

echo "Configure router"
ssh houseabsolute <<'ENDSSH'
    echo SSH connection successful
    echo Clearing old config...
    rm /etc/config/*
    echo Loading new config...
    cp /tmp/git_uci_config/* /etc/config/.
    echo Committing...
    uci commit
    echo Running "reload_config"
    reload_config
    echo Completed!
ENDSSH

# Finally, update ssh authorized_keys
echo Updating authorized_keys...
scp authorized_keys ${ssh_host}:/root/.ssh

echo Done.
