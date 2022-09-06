param WebappName string = 'Mytestappbackup'
param backupname string ='backup'
param frequencyInterval int = 7
param retentionPeriodInDays int = 30
param startTime string = '"8/30/2022 9:00"'
resource symbolicname 'Microsoft.Web/sites/config@2022-03-01' = {
  name: '${WebappName}/${backupname}'
  properties: {
    backupName: backupname
    backupSchedule: {
      frequencyInterval: frequencyInterval
      frequencyUnit: 'Day'
      keepAtLeastOneBackup: true
      retentionPeriodInDays: retentionPeriodInDays

      startTime: startTime
    }
    storageAccountUrl: 'https://dmsfgo4iyvxpe.blob.core.windows.net/fsafas?sp=racwdli&st=2022-08-30T16:10:07Z&se=2022-08-31T00:10:07Z&spr=https&sv=2021-06-08&sr=c&sig=KE0jwDqAz9zN057mf1h%2BYSlUjoeXk9%2FEJtsRB4%2BrDJo%3D'
  }
}
