# Collect data from YAML file and reorganize it

## Example of using YAML

Original

```yaml
  descModule: "text"
  endPoints:
        - description: "text"
          name: "/endpoint"
  idIntegrationProcess:
        - description: "text"
          name: "unique_string"
  idSystemIn:
        - name: "unique_string"
  idSystemOut:
        - description: "test"
          name: "unique_string"
```

Imported by `yamldecode`

```hcl
  descModule           = "text"
  endPoints            = [
      {
          description = "text"
          name        = "/endpoint"
        },
    ]
  idIntegrationProcess = [
      {
          description = "text"
          name        = "unique_string"
        },
    ]
  idSystemIn           = [
      {
          name = "unique_string"
        },
    ]
  idSystemOut          = [
      {
          description = "test"
          name        = "unique_string"
        },
    ]
},
```

## How it works

1. Collect YAML paths starting `var.livedoc_root` path
1. YAMLDecode it to HCL
1. Create chains @`idSystemIn`<-->`idIntegrationProcess`<-->`idSystemOut`@ to the list
1. During process validating scripts are generated

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.integration_list](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.yaml_validate_script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.yc_validate_script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_livedoc_root"></a> [livedoc\_root](#input\_livedoc\_root) | n/a | `string` | `"/Users/viktorbusmin/Downloads/alfa/code/interplat"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->