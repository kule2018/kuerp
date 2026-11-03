$log = "f:/erp系统/进销存系统/nestjs-erp/_ready5.txt"
"" | Set-Content -Encoding utf8 $log
for ($i = 0; $i -lt 120; $i++) {
  Start-Sleep -Seconds 5
  $st = docker ps --filter name=kuerp-mysql --format "{{.Status}}" 2>$null
  if ($st -notmatch "Up") { Add-Content -Encoding utf8 $log "CRASHED $i : $st"; break }
  $r = docker exec kuerp-mysql mysql -uroot -proot -N -e "SELECT username FROM kuerp_erp.kuerp_admin LIMIT 1;" 2>$null
  if ($LASTEXITCODE -eq 0 -and $r -match "admin") { Add-Content -Encoding utf8 $log "ADMIN_OK $i : $r"; break }
  Add-Content -Encoding utf8 $log "waiting $i"
}
Add-Content -Encoding utf8 $log "DONE"
