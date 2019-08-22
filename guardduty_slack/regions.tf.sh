#!/bin/bash -e
#
# Generates .tf source code.
# Because current terraform does not support for-each-modules, generate .tf with this script.
#

cd "$(dirname "$0")"
FILENAME="$(basename "$0" .sh)"

echo "Generating $FILENAME"

cat << EOS > "$FILENAME"
#
# Generated by ./$FILENAME.sh
# Do not directly modify this file
#

EOS

# https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_regions.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
for region in us-east-1 us-east-2 us-west-1 us-west-2 ca-central-1 eu-central-1 eu-west-1 eu-west-2 eu-west-3 eu-north-1 ap-northeast-1 ap-northeast-2 ap-southeast-1 ap-southeast-2 ap-south-1 sa-east-1
do
    cat << EOS >> "$FILENAME"
module "$region" {
  aws_region = "$region"

  source = "./regional"

  enable = "\${var.enable}"
  envname = "\${var.envname}"
  lambda_notify_to_slack_arn = "\${module.lambda_sns_to_slack.lambda_arn}"
  ipset_location = "\${local.ipset_location}"
}
EOS
done

echo "Generated $FILENAME, please commit that file."
