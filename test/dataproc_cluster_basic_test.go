package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
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
			"region":       "us-central1",
			"dataproc_cluster_config": map[string]interface{}{
				"base_name":             baseName,
				"worker_num_instances":  2,
				"idle_delete_ttl":       "600s",
				"enable_http_port_access": false,
			},
		},
		EnvVars: map[string]string{
			"GOOGLE_CLOUD_PROJECT": projectID,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	// Allow cluster to stabilise before asserting
	time.Sleep(10 * time.Second)

	clusterName := terraform.Output(t, tfOptions, "cluster_name")
	require.Contains(t, clusterName, baseName, "cluster_name should contain the base_name")

	masterNames := terraform.OutputList(t, tfOptions, "master_instance_names")
	require.Len(t, masterNames, 1, "expected 1 master instance")

	workerNames := terraform.OutputList(t, tfOptions, "worker_instance_names")
	require.Len(t, workerNames, 2, "expected 2 worker instances")

	clusterProject := terraform.Output(t, tfOptions, "cluster_project")
	require.Equal(t, projectID, clusterProject, "cluster_project must match GOOGLE_CLOUD_PROJECT")
}
