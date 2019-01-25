echo "******************************************************************************"
echo "Set Hostname." `date`
echo "******************************************************************************"
hostname ${POSTGRES_HOSTNAME}
cat > /etc/hostname <<EOF
${POSTGRES_HOSTNAME}
EOF
