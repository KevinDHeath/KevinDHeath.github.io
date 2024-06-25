# About
This upgrade optimizes, wherever possible, the storage requirements in
[GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages)
by excluding common resources used by each
[Sandcastle Help File Builder](https://ewsoftware.github.io/SHFB/html/bd1ddb51-1c4f-434f-bb1a-ce2135d3a909.htm) (SHFB) project.
- Cascading Styles Sheet files are redirected to a single set contained in the `./css` folder.\
  This has an added advantage of being able to adjust the versions of [Bulma](https://bulma.io/) and
  [Font Awesome](https://fontawesome.com/) used by SHFB.
- However, JavaScript files ***cannot*** be redirected due to serious security considerations.
- Other files are excluded using the `./.gitignore` file.

The importing and overlaying of the SHFB output contained in other repositories is done using the
[PowerShell](https://github.com/PowerShell/PowerShell#-powershell) scripts in this folder.

## Code Coverage Import
- Relies on all repositories being under the same `$root` directory.
- Report Generator output in the `NuGetPackages` repository must be in `.\tests\Unit\TestResults\[$project]\reports`

## SHFB Import
- Relies on all repositories being under the same `$root` directory.
- Prompts for the `$project` to be imported, which must be a supported name.
- The `$repo` is determined based on the `$project` value.
- SHFB project output in other repositories must be in `[$root]\[$repo]\doc\bin\[$project]`

## SHFB Overlay
- Replaces the files with any modifications for all SHFB projects.

## Testing
[IIS Express](https://learn.microsoft.com/en-us/iis/extensions/introduction-to-iis-express/iis-express-overview)
can be used to test locally before pushing any changes to [GitHub](https://github.com/about), which
automatically triggers the deployment workflow.\
The `.\iis-express.ps1` PowerShell script can be used which binds to port `44399`
- http://localhost:44399
- http://localhost:44399/nuget
- http://localhost:44399/score
- http://localhost:44399/shfb

> ✔️ Using the https protocol is not necessary because `localhost` can only be accessed by local traffic.

See [Using SSL](https://learn.microsoft.com/en-us/iis/extensions/using-iis-express/running-iis-express-without-administrative-privileges#using-ssl) for more information on how to configure it.

*Site definition in:* `%USERPROFILE%\Documents\IISExpress\config\applicationhost.config`
```xml
<site name="Testing" id="2" serverAutoStart="true">
  <application path="/">
    <virtualDirectory path="/" physicalPath="C:\Users\Kevin\source\repos\github\KevinDHeath.github.io" />
  </application>
  <bindings>
    <binding protocol="https" bindingInformation=":44399:localhost" />
  </bindings>
</site>
```
*Command line switch:*
```shell
.\iisexpress.exe /site:Testing
```