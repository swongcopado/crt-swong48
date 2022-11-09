*** Settings ***
Library                         QForce
Library                         String


*** Variables ***
${BROWSER}                      chrome
${username}                     ${sfuser}
${password}                     ${sfpassword}
${login_url}                    https://${sfdomain}.my.salesforce.com/                  # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}                     ${login_url}/lightning/page/home


*** Keywords ***
Setup Browser
    Set Library Search Order    QWeb
    Open Browser                about:blank                 ${BROWSER}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    SetConfig                   DefaultTimeout              20s                         #sometimes salesforce is slow


End suite
    Close All Browsers


Login
    [Documentation]             Login to Salesforce instance
    GoTo                        ${login_url}
    TypeText                    Username                    ${username}
    TypeText                    Password                    ${password}
    ClickText                   Log In
    ${isMFA}=                   IsText                      Verify Your Identity        #Determines MFA is prompted
    Log To Console              ${isMFA}
    IF                          ${isMFA}                    #Conditional Statement for if MFA verification is required to proceed
        ${mfa_code}=            GetOTP                      ${username}                 ${sfuser_mfakey}            ${password}
        TypeSecret              Code                        ${mfa_code}
        ClickText               Verify
    END

Home
    [Documentation]             Navigate to homepage, login if needed
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.                 2
    Run Keyword If              ${login_status}             Login
    GoTo                        ${home_url}
    VerifyText                  Home


    # Example of custom keyword with robot fw syntax
VerifyStage
    [Documentation]             Verifies that stage given in ${text} is at ${selected} state; either selected (true) or not selected (false)
    [Arguments]                 ${text}                     ${selected}=true
    VerifyElement               //a[@title\="${text}" and @aria-checked\="${selected}"]


NoData
    VerifyNoText                ${data}                     timeout=3


DeleteData
    [Documentation]             RunBlock to remove all data until it doesn't exist anymore
    ClickText                   ${data}
    ClickText                   Delete
    VerifyText                  Are you sure you want to delete this account?
    ClickText                   Delete                      2
    VerifyText                  Undo
    VerifyNoText                Undo
    ClickText                   Accounts                    partial_match=False

Verify Font Size of Text
    [Documentation]             Verifies the px font size of a given text is as expected.
    [Arguments]                 ${text-to-find}             ${font-size-in-px}

    ${element} =                GetWebelement               ${text-to-find}             element_type=text
    ${elemFontSize} =           Call Method                 ${element}                  value_of_css_property       font-size
    Log To Console              message=Expected: ${font-size-in-px}, Actual: ${elemFontSize}
    Should Be True              "${elemFontSize}" == "${font-size-in-px}"

Find Available Timeslots
    [Documentation]             Loop until there is avalable time to make booking
    FOR                         ${i}                        IN RANGE                    10
        Sleep                   1s
        ${timeFound} =          IsNoText                    No times
        Exit For Loop If        ${timeFound}
        ClickText               No times
    END

Cancel If Similar Record Exists
    [Documentation]             Check if Similar Record already exist. If exist, click Cancel instead of Save
    ${similarRecordsExist}=     isText                      Similar Records Exist
    IF                          ${similarRecordsExist}
        ClickText               Cancel
    ELSE
        ClickText               Save                        partial_match=false
    END