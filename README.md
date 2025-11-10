POC - ECS Fargate API behind ALB with Cognito, IAM, DynamoDB, IaC with Terraform

Infrastructure: Terraform in 'infra/'.

App: python FastAPI minimal API in 'app/'.

## Quick start
terraform -chdir=infra init

terraform -chdir=infra apply

Build and push:

docker build -t poc1-api ./app

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

REGION=${AWS_REGION:-us-east-1}

REGISTRY="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

docker tag poc1-api:latest "$REGISTRY/poc1-api:latest"

docker push "$REGISTRY/poc1-api:latest"
