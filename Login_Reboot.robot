*** Settings ***
Documentation     AN-110W LOGIN REBOOT TEST
Library           SeleniumLibrary

*** Variables ***
${LOGIN URL}      http://192.168.1.1/login.html
${BROWSER}        Chrome

*** Test Cases ***
Valid Login
    Open Browser To Login Page
    FOR    ${i}    IN RANGE    0    30
        Input Username    araknis  
        Input Password    snapav704
        Submit Credentials
        Welcome Page Should Be Open
        Wait For Reboot Button
        Reboot Router
        Wait For Confirm Reboot
        Click Confirm Reboot
        Reboot Timer
        Refresh Page After Reboot
    END
    [Teardown]    Close Browser

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Title Should Be    Araknis Router

Input Username
    [Arguments]    ${username}
    Input Text    //*[@id="username"]    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    password    ${password}

Submit Credentials
    Click Button    xpath=/html/body/div[1]/div/div/div/div/div[2]/div/div[2]/div[3]/input

Welcome Page Should Be Open
    Title Should Be    Araknis Router

Wait For Reboot Button
    ${condition} =     Run keyword And Return Status    Wait Until Page Contains Element    xpath=/html/body/div[1]/div[2]/div[1]/div[2]/a[1]/span    timeout=10   error=false

Reboot Router
    Click Element    xpath=/html/body/div[1]/div[2]/div[1]/div[2]/a[1]/span

Wait For Confirm Reboot
    ${check_element}=  Run Keyword and Return Status   Wait Until Page Contains Element    xpath=/html/body/div[5]/div/div/div[2]/button[2]    10s
    Run Keyword If      '${check_element}' == 'True'     Click Element  xpath=/html/body/div[5]/div/div/div[2]/button[2]
    # ${condition} =     Run keyword And Return Status    Wait Until Page Contains Element    xpath=//*[@id='system_restart']    timeout=5   error=false

Click Confirm Reboot
    Click Element   //*[contains(text(),'Restart')]

Reboot Timer
    Sleep    130 s   

Refresh Page After Reboot
    SeleniumLibrary.Reload Page