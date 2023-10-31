﻿//===============================================================================================================
// System  : Sandcastle Help File Builder
// File    : presentationStyle.js
// Author  : Eric Woodruff  (Eric@EWoodruff.us)
// Updated : 07/04/2023
// Note    : Copyright 2014-2023, Eric Woodruff, All rights reserved
//           Portions Copyright 2010-2023 Microsoft, All rights reserved
//
// This file contains the methods necessary to implement the language filtering, collapsible section, and
// copy to clipboard options.
//
// This code is published under the Microsoft Public License (Ms-PL).  A copy of the license should be
// distributed with the code and can be found at the project website: https://GitHub.com/EWSoftware/SHFB.  This
// notice, the author's name, and all copyright notices must remain intact in all applications, documentation,
// and source files.
//
//    Date     Who  Comments
// ==============================================================================================================
// 05/04/2014  EFW  Created the code based on the MS Help Viewer script
//===============================================================================================================

// Ignore Spelling: fti json Resizer mousedown mouseup mousemove

//===============================================================================================================
// This section contains the methods used to implement the language filter

// The IDs of language-specific text (LST) spans are used as dictionary keys so that we can get access to the
// spans and update them when the user selects a different language in the language filter.  The values of the
// dictionary objects are pipe separated language-specific attributes (lang1=value|lang2=value|lang3=value).
// The language ID can be specific (cs, vb, cpp, etc.) or may be a neutral entry (nu) which specifies text
// common to multiple languages.  If a language is not present and there is no neutral entry, the span is hidden
// for all languages to which it does not apply.
var allLSTSetIds = new Object();

var clipboardHandler = null;

// Set the default language
function SetDefaultLanguage(defaultLanguage)
{
    // Create the clipboard handler
    if(typeof (Clipboard) === "function")
    {
        clipboardHandler = new ClipboardJS('.copyCode',
            {
                text: function (trigger)
                {
                    var codePanel = trigger.parentElement.parentElement;

                    if(codePanel === null || typeof(codePanel) === "undefined")
                        return "";

                    if($(codePanel).hasClass("codeHeader"))
                        codePanel = codePanel.parentElement;

                    codePanel = $(codePanel).find("code");

                    if(codePanel === null || typeof(codePanel) === "undefined")
                        return "";

                    // Toggle the icon briefly to show success
                    var iEl = $(trigger).children("span").children("i");

                    if(iEl.length !== 0)
                    {
                        $(iEl).removeClass("fa-copy").addClass("fa-check");

                        setTimeout(function ()
                        {
                            $(iEl).removeClass("fa-check").addClass("fa-copy");
                        }, 500);
                    }

                    return $(codePanel).text();
                }
            });
    }

    // Connect the language filter items to their event handler
    $(".languageFilterItem").click(function ()
    {
        SelectLanguage(this);
    });

    // Add language-specific text spans on startup.  We can't tell for sure if there are any as some
    // may be added after transformation by other components.
    $("span[data-languageSpecificText]").each(function ()
    {
        allLSTSetIds[this.id] = $(this).attr("data-languageSpecificText");
    });

    if(typeof (defaultLanguage) === "undefined" || defaultLanguage === null || defaultLanguage.trim() === "")
        defaultLanguage = "cs";

    var language = localStorage.getItem("SelectedLanguage");

    if(language === null)
        language = defaultLanguage;

    var languageFilterItem = $("[data-languageId=" + language + "]")[0]
    var currentLanguage = document.getElementById("CurrentLanguage");

    currentLanguage.innerText = languageFilterItem.innerText;

    SetSelectedLanguage(language);
}

// This is called by the language filter items to change the selected language
function SelectLanguage(languageFilterItem)
{
    var currentLanguage = document.getElementById("CurrentLanguage");

    currentLanguage.innerText = languageFilterItem.innerText;

    var language = $(languageFilterItem).attr("data-languageId");

    localStorage.setItem("SelectedLanguage", language);

    SetSelectedLanguage(language);
}

