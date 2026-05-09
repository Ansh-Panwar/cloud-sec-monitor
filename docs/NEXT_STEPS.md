# Next Steps to Show Your Weather App

## What is already done
- Terraform infrastructure is deployed in `us-east-1`.
- ALB URL exists and is reachable when ECS has healthy targets.
- Current frontend image is a demo image (`nginxdemos/hello`).

## What you must do to show your weather app
1. Push this repo to GitHub.
2. Add GitHub Actions secrets in the repo:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
3. Run workflow: `Build and Push Weather Frontend`.
4. Copy the pushed image URI format:
   - `<account-id>.dkr.ecr.us-east-1.amazonaws.com/cloud-sec-monitor-frontend:weather-latest`
5. Update `infra/environments/dev/terraform.tfvars`:
   - Set `frontend_image` to the URI above.
   - Keep `backend_image` as `nginxdemos/hello` for now.
6. Run:
   - `terraform apply -auto-approve` from `infra/environments/dev`.
7. Open ALB URL from Terraform output.

## Optional cleanup
- Once your real backend is ready, replace `backend_image` with your backend ECR image.
- Re-enable CloudWatch logging in ECS task definitions after network is stable.

