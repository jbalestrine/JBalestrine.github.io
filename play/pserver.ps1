$httpListener = New-Object System.Net.HttpListener
   $httpListener.Prefixes.Add('http://localhost:8080/')
   $httpListener.Start()

   while ($httpListener.IsListening) {
       $context = $httpListener.GetContext()
       $request = $context.Request
       $response = $context.Response

       if ($request.HttpMethod -eq 'POST') {
           # Process the command received from the website
           $command = $request.InputStream | Out-String
           $output = Invoke-Expression $command

           $response.StatusCode = 200
           $response.ContentLength64 = $output.Length
           $response.OutputStream.Write([System.Text.Encoding]::UTF8.GetBytes($output), 0, $output.Length)
       }

       $response.Close()
   }