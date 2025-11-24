# Bash
# Créer le bucket S3 (pour us-east-1)
aws s3api create-bucket \
  --bucket dev-aka-tf-bucket \
  --region us-east-1

# Activer le versioning (recommandé pour les états Terraform)
aws s3api put-bucket-versioning \
  --bucket dev-aka-tf-bucket \
  --versioning-configuration Status=Enabled \
  --region us-east-1

# Créer la table DynamoDB pour le locking (clé primaire LockID de type String)
aws dynamodb create-table \
  --table-name Lock-Files \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-1
