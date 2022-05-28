locals {
  livedoc_list = fileset("${var.livedoc_root}/**", "LifeDocInfo.yaml")
  yaml_obj = [ for ld_file in local.livedoc_list : file("${var.livedoc_root}/unicus/${ld_file}")]
  yaml_d = [for yaml_o in local.yaml_obj : yamldecode("${yaml_o}")]
}

###########################################
# save yaml paths to file to validate
###########################################
resource "local_file" "yaml_validate_script" {
  depends_on = [local.livedoc_list]
  content    = <<EOT
#!/bin/bash
pip3 install pyyaml
%{for ld_file in local.livedoc_list}
echo "${var.livedoc_root}/unicus/${ld_file}"
python3 -c 'import yaml, sys; print(yaml.safe_load(sys.stdin))' < ${var.livedoc_root}/unicus/${ld_file}%{endfor}
EOT
  filename   = "ld_file_validate.sh"
}
###########################################
# save yaml paths to file to validate
###########################################
resource "local_file" "yc_validate_script" {
  depends_on = [local.livedoc_list]
  content    = <<EOT
#!/bin/bash
%{for ld_file in local.livedoc_list}
echo "------------------------------------------"
echo "${var.livedoc_root}/unicus/${ld_file}"
yq eval-all '(.livedoc.idIntegrationProcess | length) * (.livedoc.idSystemIn | length) * (.livedoc.idSystemOut | length)' ${var.livedoc_root}/unicus/${ld_file}
echo "------------------------------------------"%{endfor}
EOT
  filename   = "yq_file_validate.sh"
}
resource "local_file" "integration_list" {
  depends_on = [local.yaml_d]
  content    = <<EOT
%{for yaml in local.yaml_d}%{for iip in yaml.livedoc.idIntegrationProcess}
%{for isi in yaml.livedoc.idSystemIn}
%{for iso in yaml.livedoc.idSystemOut}
@${isi.name}<-->${iip.name}<-->${iso.name}@
%{endfor}
%{endfor}
%{endfor}
%{endfor}
EOT
  filename   = "integration_list.txt"
}