@ECHO OFF
REM In order tu upload and bind TLS certificates to the Azure WebApp, the system needs access
REM to the Azure resource. We will add this permission through an Azure Service Principal.
REM This script uses Azure CLI for creating this permission. Parameter result should be
REM applied in the ARM JSON template when building the solution.
REM
REM You can use the same commands in a bash shell adapting variables references.
REM
REM Usage:  %1 - Resource Group Name
REM         %2 - Location (ex: westeurope)
REM         %3 - Azure Subscription Id
az group create --name %1 --location %2
az ad sp create-for-rbac -n %1 --role contributor --scopes /subscriptions/%3/resourceGroups/%1