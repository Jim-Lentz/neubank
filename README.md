# neubank
Azure 3 tier app project


**APP Insights Integration**
For each part of your stack (frontend, backend), you will need to integrate Application Insights. The exact method depends on the application stack you are using (e.g., .NET, Java, Node.js).
**Example for .NET Core:**
Install the Application Insights SDK: 
For a .NET Core application, you would add the Application Insights SDK to your project via NuGet.
'dotnet add package Microsoft.ApplicationInsights.AspNetCore'
Configure Application Insights: In the Startup.cs or the app's configuration file, initialize Application Insights with the Instrumentation Key.
'services.AddApplicationInsightsTelemetry("your_instrumentation_key_here");'

**Example for Node.js:**
Install the Application Insights SDK: For Node.js applications, add the Application Insights SDK through npm.
'npm install applicationinsights --save'
Configure Application Insights: In your application, configure and start Application Insights with your Instrumentation Key.
'let appInsights = require('applicationinsights');
appInsights.setup('your_instrumentation_key_here').start();'

![image](https://github.com/Jim-Lentz/neubank/assets/52187407/9a8571f8-d97e-4df5-a280-16b292bdb6ba)

