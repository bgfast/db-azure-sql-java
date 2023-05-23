
$json = Get-Content -Raw -Path .\local.settings.json | ConvertFrom-Json

$resourceGroup = $json.values.resourceGroup

# webapp name
$deploymentName = $json.values.deploymentName
$gitUserEmail = $json.values.gitUserEmail 
$gitUserName = $json.values.gitUserName 
$ADOgitURI = $json.values.ADOgitURI  

mvn clean package

if (Test-Path ./.git/config.lock) {
    Remove-Item -Force ./.git/config.lock
}
Write-Host "Publishing sample app.. (this might take a minute or two)"
Write-Host "git init"
git init
Write-Host "git config user.email $gitUserEmail"
git config user.email "$gitUserEmail"
Write-Host "git config user.name $gitUserName"
git config user.name "$gitUserName"
Write-Host "git add -A"
git add -A
Write-Host "git config http.postBuffer 52488000"
git config http.postBuffer 52488000
Write-Host "git commit -m 'Initial commit'"
git commit -m "Initial commit"


Write-Host "az webapp deploy --resource-group $resourceGroup --name $deploymentName --src-path .\target\azure-sql-java-samples-1.war"
az webapp deploy --resource-group $resourceGroup --name $deploymentName --src-path .\target\azure-sql-java-samples-1.war
#az webapp deploy --resource-group $resourceGroup --name $deploymentName --src-path C:\code\db-azure-sql-java\target\azure-sql-java-samples-1.war

Write-Host "git remote rm azwebapp "
git remote rm azwebapp 
Write-Host "git remote add azwebapp $ADOgitURI"
git remote add azwebapp $ADOgitURI
Write-Host "git push -v --force azwebapp master"
git push -v --force azwebapp master
