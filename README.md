# procal-iac

Multi-environment AWS infrastructure for Procal, written entirely as code with OpenTofu. A solo from-scratch rebuild of a team project, done to internalize every layer instead of clicking through the console.

## What it provisions

VPC across 2 AZs (public + private subnets) · 3-tier security groups (ALB → app → RDS) · internet-facing ALB with ACM TLS · EC2 Auto Scaling group in private subnets · RDS PostgreSQL (private, never public) · SQS · S3 app bundles · Route 53 public + private zones

## Layout

```
modules/            network, security, alb, compute, rds, sqs, s3, secrets, dns, tooling_service
live/
  foundation/       composition root wiring the modules together
```

Modules are environment-agnostic; each environment is a thin composition in `live/`. Splitting `foundation` into per-environment compositions is in progress.

## Workflow (GitOps)

Every change ships through a pull request, never from a laptop:

1. **GitHub Actions CI** — `tofu fmt` check, `tofu validate`, `tflint`, and a Checkov security scan on every PR
2. **Atlantis** — auto-plans the affected project and posts the plan as a PR comment
3. **Apply from the PR** — `atlantis apply` after review

State lives in S3 with native lockfile locking.

## Design notes

- Security groups chain by reference, not CIDR: only the ALB can reach the app tier, only the app tier can reach RDS
- No credentials in code or state: RDS uses `manage_master_user_password`, app secrets live in AWS Secrets Manager
- Public domain (`procal.saputra.dev`) and private zone (`procal.internal`) are both managed here, including ACM validation
