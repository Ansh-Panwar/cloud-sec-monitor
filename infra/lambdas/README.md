# Lambda: threat_ingest

This folder contains the Python code for the `threat_ingest` Lambda used by Terraform.

Terraform in `infra/environments/dev/main.tf` expects a zip file at:

`infra/lambdas/threat_ingest.zip`

To build it:

1. Open a terminal in this folder (`infra/lambdas`).
2. Create a virtual environment and install `boto3` (for local packaging only, in AWS the Lambda runtime has the SDK, but bundling is safe for portability):

   ```bash
   python -m venv .venv
   source .venv/bin/activate  # Windows PowerShell: .\.venv\Scripts\Activate.ps1
   pip install boto3
   ```

3. Create the deployment package:

   ```bash
   mkdir -p build
   cp handler.py build/
   cd .venv/Lib/site-packages  # or .venv/lib/python3.11/site-packages on Linux/Mac
   zip -r ../../../../infra/lambdas/threat_ingest.zip .
   cd ../../../../infra/lambdas
   zip -g threat_ingest.zip handler.py
   ```

4. Now `threat_ingest.zip` exists and `terraform apply` can upload it.

