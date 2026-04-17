# Terraform AWS IAM Role Module

Terraform module para criação de IAM Roles e Policies na AWS, com suporte a anexação de políticas existentes.

![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.14.8-blueviolet)
![AWS Provider](https://img.shields.io/badge/aws--provider-6.40.0-orange)

## Features

- Criação de IAM Role com trust policy configurável
- Criação de IAM Policies customizadas
- Attach automático das policies criadas à Role
- Attach de policies existentes via ARN
- Criação de policies sem Role (modo standalone)
- Tags obrigatórias para rastreabilidade (`Repository`)

## Usage

### Role com policies customizadas

```hcl
module "iam_role" {
  source = "github.com/DanHenrique/terraform-aws-iam-role?ref=v1.0.1"

  role_name                   = "MyRole"
  assume_role_policy_document = file("./role/role.json")

  policies = [
    {
      name        = "MyPolicy"
      description = "Policy for resource access"
      document    = file("./policy/policy.json")
    }
  ]

  tags = {
    Repository = "https://github.com/DanHenrique/terraform-aws-iam-role"
  }
}
```

### Role com policies existentes

```hcl
module "iam_role" {
  source = "github.com/DanHenrique/terraform-aws-iam-role?ref=v1.0.1"

  role_name                   = "MyRole"
  assume_role_policy_document = file("./role/role.json")

  existing_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]

  tags = {
    Repository = "https://github.com/DanHenrique/terraform-aws-iam-role"
  }
}
```

### Apenas policies (sem Role)

```hcl
module "iam_policies" {
  source = "github.com/DanHenrique/terraform-aws-iam-role?ref=v1.0.1"

  policies = [
    {
      name        = "MyStandalonePolicy"
      description = "Standalone policy"
      document    = file("./policy/policy.json")
    }
  ]

  tags = {
    Repository = "https://github.com/DanHenrique/terraform-aws-iam-role"
  }
}
```

## Inputs

| Nome | Descrição | Tipo | Default | Obrigatório |
|------|-----------|------|---------|:-----------:|
| `role_name` | Nome da IAM Role a ser criada. Se `null`, apenas as policies serão criadas | `string` | `null` | não |
| `assume_role_policy_document` | JSON da trust policy (obrigatório se `role_name` for fornecido) | `string` | `null` | condicional |
| `policies` | Lista de policies customizadas a criar e anexar à Role | `list(object)` | `[]` | não |
| `existing_policy_arns` | Lista de ARNs de policies existentes para anexar à Role | `list(string)` | `[]` | não |
| `tags` | Tags aplicadas aos recursos. A tag `Repository` é obrigatória | `map(string)` | `{}` | sim |

### Objeto `policies`

| Campo | Descrição | Tipo |
|-------|-----------|------|
| `name` | Nome da policy | `string` |
| `description` | Descrição da policy | `string` |
| `document` | JSON da policy | `string` |

## Outputs

| Nome | Descrição |
|------|-----------|
| `role_arn` | ARN da Role criada (`null` se `role_name` não for fornecido) |
| `role_name` | Nome da Role criada (`null` se `role_name` não for fornecido) |
| `policy_arns` | Map de `index => ARN` das policies criadas pelo módulo |

## Requisitos

| Ferramenta | Versão |
|------------|--------|
| Terraform | `1.14.8` |
| AWS Provider | `6.40.0` |

## Examples

- [Exemplo completo](examples/)

## CI/CD

Este módulo possui uma esteira de validação automática via GitHub Actions que é executada em todo Pull Request para `main`:

| Job | Descrição |
|-----|-----------|
| Validate PR | Valida título (Conventional Commits) e descrição do PR |
| Terraform Validation | `fmt -check`, `init -backend=false` e `validate` |
| TFLint | Análise estática do código Terraform |

Ao realizar merge na `main`, um release é gerado automaticamente via [semantic-release](https://semantic-release.gitbook.io/).
