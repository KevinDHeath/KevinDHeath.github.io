These are the tasks that need to be performed before pushing new releases to GitHub Pages.

<details><summary>Generate help documentation</summary>

1. Build the `NuGetPackages` Sandcastle projects from the `docs` folder.
2. Run the `ArtifactsCopy.ps1` script to overlay the modified files.
3. Test results locally.
4. Run the `PrepareHelp.ps1` script for `nuget` or `shfb` to copy the files ready for deployment.

<details><summary>CSS Modifications</summary>

### css folder

1. Style sheet: **presentationStyle.css**
~~~css
/* My modifications */
.codeHeader { background-color: #87CEFA; } /* LightSkyBlue */
.menu-label { background-color: #FF8C00; padding: 5pt; } /* DarkOrange */
.quickLink { line-height: .75; }
.table td.thin { padding-top: 0em; padding-bottom: 0em; }
~~~

</details>

<details><summary>HTML Modifications</summary>

### html\shfb folder (WPF packages)
1. Start page: **9488fab8-02de-4046-a582-c44f4c2a945f.htm**
~~~html
<h1>Introduction</h1>
~~~
- Modify package names in table to be nowrap and small
~~~html
   <td nowrap>
      <p><a href="N_Common_Wpf_Commands.htm" target="_self" rel="noopener noreferrer">Commands</a>
        <br /><small>Package: <strong>Wpf.Resources</strong></small></p>
   </td>
~~~
- Modify link to other site
~~~html
            <p><strong>Note:</strong> The Helper packages documentation for .NET applications can be found at
              <a href="../../nuget/index.html" target="_self" rel="noopener noreferrer">Helper
                Packages</a>.
~~~
2. Themes page: **e6e60a0c-f708-479e-bc65-bcdc99253c7b.htm**
~~~html
   <td class="thin>
   <td class="thin is-info"> (for sub-headings)
~~~

### html\nuget folder (Helper packages)
1. Start page: **R_Project_NuGetPackages.htm**
~~~html
<h1>Introduction</h1>
          <p>This site contains technical information about the
            <a href="https://kevindheath.github.io/" target="_blank">kdheath</a> Helper packages available on
            <a href="https://www.nuget.org/packages?q=owner:KevinDHeath&sortby=created-desc" target="_blank">NuGet</a>.</p>
~~~
- Add link to other site:
~~~html
            <p><strong>Note:</strong> The Wpf packages documentation for .NET Windows Presentation Foundation applications
              can be found at <a href="../../shfb/index.html">WPF Packages.</a></p>
~~~

</details>

</details>

<details><summary>Generate code coverage reports</summary>

1. Run the following `powershell` commands from the Unit Test project directories to generate
the coverage reports with history.\
_(__Important:__ This will create a new *CoverageHistory.xml file)_
```shell
dotnet test --collect:"XPlat Code Coverage" --configuration Testing
reportgenerator -reports:TestResults\*\coverage.cobertura.xml -targetdir:TestResults\reports\html -historydir:Testdata\history
reportgenerator -reports:TestResults\*\coverage.cobertura.xml -targetdir:TestResults\reports -reporttypes:MarkdownSummaryGithub
reportgenerator -reports:TestResults\*\coverage.cobertura.xml -targetdir:TestResults\reports\badges -reporttypes:Badges -verbosity:Warning
```
2. Update the `README.md` files for the projects with the contents from `TestResults\reports\SummaryGithub.md`
3. Run the `PrepareReports.ps1` script to copy the files ready for deployment.
4. Modify the `index.html` files to remove the unwanted elements _(see next section)_.

  <details><summary>HTML Modifications</summary>

## html folder
1. Index page: **index.html**

- Remove the Sponsor and Star buttons
```html
<h1>Summary</h1>
```
- Remove the Method coverage _(only available for sponsors)_
```html
<div class="card">
<div class="card-header">Method coverage</div>
<div class="card-body">
<div class="center">
<p>Feature is only available for sponsors</p>
<a class="pro-button" href="https://reportgenerator.io/pro" target="_blank">Upgrade to PRO version</a>
</div>
</div>
</div>
```
- _Optional:_ Comment out the invalid CDATA block inside the Style section
```html
        /*<![CDATA[*/
        /*]]>*/
```

  </details>

</details>
&nbsp;

> Pushing the changes will deploy the updated files to the GitHub Pages site.