// This function executes when setting the default language and selecting a language option from the language
// filter dropdown.  The parameter is the user chosen programming language.
function SetSelectedLanguage(language)
{
    // If LST exists on the page, set the LST to show the user selected programming language
    for(var lstMember in allLSTSetIds)
    {
        var devLangSpan = document.getElementById(lstMember);

        if(devLangSpan !== null)
        {
            // There may be a carriage return before the LST span in the content so the replace function below
            // is used to trim the whitespace at the end of the previous node of the current LST node.
            if(devLangSpan.previousSibling !== null && devLangSpan.previousSibling.nodeValue !== null)
                devLangSpan.previousSibling.nodeValue = devLangSpan.previousSibling.nodeValue.replace(/[\r\n]+$/, "");

            var langs = allLSTSetIds[lstMember].split("|");
            var k = 0;
            var keyValue;

            while(k < langs.length)
            {
                keyValue = langs[k].split("=");

                if(keyValue[0] === language)
                {
                    devLangSpan.innerHTML = keyValue[1];
                    break;
                }

                k++;
            }

            // If not found, default to the neutral language.  If there is no neutral language entry, clear the
            // content to hide it.
            if(k >= langs.length)
            {
                if(language !== "nu")
                {
                    k = 0;

                    while(k < langs.length)
                    {
                        keyValue = langs[k].split("=");

                        if(keyValue[0] === "nu")
                        {
                            devLangSpan.innerHTML = keyValue[1];
                            break;
                        }

                        k++;
                    }
                }

                if(k >= langs.length)
                    devLangSpan.innerHTML = "";
            }
        }
    }

    // If code snippet groups exist, set the current language for them
    $("div[data-codeSnippetLanguage]").each(function ()
    {
        if($(this).attr("data-codeSnippetLanguage") === language)
        {
            $(this).removeClass("is-hidden");
        }
        else
        {
            $(this).addClass("is-hidden");
        }
    });
}

//===============================================================================================================
// In This Article navigation aid methods

var headerPositions = [], headerElements = [];
var quickLinks = null;

// Get the positions of the quick link header elements and set up the In This Article navigation links to
// scroll the section into view when clicked and get highlighted when the related section scrolls into view.
function InitializeQuickLinks()
{
    var sectionList = $("#InThisArticleMenu")[0];

    $(".quickLinkHeader").each(function ()
    {
        headerPositions.push(this.getBoundingClientRect().top);
        headerElements.push(this);
    });

    if(headerElements.length !== 0)
    {
        sectionList.parentElement.classList.remove("is-hidden");
        quickLinks = $(".quickLink");

        $(quickLinks[0]).addClass("is-active-quickLink");

        for(var i = 0; i < quickLinks.length; i++)
        {
            quickLinks[i].addEventListener("click", function (event)
            {
                document.removeEventListener("scroll", QuickLinkScrollHandler, true);

                for(i = 0; i < quickLinks.length; i++)
                {
                    if(quickLinks[i] === this)
                        headerElements[i].scrollIntoView();

                    quickLinks[i].classList.remove("is-active-quickLink");
                }

                this.classList.add("is-active-quickLink");

                setTimeout(function ()
                {
                    document.addEventListener("scroll", QuickLinkScrollHandler, true);
                }, 600);
            });
        }

        document.addEventListener("scroll", QuickLinkScrollHandler, true);
    }
}

// Highlight the nearest quick link as the document scrolls
function QuickLinkScrollHandler()
{
    currentScrollPosition = document.documentElement.scrollTop;
    var i = 0;

    while(i < headerPositions.length - 1)
    {
        if(currentScrollPosition <= headerPositions[i + 1])
            break;

        i++;
    }

    if(i >= headerPositions.length)
        i = headerPositions.length  - 1;

    var currentActive = document.getElementsByClassName("is-active-quickLink")[0];

    if(currentActive !== undefined)
        currentActive.classList.remove("is-active-quickLink");

    quickLinks[i].classList.add("is-active-quickLink");
}

//===============================================================================================================
// Collapsible section methods

// Expand or collapse a topic section
function SectionExpandCollapse(item)
{
    var section = item.parentElement.nextElementSibling;

    if(section !== null)
    {
        $(item).toggleClass("toggleCollapsed");

        if(section.style.display === "")
            section.style.display = "none";
        else
            section.style.display = "";
    }
}

// Expand or collapse a topic section when it has the focus and Enter is hit
function SectionExpandCollapseCheckKey(item, togglePrefix, eventArgs)
{
    if(eventArgs.keyCode === 13)
        SectionExpandCollapse(item);
}
