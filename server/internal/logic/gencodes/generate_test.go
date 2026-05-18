package gencodes

import "testing"

func TestTableToRelationNameCoreTables(t *testing.T) {
	tests := map[string]string{
		"xy_admin_user":     "user",
		"xy_admin_role":     "role",
		"xy_admin_menu":     "menu",
		"xy_admin_dept":     "dept",
		"xy_admin_post":     "post",
		"xy_sys_attachment": "attachment",
		"xy_sys_config":     "config",
	}

	for table, want := range tests {
		if got := tableToRelationName(table); got != want {
			t.Fatalf("tableToRelationName(%q) = %q, want %q", table, got, want)
		}
	}
}

func TestTableToRelationNameKeepsBusinessPrefix(t *testing.T) {
	tests := map[string]string{
		"xy_member":                       "member",
		"xy_hkdl_team":                    "hkdl_team",
		"public.xy_hkdl_customer_archive": "hkdl_customer_archive",
	}

	for table, want := range tests {
		if got := tableToRelationName(table); got != want {
			t.Fatalf("tableToRelationName(%q) = %q, want %q", table, got, want)
		}
	}
}
