# KevinDHeath.github.io

Modify Sandcastle Help File Builder (SHFB) presentationStyle.css
~~~
/* My modifications */
.codeHeader { background-color: #87CEFA; } /* LightSkyBlue */
.menu-label { background-color: #FF8C00; padding: 5pt; } /* DarkOrange */
.quickLink { line-height: .75; }
.table td.thin { padding-top: 0em; padding-bottom: 0em; }
~~~

## Updating Sandcastle Builds
1. Build NuGetPackages Sandcastle projects.
2. Overwrite folders `.\css`, `.\icons`, and `.\html` with modified files.
3. Test results locally.
4. Clear `.\nuget` or `.\shfb` folders.
5. Copy all files from `C\Temp\Documentation` subfolder _(output from SHFB projects)_.
6. Push changes which will deploy the updated files to the GitHub Pages site.

## HTML Modifications
The following pages need to be updated after a rebuild of the NuGetPackages.shfbproj
or WpfPackages.shfbproj projects.

### WpfPackages (shfb folder)
Start page: **9488fab8-02de-4046-a582-c44f4c2a945f.htm**
~~~
<h1>Introduction</h1>
~~~
- Modify package names in table to be nowrap and small:
~~~
   <td nowrap>
      <p><a href="N_Common_Wpf_Commands.htm" target="_self" rel="noopener noreferrer">Commands</a>
        <br /><small>Package: <strong>Wpf.Resources</strong></small></p>
   </td>
~~~
- Modify link to other site:
~~~
            <p><strong>Note:</strong> The Helper packages documentation for .NET applications can be found at
              <a href="../../nuget/index.html" target="_self" rel="noopener noreferrer">Helper
                Packages</a>.
~~~
Themes page: **e6e60a0c-f708-479e-bc65-bcdc99253c7b.htm**
~~~
   <td class="thin>
   <td class="thin is-info"> (for sub-headings)
~~~

### NuGetPackages (nuget folder)
Start page: **R_Project_NuGetPackages.htm**
~~~
<h1>Introduction</h1>
          <p>This site contains technical information about the
            <a href="https://kevindheath.github.io/" target="_blank">kdheath</a> Helper packages available on
            <a href="https://www.nuget.org/packages?q=owner:KevinDHeath&sortby=created-desc" target="_blank">NuGet</a>.</p>

~~~
- Add link to other site:
~~~
            <p><strong>Note:</strong> The Wpf packages documentation for .NET Windows Presentation Foundation applications
              can be found at <a href="../../shfb/index.html">WPF Packages.</a></p>
~~~