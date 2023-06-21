function makeTBCool()
{
  event.srcElement.style.color = "#FFFF00";
}

function makeTBNormal()
{
  event.srcElement.style.color = "#FFFFFF";
}

document.write("<table border='0' cellspacing='0' cellpadding='0'>")
document.write("  <tr>")
document.write("    <td class='menu'><nobr>")
document.write("    |&nbsp;<a onmouseover='makeTBCool()' onmouseout='makeTBNormal()' href='../families.htm'><font color='#FFFFFF'>Trees</font></a>&nbsp;")
document.write("    |</nobr></td>")
document.write("  </tr>")
document.write("</table>")
document.write("<table border='0' cellpadding='0' cellspacing='0' width='95%'>")
document.write("  <tr>")
document.write("    <td width='100%' class='DividerA'><font size='1'>&nbsp;</font></td>")
document.write("  </tr>")
document.write("</table>")
