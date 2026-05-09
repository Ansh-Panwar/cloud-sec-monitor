param(
  [string]$EnvDir = "..\infra\environments\dev"
)

Set-Location $EnvDir

terraform apply -auto-approve

