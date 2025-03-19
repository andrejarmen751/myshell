#!/bin/bash
cockroach start --insecure \
	--join=cockroach0,cockroach1,cockroach2
