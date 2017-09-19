*** Settings ***
Library  String
Library  DateTime
Library  polonex_helper.py


*** Variables ***
${sign_in}                                           id=loginbtn
${login_email}                                       id=loginform-username
${login_pass}                                        id=loginform-password
${prozorropage}                                      id=prozorropagebtn
${locator.title}                                     id=auction_title
${locator.dgfID}                                     id=info_dgfID
${locator.dgfDecisionDate}                           id=info_dgfDecisionDate
${locator.dgfDecisionID}                             id=info_dgfDecisionID
${locator.tenderAttempts}                            id=info_tenderAttempts
${locator.procurementMethodType}                     id=info_procurementMethodType
${locator.eligibilityCriteria}                       id=eligibilityCriteria_marker
${locator.status}                                    id=auction_status_name
${locator.description}                               id=info_description
${locator.minimalStep.amount}                        xpath=//td[contains(@id, 'info_minimalStep')]/span[contains(@class, 'amount')]
${locator.value.amount}                              xpath=//td[contains(@id, 'info_value')]/span[contains(@class, 'amount')]
${locator.value.currency}                            xpath=//td[contains(@id, 'info_value')]/span[contains(@class, 'currency')]
${locator.value.valueAddedTaxIncluded}               xpath=//td[contains(@id, 'info_value')]/span[contains(@class, 'tax')]
${locator.tenderId}                                  id=info_auctionID
${locator.procuringEntity.name}                      id=org_name
${locator.enquiryPeriod.startDate}                   id=enquiryPeriodDatastartDate
${locator.enquiryPeriod.endDate}                     id=enquiryPeriodDataendDate
${locator.tenderPeriod.startDate}                    id=tenderPeriodDatastartDate
${locator.tenderPeriod.endDate}                      id=tenderPeriodDataendDate

${locator.auctionPeriod.startDate}                   id=auctionPeriodDatastartDate
${locator.auctionPeriod.endDate}                     id=auctionPeriodDataendDate

${locator.proposition.value.amount}                  xpath=//div[contains(@class, 'userbidinfo')]/span[contains(@id, 'userbidamount')]


${locator.items[0].quantity}                         id=items[0]_quantity
${locator.items[0].description}                      id=items[0]_description
${locator.items[1].description}                      id=items[1]_description
${locator.items[2].description}                      id=items[2]_description
${locator.items[3].description}                      id=items[3]_description
${locator.items[0].unit.code}                        id=items[0]_unit_code
${locator.items[0].unit.name}                        id=items[0]_unit_name
${locator.items[0].deliveryAddress.postalCode}       id=item[0]deliveryAddress_postalCode
${locator.items[0].deliveryAddress.countryName}      id=item[0]deliveryAddress_countryName
${locator.items[0].deliveryAddress.region}           id=item[0]deliveryAddress_region
${locator.items[0].deliveryAddress.locality}         id=item[0]deliveryAddress_locality
${locator.items[0].deliveryAddress.streetAddress}    id=item[0]deliveryAddress_streetAddress
${locator.items[0].deliveryLocation.latitude}        id=items[0]_deliveryLocation_latitude
${locator.items[0].deliveryLocation.longitude}       id=items[0]_deliveryLocation_longitude
${locator.items[0].deliveryDate.endDate}             id=item[0]deliveryDate_endDate
${locator.items[0].classification.scheme}            id=classification_scheme
${locator.items[0].classification.id}                id=classification_id
${locator.items[0].classification.description}       id=classification_description
${locator.questions[0].title}                        id=q[0]title
${locator.questions[0].description}                  id=q[0]description
${locator.questions[0].date}                         id=q[0]date
${locator.questions[0].answer}                       id=q[0]answer

${locator.cancellations[0].status}                   id=cancell_status
${locator.cancellations[0].reason}                   id=cancell_reason

${locator.cancelldoc.title}                          xpath=//div[contains(@class, 'fg_modal_title')]
${locator.cancelldoc.description}                    xpath=//div[contains(@class, 'fg_modal_description')]

