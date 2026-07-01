# Unit Tests for tf-atom-internet-gateway-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:      terraform test -test-directory=tests/unit
# Run verbose:   terraform test -test-directory=tests/unit -verbose
#
# Assertions are on plan-KNOWN values only (the tf-label id string,
# resource count via length(...), and input pass-throughs). Computed
# attributes such as the gateway arn/id are UNKNOWN under a mock
# provider and must not be asserted on directly.

mock_provider "aws" {}

variables {
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  vpc_id = "vpc-0123456789abcdef0"
}

# ---------------------------------------------------------------------------
# Test: module creates the internet gateway when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = length(aws_internet_gateway.this) == 1
    error_message = "Expected exactly one internet gateway to be planned when enabled."
  }

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true when the module is enabled."
  }

  assert {
    condition     = aws_internet_gateway.this[0].tags["Name"] == "eg-test-thing"
    error_message = "Name tag should equal the tf-label id 'eg-test-thing'."
  }

  assert {
    condition     = aws_internet_gateway.this[0].vpc_id == "vpc-0123456789abcdef0"
    error_message = "vpc_id should be passed through to the internet gateway."
  }
}

# ---------------------------------------------------------------------------
# Test: module creates nothing when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_internet_gateway.this) == 0
    error_message = "No internet gateway should be planned when enabled = false."
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when the module is disabled."
  }

  assert {
    condition     = output.id == null
    error_message = "id output should be null when the module is disabled."
  }
}
