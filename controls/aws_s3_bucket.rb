fixtures = {}
[
  's3_bucket_name',
].each do |fixture_name|
  fixtures[fixture_name] = attribute(
    fixture_name,
    default: "default.#{fixture_name}",
    description: 'See ../build/s3.tf',
  )
end

# research checking for 'http' proto from the world

control "s3-buckets-public-access" do
  impact 0.7
  title "Ensure there are no publicly accessable S3 Buckets"
  desc "Ensure there are no publicly accessable S3 Buckets"

  tag "nist": ["CM-6", "Rev_4"]
  tag "severity": "high"

  tag "check": "Review your AWS console and note if any S3 buckets are set to
                'Public'. If any buckets are listed as 'Public', then this is
                a finding."

  tag "fix": "Log into your AWS console and select the S3 buckts section. Select
              the buckets found in your review. Select the permisssions tab for
              the bucket and remove the Public Access permission."

  describe aws_s3_buckets do
    its('buckets') { should be_in ['logging_bucket'] }
    #its('public_buckets') { should cmp [] }
    it { should_not have_public_buckets }
  end
end
