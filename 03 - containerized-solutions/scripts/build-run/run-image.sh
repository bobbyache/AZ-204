#!/bin/bash

# Not sure how this works yet...
az acr run --registry robazacrregistry --cmd '$Registry/sample/hello-world:v1' /dev/null
# az acr run --registry robazacrregistry oci://myregistry.azurecr.io/