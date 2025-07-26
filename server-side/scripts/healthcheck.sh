#!/bin/bash

set -e
set -x

# Check application viability
curl --fail http://localhost:8000/api/healthcheck || exit 1

# Check database viability
curl --fail http://localhost:8000/api/dbHealth || exit 1