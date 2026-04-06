package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestDataprocClusterBasic creates a minimal Dataproc cluster, asserts key
// outputs, and destroys it. Requires GOOGLE_CLOUD_PROJECT to be set.
func TestDataprocClusterBasic(t *testing.T) {
	t.Parallel()

	projectID := mustEnv(t, "GOOGLE_CLOUD_PROJECT")
	unique := strings.ToLower(random.UniqueId())
	baseName := fmt.Sprintf("tt-basic-%s", unique)

	tfOptions := &terraform.Options{
		TerraformDir: "..",
		NoColor:      true,
		Vars: map[string]interface{}{
			"environment":  "devl",
			"project_code": "tt",
			"region":       "europe-west1",
			"dataproc_cluster_config": map[string]interface{}{
				"base_name":               baseName,
				"worker_num_instances":    2,
				"idle_delete_ttl":         "600s",
				"enable_http_port_access": false,
			},
		},
		EnvVars: map[string]string{
			"GOOGLE_CLOUD_PROJECT": projectID,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	clusterName := terraform.Output(t, tfOptions, "cluster_name")
	require.Contains(t, clusterName, baseName, "cluster_name should contain the base_name")

	clusterProject := terraform.Output(t, tfOptions, "cluster_project")
	require.Equal(t, projectID, clusterProject, "cluster_project must match GOOGLE_CLOUD_PROJECT")

	clusterRegion := terraform.Output(t, tfOptions, "cluster_region")
	require.Equal(t, "europe-west1", clusterRegion, "cluster_region should be europe-west1")

	masterNames := terraform.OutputList(t, tfOptions, "master_instance_names")
	assert.NotEmpty(t, masterNames, "master_instance_names should not be empty")

	workerNames := terraform.OutputList(t, tfOptions, "worker_instance_names")
	assert.NotEmpty(t, workerNames, "worker_instance_names should not be empty")
}
