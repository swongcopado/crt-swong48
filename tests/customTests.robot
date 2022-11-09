*** Settings ***

Library    QWeb
Library    QVision
Resource                        ../resources/common.robot
Suite Setup                     Setup Browser
Suite Teardown                  End suite

*** Variables ***
${firstNameField}               db9255ac-ef5b-4447-8304-7d7a5af4bc95.first_name
${lastNameField}                db9255ac-ef5b-4447-8304-7d7a5af4bc95.last_name

*** Test Cases ***

Test Job Vacancies on GoodmanFielder

    Set Library Search Order        QWeb
    GoTo                        https://goodmanfielder.com/
    ClickText                   Careers
    ClickText                   View all job vacancies
    SwitchWindow                2
    ClickText                   Job Title:
    TypeText                    Job Title:                  Sales Engineer
    DropDown                    Position Type:              Full Time
    DropDown                    Category:                   Administration
    ClickText                   Search
    VerifyText                  There are opportunities matching your search criteria



Test Make a Will on Service Portal
    [Documentation]             Simulates a user clicking through the Service Victoria portal.
    
    Set Library Search Order        QWeb

    GoTo                        https://www.service.vic.gov.au/business/permits-and-licences
    Verify Font Size of Text    Find Business               40px
    ClickText                   FAQs
    ClickText                   What kind of support is available for small businesses?
    ClickText                   Find services
    ClickText                   Personal
    ClickText                   Make a Will
    Verify Font Size of Text    A legal Will lets your      24px
    ClickText                   Get Started
    SwitchWindow                2
    ClickText                   Book appointment
    #                           ClickText                   For myself
    ScrollTo                    Let's Talk
    VerifyText                  We're here to help you
    Verify Font Size of Text    We're here to help you      35.2px
    TypeText                    First Name*                 Test
    TypeText                    Last Name*                  User
    TypeText                    Phone*                      032233444
    TypeText                    Email*                      testuser@demo.com
    #                           ScrollText                  Select a Date & Time
    #                           Find Available Timeslots
    CloseWindow

Upload File to Account
    Appstate    Home
    Set Library Search Order        QWeb
    ClickText    Accounts
    ClickText    Recently Viewed    anchor=Accounts
    ClickText                       All Accounts
    ClickText                       Growmore
    ClickText                       Upload Files 
    QVision.ClickText               tests     
    QVision.ClickText               suite        
    QVision.DoubleClick             README.txt  
    ClickText                       Done
