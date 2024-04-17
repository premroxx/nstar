- **modules**: Contains reusable modules for configuring specific resources.
  - `alb`: tf for Load Balancer.
  - `ecs`: tf for Creating nginx ECS Cluster.
  - `s3`: tf for s3

- **common**: Contains common modules across regions.
  - `dynamodb`: tf for global DynamoDB tables.
  - `iam`: tf for IAM Roles.

- **state**: for cconfiguring region specific-state.

- **us-e1**: Configuration for managing resources in the us-east-1 region.
- **us-w2**: Configuration for managing resources in the us-west-2 region.