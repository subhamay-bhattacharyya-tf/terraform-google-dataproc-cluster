// File: test/helpers_test.go
package test

import (
	"context"
	"os"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
	"google.golang.org/api/dataproc/v1"
)

// mustEnv retrieves a required environment variable, failing the test if absent.
func mustEnv(t *testing.T, key string) string {
	t.Helper()
	v := strings.TrimSpace(os.Getenv(key))
	require.NotEmpty(t, v, "Missing required environment variable %s", key)
	return v
}

// newDataprocService creates an authenticated Dataproc REST client.
func newDataprocService(t *testing.T) *dataproc.Service {
	t.Helper()
	ctx := context.Background()
	svc, err := dataproc.NewService(ctx)
	require.NoError(t, err, "Failed to create Dataproc service client")
	return svc
}

// clusterExists reports whether the named Dataproc cluster is accessible.
func clusterExists(t *testing.T, svc *dataproc.Service, projectID, region, clusterName string) bool {
	t.Helper()
	_, err := svc.Projects.Regions.Clusters.Get(projectID, region, clusterName).Do()
	return err == nil
}

// fetchClusterState returns the current state string of the named Dataproc cluster.
func fetchClusterState(t *testing.T, svc *dataproc.Service, projectID, region, clusterName string) string {
	t.Helper()
	cluster, err := svc.Projects.Regions.Clusters.Get(projectID, region, clusterName).Do()
	require.NoError(t, err, "Failed to get cluster %s", clusterName)
	return cluster.Status.State
}