*** Keywords ***
Підготувати клієнт для користувача
    [Arguments]     @{ARGUMENTS}
    [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
    Open Browser  ${USERS.users['${ARGUMENTS[0]}'].homepage}  ${USERS.users['${ARGUMENTS[0]}'].browser}  alias=${ARGUMENTS[0]}
    Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
    Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
    Run Keyword If   '${ARGUMENTS[0]}' != 'polonex_viewer'   Login   ${ARGUMENTS[0]}

Login
    [Arguments]  @{ARGUMENTS}
    Click Element        xpath=//li[contains(@id, 'loginbtn')]/a
    Sleep   2
    Clear Element Text   id=loginform-username
    Input text      ${login_email}      ${USERS.users['${ARGUMENTS[0]}'].login}
    Input text      ${login_pass}       ${USERS.users['${ARGUMENTS[0]}'].password}
    Click Button    name=login-button
    Sleep   2
    Click Element   ${prozorropage}

Підготувати дані для оголошення тендера
    [Documentation]  Це слово використовується в майданчиків, тому потрібно, щоб воно було і тут
    [Arguments]  ${username}  ${tender_data}  ${role_name}
    [return]  ${tender_data}

Створити тендер
  [Arguments]  ${username}  ${tender_data}
    Log  ${tender_data}

    ${tender-title}                                     Get From Dictionary    ${tender_data.data}                                 title
    ${tender-description}                               Get From Dictionary    ${tender_data.data}                                 description
    ${tender-tenderID}                                  Get From Dictionary    ${tender_data.data}                                 tenderID
    ${tender-procuringEntity-name}                      Get From Dictionary    ${tender_data.data.procuringEntity}                 name
    ${tender-procuringEntity-identifier-scheme}         Get From Dictionary    ${tender_data.data.procuringEntity.identifier}      scheme
    ${tender-procuringEntity-identifier-id}             Get From Dictionary    ${tender_data.data.procuringEntity.identifier}      id
    ${tender-procuringEntity-identifier-legalName}      Get From Dictionary    ${tender_data.data.procuringEntity.identifier}      legalName
    ${tender-procuringEntity-identifier-uri}            Get From Dictionary    ${tender_data.data.procuringEntity.identifier}      uri
    ${tender-procuringEntity-address-streetAddress}     Get From Dictionary    ${tender_data.data.procuringEntity.address}         streetAddress
    ${tender-procuringEntity-address-locality}          Get From Dictionary    ${tender_data.data.procuringEntity.address}         locality
    ${tender-procuringEntity-address-region}            Get From Dictionary    ${tender_data.data.procuringEntity.address}         region
    ${tender-procuringEntity-address-postalCode}        Get From Dictionary    ${tender_data.data.procuringEntity.address}         postalCode
    ${tender-procuringEntity-address-countryName}       Get From Dictionary    ${tender_data.data.procuringEntity.address}         countryName
    ${tender-procuringEntity-contactPoint-name}         Get From Dictionary    ${tender_data.data.procuringEntity.contactPoint}    name
    ${tender-procuringEntity-contactPoint-email}        Get From Dictionary    ${tender_data.data.procuringEntity.contactPoint}    email
    ${tender-procuringEntity-contactPoint-telephone}    Get From Dictionary    ${tender_data.data.procuringEntity.contactPoint}    telephone
    ${tender-procuringEntity-contactPoint-faxNumber}    Get From Dictionary    ${tender_data.data.procuringEntity.contactPoint}    faxNumber
    ${tender-procuringEntity-contactPoint-url}          Get From Dictionary    ${tender_data.data.procuringEntity.contactPoint}    url
    ${tender-procuringEntity-kind}                      Get From Dictionary    ${tender_data.data.procuringEntity}                 kind
    ${tender-value-amount}                              Get From Dictionary    ${tender_data.data.value}                           amount
    ${tender-value-currency}                            Get From Dictionary    ${tender_data.data.value}                           currency
    ${tender-value-valueAddedTaxIncluded}               Get From Dictionary    ${tender_data.data.value}                           valueAddedTaxIncluded
    ${tender-guarantee-amount}                          Get From Dictionary    ${tender_data.data.guarantee}                       amount
    ${tender-guarantee-currency}                        Get From Dictionary    ${tender_data.data.guarantee}                       currency
    ${tender-minimalStep-amount}                        Get From Dictionary    ${tender_data.data.minimalStep}                     amount
    ${tender-minimalStep-currency}                      Get From Dictionary    ${tender_data.data.minimalStep}                     currency
    ${tender-minimalStep-valueAddedTaxIncluded}         Get From Dictionary    ${tender_data.data.minimalStep}                     valueAddedTaxIncluded

    ${tender-value-amount}=           Convert To String    ${tender-value-amount}
    ${tender-guarantee-amount}=       Convert To String    ${tender-guarantee-amount}
    ${tender-minimalStep-amount}=     Convert To String    ${tender-minimalStep-amount}
    ${tender-procuringEntity-kind}=   Convert To String    ${tender-procuringEntity-kind}


    Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
    Sleep   2
    Click Element       xpath=//a[contains(@id, 'addtenderbtn')]
    Sleep   4

    Input text          id=tender-title                                      ${tender-title}
    Input text          id=tender-description                                ${tender-description}
    Input text          id=tender-tenderID                                   ${tender-tenderID}
    Input text          id=tender-procuringEntity-name                       ${tender-procuringEntity-name}
    Select From List    id=tender-procuringEntity-identifier-scheme          ${tender-procuringEntity-identifier-scheme}
    Input text          id=tender-procuringEntity-identifier-id              ${tender-procuringEntity-identifier-id}
    Input text          id=tender-procuringEntity-identifier-legalName       ${tender-procuringEntity-identifier-legalName}
    Input text          id=tender-procuringEntity-identifier-uri             ${tender-procuringEntity-identifier-uri}
    Input text          id=tender-procuringEntity-address-streetAddress      ${tender-procuringEntity-address-streetAddress}
    Input text          id=tender-procuringEntity-address-locality           ${tender-procuringEntity-address-locality}
    Input text          id=tender-procuringEntity-address-region             ${tender-procuringEntity-address-region}
    Input text          id=tender-procuringEntity-address-postalCode         ${tender-procuringEntity-address-postalCode}
    Input text          id=tender-procuringEntity-address-countryName        ${tender-procuringEntity-address-countryName}
    Input text          id=tender-procuringEntity-contactPoint-name          ${tender-procuringEntity-contactPoint-name}
    Input text          id=tender-procuringEntity-contactPoint-email         ${tender-procuringEntity-contactPoint-email}
    Input text          id=tender-procuringEntity-contactPoint-telephone     ${tender-procuringEntity-contactPoint-telephone}
    Input text          id=tender-procuringEntity-contactPoint-faxNumber     ${tender-procuringEntity-contactPoint-faxNumber}
    Input text          id=tender-procuringEntity-contactPoint-url           ${tender-procuringEntity-contactPoint-url}
    Select From List    id=tender-procuringEntity-kind                       ${tender-procuringEntity-kind}
    Input text          id=tender-value-amount                               ${tender-value-amount}
    Select From List    id=tender-value-currency                             ${tender-value-currency}
    Select From List    id=tender-value-valueAddedTaxIncluded                ${tender-value-valueAddedTaxIncluded}
    Input text          id=tender-guarantee-amount                           ${tender-guarantee-amount}
    Select From List    id=tender-guarantee-currency                         ${tender-guarantee-currency}
    Input text          id=tender-minimalStep-amount                         ${tender-minimalStep-amount}
    Select From List    id=tender-minimalStep-currency                       ${tender-minimalStep-currency}
    Select From List    id=tender-minimalStep-valueAddedTaxIncluded          ${tender-minimalStep-valueAddedTaxIncluded}

    polonex.Додати предмети      ${items}

    Click Element   id=add-tender-form-save
    Wait Until Element Is Visible       id=info_auctionID      30
    ${tender_uaid}=     Get Text       id=info_auctionID
    [Return]    ${tender_uaid}


Додати предмети
    [Arguments]  ${items}
    ${Items_length}=   Get Length   ${items}
    :FOR   ${index}   IN RANGE   ${Items_length}
    \   polonex.Додати предмет   ${items[${index}]}     ${index}

Додати предмет
    [Arguments]  ${item}  ${index}
    ${index}=  Convert To Integer  ${index}
    Run Keyword If  ${index} != 0   Click Element   id=additem
    Run Keyword If  ${index} != 0   Sleep           4
    Input text          id=tender-items-${index}-id                                  ${item.id}
    Input text          id=tender-items-${index}-description                         ${item.description}
    Execute Javascript  $("#tender-items-${index}-classification-id").val("${item.classification.id}");
    Execute Javascript  $("#additemform-${index}-classification_id").trigger("change");
    Select From List    id=tender-items-${index}-unit-code                           ${item.unit.code}
    Input text          id=tender-items-${index}-quantity                            ${item.quantity}
    Input text          id=tender-items-${index}-deliveryDate-startDate              ${item.deliveryDate.startDate}
    Input text          id=tender-items-${index}-deliveryDate-endDate                ${item.deliveryDate.endDate}
    Input text          id=tender-items-${index}-deliveryAddress-streetAddress       ${item.deliveryAddress.streetAddress}
    Input text          id=tender-items-${index}-deliveryAddress-locality            ${item.deliveryAddress.locality}
    Input text          id=tender-items-${index}-deliveryAddress-region              ${item.deliveryAddress.region}
    Input text          id=tender-items-${index}-deliveryAddress-postalCode          ${item.deliveryAddress.postalCode}
    Input text          id=tender-items-${index}-deliveryAddress-countryName         ${item.deliveryAddress.countryName}
    Input text          id=tender-items-${index}-deliveryLocation-latitude           ${item.deliveryLocation.latitude}
    Input text          id=tender-items-${index}-deliveryLocation-longitude          ${item.deliveryLocation.longitude}
    Input text          id=tender-items-${index}-deliveryLocation-elevation          ${item.deliveryLocation.elevation}

Завантажити документ до тендеру
    [Arguments]   ${file}
    Log  ${file}

Завантажити документ
    [Arguments]  ${username}  ${filepath}  ${tender_uaid}
    Choose File     xpath=//input[contains(@id, "doc_upload_field_biddingDocuments")]   ${filepath}

Set Multi Ids
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...      ${ARGUMENTS[0]} ==  ${tender_UAid}
    Log  ${ARGUMENTS[0]}
    ${id}=           Get Text           id=mForm:nBid
    ${Ids}   Create List    ${tender_UAid}   ${id}

Пошук тендера по ідентифікатору
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...      ${ARGUMENTS[0]} ==  username
    ...      ${ARGUMENTS[1]} ==  ${tender_uaid}
    Switch browser   ${ARGUMENTS[0]}
    Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
    Sleep  2
    Click Element       name=more-search-btn
    Sleep  2
    Input Text          id=proauctionssearch-tenderid   ${ARGUMENTS[1]}
    Sleep  2
    Click Element       name=search-btn
    Sleep  5
    Click Element     xpath=(//a[contains(@class, 'tender_detail_btn')])
    Wait Until Element Is Visible       id=info   30

Отримати інформацію із тендера
    [Arguments]  ${username}  ${tender_uaid}  ${field_name}
    ${return_value}=  Отримати інформацію про ${field_name}
    [Return]  ${return_value}

Отримати текст із поля і показати на сторінці
    [Arguments]   ${fieldname}
    ${return_value}=   Get Text  ${locator.${fieldname}}
    [Return]  ${return_value}

Отримати інформацію про title
    ${return_value}=   Отримати текст із поля і показати на сторінці   title
    [Return]  ${return_value}

Отримати інформацію про dgfID
    ${return_value}=   Отримати текст із поля і показати на сторінці   dgfID
    [Return]  ${return_value}

Отримати інформацію про dgfDecisionDate
    ${return_value}=   Отримати текст із поля і показати на сторінці   dgfDecisionDate
    [Return]  ${return_value}

Отримати інформацію про dgfDecisionID
    ${return_value}=   Отримати текст із поля і показати на сторінці   dgfDecisionID
    [Return]  ${return_value}

Отримати інформацію про tenderAttempts
    ${return_value}=   Отримати текст із поля і показати на сторінці   tenderAttempts
    [Return]  ${return_value}

Отримати інформацію про eligibilityCriteria
    ${return_value}=   Отримати текст із поля і показати на сторінці   eligibilityCriteria
    [Return]  ${return_value}

Отримати інформацію про status
    reload page
    ${return_value}=   Отримати текст із поля і показати на сторінці   status
    ${return_value}=   convert_polonex_string     ${return_value}
    [Return]  ${return_value}

Отримати інформацію про description
    ${return_value}=   Отримати текст із поля і показати на сторінці   description
    [Return]  ${return_value}

Отримати інформацію про procurementMethodType
    ${return_value}=   Отримати текст із поля і показати на сторінці   procurementMethodType
    ${return_value}=   convert_polonex_string     ${return_value}
    [Return]  ${return_value}

Отримати інформацію про value.amount
    ${return_value}=   Отримати текст із поля і показати на сторінці  value.amount
    ${return_value}=   Convert To Number   ${return_value}
    [Return]  ${return_value}

Отримати інформацію про minimalStep.amount
    ${return_value}=   Отримати текст із поля і показати на сторінці   minimalStep.amount
    ${return_value}=   Convert To Number   ${return_value}
    [Return]   ${return_value}

Отримати інформацію про items[0].quantity
    ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].quantity
    ${return_value}=   Convert To Number   ${return_value}
    [Return]  ${return_value}

Отримати інформацію про items[0].unit.code
    ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].unit.code
    ${return_value}=   Convert To String     ${return_value}
    [Return]  ${return_value}

