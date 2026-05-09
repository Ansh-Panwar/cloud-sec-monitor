param(
  [string]$EnvDir = "..\infra\environments\dev"
)

Set-Location $EnvDir

terraform init
terraform plan

