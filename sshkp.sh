export WDIR=.
export SSHDIR=${WDIR}/.ssh
mkdir $SSHDIR
export SSHKP=${SSHDIR}/${INSTANCE}.pem

ADMIN_USER=ubuntu

AWSKEYNAME=t4c-ro-ist-system-1-kp
PROFILE=PERS_PROD
REGION=eu-west-2


echo "- Getting SSH key name"
echo "  aws ec2 describe-key-pairs --filters Name=key-name,Values=${AWSKEYNAME} --query 'KeyPairs[*].KeyPairId' --output text --region ${REGION} --profile ${PROFILE}"
echo "....................................."
export AWSKEYID=$(aws ec2 describe-key-pairs --filters Name=key-name,Values=${AWSKEYNAME} --query 'KeyPairs[*].KeyPairId' --output text --region ${REGION} --profile ${PROFILE} )
RC=$?
if [[ $RC -ne 0 ]]; then
  echo "  !! RC=$RC Failed to get KeyPair. " 
  exit 1
fi
echo "....................................."
echo "  OK - AWSKEYID=${AWSKEYID}"
echo ""

echo "- Removing existing key"
echo "  rm -f ${SSHKP}"
echo "....................................."
rm -f "${SSHKP}"
RC=$?
if [[ $RC -ne 0 ]]; then
  echo "  !! RC=$RC Failed to delete old key. " 
fi
echo "....................................."
echo "  OK "
echo ""


echo "- Exporting key"
echo "  aws ssm get-parameter --name /ec2/keypair/${AWSKEYID} --with-decryption --query 'Parameter.Value' --region ${REGION} --profile ${PROFILE} --output text > ${SSHKP}"
echo "....................................."
aws ssm get-parameter --name "/ec2/keypair/${AWSKEYID}" --with-decryption --query 'Parameter.Value' --region ${REGION} --profile ${PROFILE}  --output text > "${SSHKP}"
RC=$?
if [[ $RC -ne 0 ]]; then
  echo "  !! RC=$RC Failed to get KeyPair. " 
  exit 1
fi
echo "....................................."
echo "  OK "
echo ""

echo "- Setting keyfile permissions"
echo "  chmod 400 ${SSHKP}"
echo "....................................."
chmod 400 "${SSHKP}"
RC=$?
if [[ $RC -ne 0 ]]; then
  echo "  !! RC=$RC Failed to set permissions. " 
  exit 1
fi
echo "....................................."
echo "  OK "
echo ""


echo "Access via: ssh -i ${SSHKP} ${ADMIN_USER}@${INSTANCE_IP}"