Отримати інформацію про items[0].unit.name
    ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].unit.name
    ${return_value}=   Convert To String     ${return_value}
    [Return]   ${return_value}

Отримати інформацію про value.currency
    ${return_value}=   Отримати текст із поля і показати на сторінці  value.currency
    ${return_value}=   Convert To String     ${return_value}
    ${return_value}=   convert_polonex_string      ${return_value}
    [Return]  ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
    ${return_value}=   Отримати текст із поля і показати на сторінці  value.valueAddedTaxIncluded
    ${return_value}=   convert_polonex_string      ${return_value}
    [Return]  ${return_value}

Отримати інформацію про auctionId
    ${return_value}=   Отримати текст із поля і показати на сторінці   tenderId
    [Return]  ${return_value}

Отримати інформацію про procuringEntity.name
    ${return_value}=   Отримати текст із поля і показати на сторінці   procuringEntity.name
    [Return]  ${return_value}

Отримати інформацію про tenderPeriod.startDate
    ${return_value}=    Отримати текст із поля і показати на сторінці  tenderPeriod.startDate
    ${return_value}=   convert_polonex_date_to_iso_format   ${return_value}
    ${return_value}=   add_timezone_to_date   ${return_value.split('.')[0]}
    [Return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
    ${return_value}=   Отримати текст із поля і показати на сторінці  tenderPeriod.endDate
    ${return_value}=   convert_polonex_date_to_iso_format   ${return_value}
    ${return_value}=   add_timezone_to_date   ${return_value.split('.')[0]}
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
    ${return_value}=   Отримати текст із поля і показати на сторінці  enquiryPeriod.startDate
    ${return_value}=   convert_polonex_date_to_iso_format   ${return_value}
    ${return_value}=   add_timezone_to_date   ${return_value.split('.')[0]}
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.endDate
    ${return_value}=   Отримати текст із поля і показати на сторінці  enquiryPeriod.endDate
    ${return_value}=   convert_polonex_date_to_iso_format   ${return_value}
    ${return_value}=   add_timezone_to_date   ${return_value.split('.')[0]}
    [Return]  ${return_value}

Отримати інформацію про auctionPeriod.startDate
    ${return_value}=   Отримати текст із поля і показати на сторінці  auctionPeriod.startDate
    ${return_value}=   convert_polonex_date_to_iso_format   ${return_value}
    ${return_value}=   add_timezone_to_date   ${return_value.split('.')[0]}
    [return]  ${return_value}

Отримати інформацію про auctionPeriod.endDate
    ${return_value}=   Отримати текст із поля і показати на сторінці  auctionPeriod.endDate
    ${return_value}=   convert_polonex_date_to_iso_format   ${return_value}
    ${return_value}=   add_timezone_to_date   ${return_value.split('.')[0]}
    [Return]  ${return_value}

Отримати інформацію про items[0].description
    ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].description
    [Return]  ${return_value}

