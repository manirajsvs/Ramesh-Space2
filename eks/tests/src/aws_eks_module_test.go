package test

import (
	
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformEKS(t *testing.T) {
	t.Parallel()

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples",
		Vars:         map[string]interface{}{},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created.
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the IP of the instance
	//eksEndpoint := terraform.Output(t, terraformOptions, "endpoint")
//    clusterName := terraform.Output(t, terraformOptions, "cluster_name")
  //  assert.Equal(t, "k8s-portal-dev", clusterName)

   // kubeconfig := terraform.Output(t, terraformOptions, "kubeconfig")
   // assert.NotEmpty(t, kubeconfig)

    //endpoint := terraform.Output(t, terraformOptions, "endpoint")
    //assert.Contains(t, endpoint, "https://")

	// Make an HTTP request to the instance and make sure we get back a 200 OK with the any body message
	//url := fmt.Sprintf("http://%s:8080", eksEndpoint)
	//http_helper.HttpGetWithRetry(t, url, nil, 200, "", 30, 5*time.Second)
}
