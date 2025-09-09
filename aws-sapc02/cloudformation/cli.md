aws cloudformation create-stack \
  --stack-name smt-stack-2 \
  --template-body file://create-subnet-in-exiting-vpc.yml \
  --parameters \
    ParameterKey=VpcId,ParameterValue=vpc-0a187bf9f7b3f7c1d \
    ParameterKey=SubnetCidrBlock,ParameterValue=10.1.100.0/24 \
    ParameterKey=AvailabilityZone,ParameterValue=us-east-1c