Отримати інформацію про items[0].classification.id
    ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].classification.id
    [Return]  ${return_value}

Отримати інформацію про items[0].classification.scheme
    ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].classification.scheme
    [Return]  ${return_value}

Отримати інформацію про items[0].classification.description
    ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].classification.description
    ${return_value}=   Convert To String     ${return_value}
    [Return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.countryName
    ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.countryName
    [Return]      ${return_value}

Отримати інформацію про items[0].deliveryAddress.postalCode
    ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.postalCode
    [Return]      ${return_value}

Отримати інформацію про items[0].deliveryAddress.region
    ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.region
    [Return]   ${return_value}

Отримати інформацію про items[0].deliveryAddress.locality
    ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.locality
    [Return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.streetAddress
    ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.streetAddress
    [Return]  ${return_value}

Отримати інформацію про items[0].deliveryDate.endDate
    ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryDate.endDate
    [Return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
    ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].deliveryLocation.latitude
    ${return_value}=   Convert To Number   ${return_value}
    [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
    ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].deliveryLocation.longitude
    ${return_value}=   Convert To Number   ${return_value}
    [return]  ${return_value}

Отримати інформацію про questions[0].title
    ${return_value}=  Get text          ${locator.questions[0].title}
    [Return]  ${return_value}

Отримати інформацію про questions[0].description
    ${return_value}=   Отримати текст із поля і показати на сторінці   questions[0].description
    [Return]  ${return_value}

Отримати інформацію про questions[0].date
    ${return_value}=   Отримати текст із поля і показати на сторінці   questions[0].date
    [Return]  ${return_value}

Отримати інформацію про questions[0].answer
    ${return_value}=  Get text          ${locator.questions[0].answer}
    [Return]  ${return_value}

Отримати інформацію про cancellations[0].status
    ${return_value}=  Get text          ${locator.cancellations[0].status}
    [Return]  ${return_value}

Отримати інформацію про cancellations[0].reason
    ${return_value}=  Get text          ${locator.cancellations[0].reason}
    [Return]  ${return_value}

Внести зміни в тендер
    [Arguments]  ${username}  ${tender_uaid}  ${field_name}  ${field_value}
    polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Click Element     id=update_tender_btn
    Sleep   2
    Input text  name=tender-[${field_name}]  ${field_value}
    Click Button    id=add-tender-form-save
    Wait Until Page Contains  ${field_value}  30

Задати питання
    [Arguments]  ${username}  ${tender_uaid}  ${question}
    ${title}=        Get From Dictionary  ${question.data}  title
    ${description}=  Get From Dictionary  ${question.data}  description
    Click Element         id=add_question_btn
    Sleep  2
    Input Text          id=addquestionform-title          ${title}
    Input Text          id=addquestionform-description    ${description}
    Sleep  2
    Click Element       id=submit_add_question_form
    Wait Until Page Contains  ${title}  30

Оновити сторінку з тендером
    [Arguments]  ${username}  ${tender_uaid}
    Switch browser   ${username}
    Go to   ${USERS.users['${username}'].syncpage}
    Go to   ${USERS.users['${username}'].homepage}
    polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}

Подати цінову пропозицію
    [Arguments]  ${username}  ${tender_uaid}  ${test_bid_data}
    ${amount}=    Get From Dictionary     ${test_bid_data.data.value}    amount
    ${amount}=    Convert To String       ${amount}
    polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Click Element       id=add_bid_btn
    Sleep   2
    Input Text          id=addbidform-sum       ${amount}
    Sleep   4
    Click Element       id=submit_add_bid_form
    Wait Until Element Is Visible       id=userbidamount   30
    ${resp}=    Get Text      id=userbidamount
    [Return]    ${resp}

Скасувати цінову пропозицію
    [Arguments]  ${username}  ${tender_uaid}  ${bid}
    polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Click Element       id=cansel-bid

Відповісти на питання
    [Arguments]  ${username}  ${tender_uaid}  ${answer_data}  ${question_id}
    ${index}=   Get Element Attribute   xpath=//div[contains(text(), '${question_id}')]@id
    ${index}=   Get Substring   ${index}    2   3
    Click Element                         xpath=//a[contains(@id, 'add_answer_btn_${index}')]
    Sleep     4
    Input Text                            id=addanswerform-answer        ${answer_data.data.answer}
    Sleep     2
    Click Button                        id=submit_add_answer_form
    Wait Until Page Contains   ${answer_data.data.answer}   10

Отримати посилання на аукціон для глядача
    [Arguments]  ${username}  ${tender_uaid}
    polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    ${result}=  Get Element Attribute  id=show_public_btn@href
    [Return]   ${result}

Отримати посилання на аукціон для учасника
    [Arguments]  ${username}  ${tender_uaid}
    polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    ${result}=                  Get Element Attribute               id=show_private_btn@href
    [Return]   ${result}

Змінити цінову пропозицію
    [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
    polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Click Element       id=edit_user_bid
    Sleep   2
    ${newsum}=          Convert To String       ${fieldvalue}
    Input Text          id=addbidform-sum       ${newsum}
    Click Element       id=submit_add_bid_form
    Sleep   10
    ${resp}=    Get Text      id=userbidamount
    [Return]    ${resp}

Завантажити документ в ставку
    [Arguments]  ${username}  ${path}  ${tender_uaid}  ${doc_type}=documents
    Sleep   30
    polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Click Element   id=edit_user_bid
    Sleep   2
    Choose File     xpath=//input[contains(@id, 'bid_doc_upload_fieldcommercialProposal')]   ${path}
    sleep   4
    Click Element   id=submit_add_bid_form

Змінити документ в ставці
    [Arguments]  ${username}  ${path}  ${bidid}  ${docid}
    Click Element   id=file_edit_0
    Sleep   2
    Choose File     xpath=//input[contains(@id, 'prouploadform-filedata')]   ${path}
    sleep   2
    Click Element   id=submit_add_file_form
