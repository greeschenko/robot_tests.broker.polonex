*** Settings ***
Library     Selenium2Screenshots
Library     String
Library     DateTime
Library     Selenium2Library
Library     Collections
Library     polonex_helper.py


*** Variables ***
${sign_in}                                                      id=lbtn-mobile
###${sign_in}                                                      id=loginbtn
${login_email}                                                  id=loginform-username
${login_pass}                                                   id=loginform-password
${prozorropage}                                                 id=prozorropagebtn
${locator.title}                                                id=auction_title
${locator.dgfID}                                                id=info_dgfID
${locator.status}                                               id=auction_status_name
${locator.description}                                          id=info_description
${locator.minimalStep.amount}                                   xpath=//td[contains(@id, 'info_minimalStep')]/span[contains(@class, 'amount')]
${locator.value.amount}                                         xpath=//td[contains(@id, 'info_value')]/span[contains(@class, 'amount')]
${locator.value.currency}                                       xpath=//td[contains(@id, 'info_value')]/span[contains(@class, 'currency')]
${locator.value.valueAddedTaxIncluded}                          xpath=//td[contains(@id, 'info_value')]/span[contains(@class, 'tax')]
${locator.tenderId}                                             id=info_tenderID
${locator.procuringEntity.name}                                 id=org_name
${locator.enquiryPeriod.startDate}                              id=enquiryPeriodDatastartDate
${locator.enquiryPeriod.endDate}                                id=enquiryPeriodDataendDate
${locator.tenderPeriod.startDate}                               id=tenderPeriodDatastartDate
${locator.tenderPeriod.endDate}                                 id=tenderPeriodDataendDate

${locator.auctionPeriod.startDate}                              id=auctionPeriodDatastartDate
${locator.auctionPeriod.endDate}                                id=auctionPeriodDataendDate

${locator.proposition.value.amount}                             xpath=//div[contains(@class, 'userbidinfo')]/span[contains(@id, 'userbidamount')]


${locator.items[0].quantity}                                    id=items[0]_quantity
${locator.items[0].description}                                 id=items[0]_description
${locator.items[0].unit.code}                                   id=items[0]_unit_code
${locator.items[0].unit.name}                                   id=items[0]_unit_name
${locator.items[0].deliveryAddress.postalCode}                  id=items[0]_deliveryAddress_postalCode
${locator.items[0].deliveryAddress.countryName}                 id=items[0]_deliveryAddress_countryName
${locator.items[0].deliveryAddress.region}                      id=items[0]_deliveryAddress_region
${locator.items[0].deliveryAddress.locality}                    id=items[0]_deliveryAddress_locality
${locator.items[0].deliveryAddress.streetAddress}               id=items[0]_deliveryAddress_streetAddress
${locator.items[0].deliveryLocation.latitude}                   id=items[0]_deliveryLocation_latitude
${locator.items[0].deliveryLocation.longitude}                  id=items[0]_deliveryLocation_longitude
${locator.items[0].deliveryDate.startDate}                      id=items[0]_deliveryDate_startDate
${locator.items[0].deliveryDate.endDate}                        id=items[0]_deliveryDate_endDate
${locator.items[0].classification.scheme}                       id=items[0]_classification_scheme
${locator.items[0].classification.id}                           id=items[0]_classification_id
${locator.items[0].classification.description}                  id=items[0]_classification_description
${locator.questions[0].title}                                   xpath=//div[@id="q[0]title"]
${locator.questions[0].description}                             xpath=//div[@id="q[0]description"]
${locator.questions[0].date}                                    id=q[0]date
${locator.questions[0].answer}                                  id=q[0]answer

${locator.milestones[0].code}                                   id=milestones[0]_code
${locator.milestones[0].title}                                  id=milestones[0]_title
${locator.milestones[0].percentage}                             id=milestones[0]_percentage
${locator.milestones[0].duration.days}                          id=milestones[0]_duration_days
${locator.milestones[0].duration.type}                          id=milestones[0]_duration_type

${locator.milestones[1].code}                                   id=milestones[1]_code
${locator.milestones[1].title}                                  id=milestones[1]_title
${locator.milestones[1].percentage}                             id=milestones[1]_percentage
${locator.milestones[1].duration.days}                          id=milestones[1]_duration_days
${locator.milestones[1].duration.type}                          id=milestones[1]_duration_type

${locator.milestones[2].code}                                   id=milestones[2]_code
${locator.milestones[2].title}                                  id=milestones[2]_title
${locator.milestones[2].percentage}                             id=milestones[2]_percentage
${locator.milestones[2].duration.days}                          id=milestones[2]_duration_days
${locator.milestones[2].duration.type}                          id=milestones[2]_duration_type


${locator.awards[0].complaintPeriod.endDate}                    xpath=//td[contains(@class, 'complaintPeriodData_wrap')]/span[contains(@class, 'endDate')]

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
  Click Element        ${sign_in}
  Sleep   2
  Clear Element Text   id=loginform-username
  Input text      ${login_email}      ${USERS.users['${ARGUMENTS[0]}'].login}
  Input text      ${login_pass}       ${USERS.users['${ARGUMENTS[0]}'].password}
  Click Button    name=login-button
  Sleep   2
  Click Element   ${prozorropage}
  Sleep   2

Підготувати дані для оголошення тендера
  [Documentation]  Це слово використовується в майданчиків, тому потрібно, щоб воно було і тут
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  [return]  ${tender_data}

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data

  log to console  ${ARGUMENTS[1]}

###data:
###    description: Постояльний висмівати подубнути бердник прахтика атака дешперувати.
###    description_en: Quos quasi natus quos quo temporibus provident distinctio fuga
###        neque quis.
###    description_ru: Вим ёнанй факёльиси пырикульа ажжынтиор элыктрам кибо вэртырэм
###        мэльёуз инимёкюж тамквюам вёжи фырре.
###    enquiryPeriod:
###        endDate: '2018-04-12T21:54:57.290333+03:00'
###        startDate: '2018-04-12T21:34:57.290333+03:00'
###    items:
###    -   additionalClassifications:
###        -   description: Журнали реєстраційні, бухгалтерські книги, швидкозшивачі,
###                формуляри та інші канцелярські вироби, паперові чи картонні
###            id: 17.23.13
###            scheme: ДКПП
###        classification:
###            description: Паперові чи картонні реєстраційні журнали, бухгалтерські
###                книги, швидкозшивачі, бланки та інші паперові канцелярські вироби
###            id: 22800000-8
###            scheme: ДК021
###        deliveryAddress:
###            countryName: Україна
###            countryName_en: Ukraine
###            countryName_ru: Украина
###            locality: Дніпро
###            postalCode: '51925'
###            region: Дніпропетровська область
###            streetAddress: проспект Карла Маркса, 52
###        deliveryDate:
###            endDate: '2018-04-22T21:34:57.293998+03:00'
###            startDate: '2018-04-22T21:34:57.293924+03:00'
###        deliveryLocation:
###            latitude: 48.465356
###            longitude: 35.045667
###        description: 'i-ae515033: Бланки та журнали відповідної форми (наведені в
###            додатку)'
###        description_en: 'i-88b6b39b: Form and journals in appropriate form (listed
###            in Annex)'
###        description_ru: 'i-3dda8ebc: Бланки и журналы соответствующей формы (приведены
###            в приложении)'
###        quantity: 6
###        unit:
###            code: LO
###            name: лот
###    minimalStep:
###        amount: 1050824.42
###        currency: UAH
###    mode: test
###    procurementMethodDetails: quick, accelerator=1440
###    procuringEntity:
###        address:
###            countryName: Україна
###            locality: Переяслав-Хмельницький
###            postalCode: '01030'
###            region: Київська область
###            streetAddress: Богдана Хмельницького вулиця, 21-29
###        contactPoint:
###            email: buh510@ukr.net
###            faxNumber: '2343591'
###            name: Ліповець Євген Іванович
###            telephone: '2341170'
###            url: http://www.shev.gov.ua/
###        identifier:
###            id: '21725150'
###            legalName: Шевченківська районна в місті Києві державна адміністрація
###            scheme: UA-EDR
###        kind: other
###        name: Шевченківська районна в місті Києві державна адміністрація
###    status: draft
###    submissionMethodDetails: quick
###    tenderPeriod:
###        endDate: '2018-04-12T22:24:57.290333+03:00'
###        startDate: '2018-04-12T21:54:57.290333+03:00'
###    title: '[ТЕСТУВАННЯ] Хобза свистіння здирати.'
###    title_en: '[TESTING] Business-focused 5thgeneration challenge'
###    title_ru: '[ТЕСТИРОВАНИЕ] Progressive incremental knowledgebase'
###    value:
###        amount: 70592965.48
###        currency: UAH
###        valueAddedTaxIncluded: true


    ${mainProcurementCategory}=              Get From Dictionary         ${ARGUMENTS[1].data}                   mainProcurementCategory
    ${title}=                                Get From Dictionary         ${ARGUMENTS[1].data}                   title
    ${description}=                          Get From Dictionary         ${ARGUMENTS[1].data}                   description
    ${minimalstep_amount}=                   Get From Dictionary         ${ARGUMENTS[1].data.minimalStep}       amount
    ${minimalstep_currency}=                 Get From Dictionary         ${ARGUMENTS[1].data.minimalStep}       currency
    ${value_amount}=                         Get From Dictionary         ${ARGUMENTS[1].data.value}             amount
    ${value_currency}=                       Get From Dictionary         ${ARGUMENTS[1].data.value}             currency
    ${value_valueaddedtaxincluded}=          Convert To String           ${ARGUMENTS[1].data.value.valueAddedTaxIncluded}
    ${value_valueaddedtaxincluded}=          convert_polonex_string      ${value_valueaddedtaxincluded}
    ${items}=                                Get From Dictionary         ${ARGUMENTS[1].data}                   items
    ${milestones}=                           Get From Dictionary         ${ARGUMENTS[1].data}                   milestones
    ${item0}=                                Get From List               ${items}                               0
    ${item_description}=                     Get From Dictionary         ${item0}                               description
    ${classification_scheme}=                Get From Dictionary         ${item0.classification}                scheme
    ${classification_description}=           Get From Dictionary         ${item0.classification}                description
    ${classification_id}=                    Get From Dictionary         ${item0.classification}                id

    ${adCls_isset}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${item0}  additionalClassifications

    ${additionalClassifications}=              Run Keyword If  ${adCls_isset}  Get From Dictionary         ${item0}                               additionalClassifications
    ${additionalClassifications0}=             Run Keyword If  ${adCls_isset}  Get From List               ${additionalClassifications}           0
    ${additionalClassification_scheme}=        Run Keyword If  ${adCls_isset}  Get From Dictionary         ${additionalClassifications0}          scheme
    ${additionalClassification_description}=   Run Keyword If  ${adCls_isset}  Get From Dictionary         ${additionalClassifications0}          description
    ${additionalClassification_id}=            Run Keyword If  ${adCls_isset}  Get From Dictionary         ${additionalClassifications0}          id

    ${deliveryaddress_postalcode}=           Get From Dictionary         ${item0.deliveryAddress}               postalCode
    ${deliveryaddress_countryname}=          Get From Dictionary         ${item0.deliveryAddress}               countryName
    ${deliveryaddress_streetaddress}=        Get From Dictionary         ${item0.deliveryAddress}               streetAddress
    ${deliveryaddress_region}=               Get From Dictionary         ${item0.deliveryAddress}               region
    ${deliveryaddress_locality}=             Get From Dictionary         ${item0.deliveryAddress}               locality

    ${deliverydate_startdate}=               Get From Dictionary         ${item0.deliveryDate}                  startDate
    ${deliverydate_enddate}=                 Get From Dictionary         ${item0.deliveryDate}                  endDate

    ${deliverylocation_latitude}=            Get From Dictionary         ${item0.deliveryLocation}              latitude
    ${deliverylocation_longitude}=           Get From Dictionary         ${item0.deliveryLocation}              longitude

    ${unit_code}=                            Get From Dictionary         ${item0.unit}                          code
    ${unit_name}=                            Get From Dictionary         ${item0.unit}                          name
    ${quantity}=                             Get From Dictionary         ${item0}                               quantity

    ${procuringEntity}=                      Get From Dictionary         ${ARGUMENTS[1].data}                   procuringEntity

    ${procuringEntity_address_countryName}=      Get From Dictionary     ${procuringEntity.address}            countryName
    ${procuringEntity_address_locality}=         Get From Dictionary     ${procuringEntity.address}            locality
    ${procuringEntity_address_postalCode}=       Get From Dictionary     ${procuringEntity.address}            postalCode
    ${procuringEntity_address_region}=           Get From Dictionary     ${procuringEntity.address}            region
    ${procuringEntity_address_streetAddress}=    Get From Dictionary     ${procuringEntity.address}            streetAddress
    ${procuringEntity_contactPoint_name}=        Get From Dictionary     ${procuringEntity.contactPoint}       name
    ${procuringEntity_contactPoint_telephone}=   Get From Dictionary     ${procuringEntity.contactPoint}       telephone

    ${procuringEntity_contactPoint_email}=       Get From Dictionary     ${procuringEntity.contactPoint}       email
    ${procuringEntity_contactPoint_faxNumber}=   Get From Dictionary     ${procuringEntity.contactPoint}       faxNumber
    ${procuringEntity_contactPoint_url}=         Get From Dictionary     ${procuringEntity.contactPoint}       url

    ${procuringEntity_identifier_id}=            Get From Dictionary     ${procuringEntity.identifier}         id
    ${procuringEntity_identifier_scheme}=        Get From Dictionary     ${procuringEntity.identifier}         scheme
    ${procuringEntity_identifier_legalName}=     Get From Dictionary     ${procuringEntity.identifier}         legalName
    ${procuringEntity_kind}=                     Get From Dictionary     ${procuringEntity}                    kind
    ${procuringEntity_name}=                     Get From Dictionary     ${procuringEntity}                    name


    ${enquiryPeriod_endDate}=                   Get From Dictionary         ${ARGUMENTS[1].data.enquiryPeriod}       endDate
    ${enquiryPeriod_startDate}=                 Get From Dictionary         ${ARGUMENTS[1].data.enquiryPeriod}       startDate

    ${tenderPeriod_endDate}=                    Get From Dictionary         ${ARGUMENTS[1].data.tenderPeriod}        endDate
    ${tenderPeriod_startDate}=                  Get From Dictionary         ${ARGUMENTS[1].data.tenderPeriod}        startDate

    ${enquiryPeriod_endDate}=    polonex_convertdate   ${enquiryPeriod_endDate}
    ${enquiryPeriod_startDate}=  polonex_convertdate   ${enquiryPeriod_startDate}
    ${tenderPeriod_endDate}=     polonex_convertdate   ${tenderPeriod_endDate}
    ${tenderPeriod_startDate}=   polonex_convertdate   ${tenderPeriod_startDate}
    ${deliverydate_startdate}=   polonex_convertdate   ${deliverydate_startdate}
    ${deliverydate_enddate}=     polonex_convertdate   ${deliverydate_enddate}


    ${minimalstep_amount}=              Convert To String     ${minimalstep_amount}
    ${value_amount}=                    Convert To String     ${value_amount}
    ${deliverylocation_latitude}=       Convert To String     ${deliverylocation_latitude}
    ${deliverylocation_longitude}=      Convert To String     ${deliverylocation_longitude}
    ${deliverydate_startdate}=          Convert To String     ${deliverydate_startdate}
    ${deliverydate_enddate}=            Convert To String     ${deliverydate_enddate}
    ${quantity}=                        Convert To String     ${quantity}


    Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
    Sleep   2
    Click Element       xpath=//a[contains(@id, 'addauctionbtn')]
    Sleep   4

    Select From List    xpath=//select[@id="addtenderform-minimalstep_currency"]    ${minimalstep_currency}
    Select From List    xpath=//select[@id="addtenderform-value_currency"]    ${value_currency}
    Select From List    xpath=//select[@id="addtenderform-value_valueaddedtaxincluded"]    ${value_valueaddedtaxincluded}
    Select From List    xpath=//select[@id="addtenderform-minimalstep_valueaddedtaxincluded"]    ${value_valueaddedtaxincluded}
    Select From List    xpath=//select[@id="addtenderform-procuringentity_kind"]    ${procuringEntity_kind}
    Select From List    xpath=//select[@id="addtenderitemsform-0-unit_code"]    ${unit_code}
    Select From List    id=addtenderform-mainprocurementcategory  ${mainProcurementCategory}


    Input text      id=addtenderform-title  ${title}
    Input text      id=addtenderform-description  ${description}
    Input text      id=addtenderform-minimalstep_amount  ${minimalstep_amount}
    Input text      id=addtenderform-value_amount  ${value_amount}
    Input text      id=addtenderitemsform-0-description  ${item_description}
    Input text      id=addtenderitemsform-0-deliveryaddress_postalcode  ${deliveryaddress_postalcode}
    Input text      id=addtenderitemsform-0-deliveryaddress_countryname  ${deliveryaddress_countryname}
    Input text      id=addtenderitemsform-0-deliveryaddress_streetaddress  ${deliveryaddress_streetaddress}
    Input text      id=addtenderitemsform-0-deliveryaddress_region  ${deliveryaddress_region}
    Input text      id=addtenderitemsform-0-deliveryaddress_locality  ${deliveryaddress_locality}
    Input text      id=addtenderitemsform-0-deliverydate_startdate  ${deliverydate_startdate}
    Input text      id=addtenderitemsform-0-deliverydate_enddate  ${deliverydate_enddate}
    Input text      id=addtenderitemsform-0-deliverylocation_latitude  ${deliverylocation_latitude}
    Input text      id=addtenderitemsform-0-deliverylocation_longitude  ${deliverylocation_longitude}
    Input text      id=addtenderitemsform-0-quantity  ${quantity}
    Input text      id=addtenderform-procuringentity_address_countryname  ${procuringEntity_address_countryName}
    Input text      id=addtenderform-procuringentity_address_locality  ${procuringEntity_address_locality}
    Input text      id=addtenderform-procuringentity_address_postalcode  ${procuringEntity_address_postalCode}
    Input text      id=addtenderform-procuringentity_address_region  ${procuringEntity_address_region}
    Input text      id=addtenderform-procuringentity_address_streetaddress  ${procuringEntity_address_streetAddress}
    Input text      id=addtenderform-procuringentity_contactpoint_name  ${procuringEntity_contactPoint_name}
    Input text      id=addtenderform-procuringentity_contactpoint_telephone  ${procuringEntity_contactPoint_telephone}
    Input text      id=addtenderform-procuringentity_contactpoint_email  ${procuringEntity_contactPoint_email}
    Input text      id=addtenderform-procuringentity_contactpoint_faxnumber  ${procuringEntity_contactPoint_faxNumber}
    Input text      id=addtenderform-procuringentity_contactpoint_url  ${procuringEntity_contactPoint_url}
    Input text      id=addtenderidentifierform-0-id  ${procuringEntity_identifier_id}
    Input text      id=addtenderidentifierform-0-scheme  ${procuringEntity_identifier_scheme}
    Input text      id=addtenderidentifierform-0-legalname  ${procuringEntity_identifier_legalName}
    Input text      id=addtenderform-procuringentity_name  ${procuringEntity_name}
    Input text      id=addtenderform-enquiryperiod_enddate  ${enquiryPeriod_endDate}
    Input text      id=addtenderform-enquiryperiod_startdate  ${enquiryPeriod_startDate}
    Input text      id=addtenderform-tenderperiod_enddate  ${tenderPeriod_endDate}
    Input text      id=addtenderform-tenderperiod_startdate  ${tenderPeriod_startDate}

    Execute Javascript    $("#addtenderitemsform-0-classification_id").val("${classification_id}");
    Execute Javascript    $("#addtenderitemsform-0-classification_id").trigger("change");

    Run Keyword If
        ...  '${additionalClassification_scheme}' == 'ДКПП'
        ...  Execute Javascript    $("#addtenderitemsform-0-additionalclassifications_dkpp_id").val("${additionalClassification_id}"); $("#addtenderitemsform-0-additionalclassifications_dkpp_id").trigger("change");
        ...  ELSE IF   '${additionalClassification_scheme}' == 'INN'
        ...  Execute Javascript    $("#addtenderitemsform-0-additionalclassifications_inn_id").val("${additionalClassification_id}"); $("#addtenderitemsform-0-additionalclassifications_inn_id").trigger("change");
        ...  ELSE IF   '${additionalClassification_scheme}' == 'ATC'
        ...  Execute Javascript    $("#addtenderitemsform-0-additionalclassifications_atc_id").val("${additionalClassification_id}"); $("#addtenderitemsform-0-additionalclassifications_atc_id").trigger("change");

    Sleep   5

    polonex.Додати майлстоуни  ${milestones}

    Click Element   xpath=//button[contains(@id, 'add-tender-form-save')]
    Wait Until Element Is Visible       xpath=//td[contains(@id, 'info_tenderID')]   30

    ${tender_uaid}=     Get Text        xpath=//td[contains(@id, 'info_tenderID')]
    [Return]    ${tender_uaid}

Додати майлстоуни
    [Arguments]  ${milestones}
    ${milestones_length}=   Get Length   ${milestones}
    :FOR   ${index}   IN RANGE   ${milestones_length}
    \   polonex.Додати майлстоун   ${milestones[${index}]}     ${index}

Додати майлстоун
    [Arguments]  ${milestones}  ${index}
    ${index}=  Convert To Integer  ${index}
    Run Keyword If  ${index} != 0   Click Element   id=milestones_list_add_btn
    Run Keyword If  ${index} != 0   Sleep           4
    Execute Javascript  $('html, body').animate({scrollTop: $("#addtendermilestonesform-"+${index}+"-title").offset().top}, 100);

    Select From List  id=addtendermilestonesform-${index}-title             ${milestones.title}
    Select From List  id=addtendermilestonesform-${index}-code              ${milestones.code}
    Select From List  id=addtendermilestonesform-${index}-duration_type     ${milestones.duration.type}


    ${dscr_status}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${milestones}  description

    Run Keyword If  ${dscr_status}  Input text  id=addtendermilestonesform-${index}-description  ${milestones.description}

    ${percentage}=  Convert To String  ${milestones.percentage}
    ${duration_days}=  Convert To String  ${milestones.duration.days}
    ${sequencenumber}=  Convert To String  ${milestones.sequenceNumber}

    Input text  id=addtendermilestonesform-${index}-percentage  ${percentage}
    Input text  id=addtendermilestonesform-${index}-duration_days  ${duration_days}
    Input text  id=addtendermilestonesform-${index}-sequencenumber  ${sequencenumber}

Завантажити документ
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}
  polonex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Click Element   xpath=//a[contains(@id, 'update_auction_btn')]
  ###Wait Until Element Is Visible       xpath=//input[contains(@id, "doc_upload_field_biddingDocuments")]   30
  ###Choose File     xpath=//input[contains(@id, "doc_upload_field_biddingDocuments")]   ${filepath}
  Sleep  5
  Execute Javascript  $('html, body').animate({scrollTop: $("#doc_upload_field_notice").offset().top}, 100);
  Sleep  5
  ###Wait Until Element Is Visible       id=doc_upload_field_notice   30
  Choose File     id=doc_upload_field_notice    ${filepath}
  Sleep   15
  Click Element   xpath=//button[contains(@id, 'add-tender-form-save')]
  Wait Until Page Contains  Документи успішно відплавлено до ЦБД  60

Завантажити ілюстрацію
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}
  Choose File       id=doc_upload_field_illustration        ${filepath}

Завантажити документ в тендер з типом
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${documentType}
  Choose File       id=doc_upload_field_${documentType}        ${filepath}

Завантажити документ в ставку
  [Arguments]  ${username}  ${path}  ${tender_uaid}  ${doc_type}=documents
  Sleep   60
  polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Click Element           id=edit_user_bid
  Sleep   2
  Choose File             xpath=//input[contains(@id, 'bid_doc_upload_fieldcommercialProposal')]   ${path}
  sleep   4
  Click Element           id=submit_add_bid_form

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${tender_uaid}
  Log to console  ${ARGUMENTS[1]}
  Go to  http://test.polonex.in.ua/prozorrotender/tender/sync-all?n=5
  Sleep  6
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
  Sleep  2
  Click Element       name=more-search-btn
  Sleep  2
  Input Text          id=tendersearch-tenderid   ${ARGUMENTS[1]}
  Sleep  2
  Click Element       name=search-btn
  Sleep  2
  Click Element     xpath=(//a[contains(@class, 'auction_detail_btn')])
  Sleep  1

Задати запитання
  [Arguments]  ${username}  ${tender_uaid}  ${question}  ${related_id}
  ${title}=        Get From Dictionary  ${question.data}  title
  ${description}=  Get From Dictionary  ${question.data}  description
  polonex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Wait Until Page Contains Element   id=add_question_btn
  Click Element         id=add_question_btn
  Sleep  2
  Input Text          id=addquestionform-title          ${title}
  Input Text          id=addquestionform-description    ${description}
  Sleep  2
  Click Element       id=submit_add_question_form
  Wait Until Page Contains  ${title}  30


Задати запитання на тендер
  [Arguments]  ${username}  ${tender_uaid}  ${question}
  Задати запитання  ${username}  ${tender_uaid}  ${question}  ${tender_uaid}

Задати запитання на предмет
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${question}
  Задати запитання  ${username}  ${tender_uaid}  ${question}  ${item_id}

Задати запитання на лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${question}
  Задати запитання  ${username}  ${tender_uaid}  ${question}  ${lot_id}

Відповісти на запитання
  [Arguments]  ${username}  ${tender_uaid}  ${answer_data}  ${question_id}
  ${index}=   Get Element Attribute   xpath=//div[contains(text(), '${question_id}')]@id
  ${index}=   Get Substring   ${index}    2   3
  Click Element                         xpath=//a[contains(@id, 'add_answer_btn_${index}')]
  Sleep     4
  Input Text                            id=addanswerform-answer        ${answer_data.data.answer}
  Sleep     2
  Click Button                        id=submit_add_answer_form
  Wait Until Page Contains   ${answer_data.data.answer}   10

Оновити сторінку з тендером
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} = username
    ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
    polonex.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}

Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${username}
  ...      ${ARGUMENTS[1]} ==  ${tender_uaid}
  ...      ${ARGUMENTS[2]} ==  ${field_name}
  polonex.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
  ${return_value}=  run keyword  Отримати інформацію про ${ARGUMENTS[2]}
  [Return]  ${return_value}

Отримати інформацію із предмету
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${field_name}
  ${field_name}=  Отримати шлях до поля об’єкта  ${username}  ${field_name}  ${item_id}
  Run Keyword And Return  polonex.Отримати інформацію із тендера  ${username}  ${tender_uaid}  ${field_name}

Отримати інформацію із документа
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}  ${field}
  ${tender}=  polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${return_value}=   Get Element Attribute   xpath=//div[contains(@data-name,'${doc_id}')]@data-name
  [Return]  ${return_value}

Отримати документ
    [Arguments]  ${username}  ${tender_uaid}  ${doc_id}
    ${file_name}=   Get Element Attribute   xpath=//div[contains(@data-name,'${doc_id}')]@data-name
    ${url}=   Get Element Attribute   xpath=//div[contains(@data-name,'${doc_id}')]@data-src
    polonex_download_file   ${url}  ${file_name}  ${OUTPUT_DIR}
    [return]  ${file_name}

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

Отримати інформацію про status
  reload page
  ${return_value}=   Отримати текст із поля і показати на сторінці   status
  ${return_value}=   convert_polonex_string     ${return_value}
  [Return]  ${return_value}

Отримати інформацію про description
  ${return_value}=   Отримати текст із поля і показати на сторінці   description
  [Return]  ${return_value}

Отримати інформацію про value.amount
  ${return_value}=   Отримати текст із поля і показати на сторінці  value.amount
  ${return_value}=   Convert To Number   ${return_value}
  [Return]  ${return_value}

Отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати текст із поля і показати на сторінці   minimalStep.amount
  ${return_value}=   Convert To Number   ${return_value}
  [Return]   ${return_value}

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}

  Click Element   xpath=//a[contains(@id, 'update_auction_btn')]
  Sleep   2
  ${title}=   Get Text     id=addtenderform-title
  ${description}=   Get Text    id=addtenderform-description
  Click Button    id=add-tender-form-save
  Sleep   2


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

Отримати інформацію про tenderId
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

Отримати інформацію про items[0].deliveryDate.startDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].deliveryDate.startDate
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


Отримати інформацію про milestones[0].code
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[0].code
  [Return]  ${return_value}

Отримати інформацію про milestones[0].title
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[0].title
  [Return]  ${return_value}

Отримати інформацію про milestones[0].percentage
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[0].percentage
  ${return_value}=  Convert To Integer  ${return_value}
  [Return]  ${return_value}

Отримати інформацію про milestones[0].duration.days
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[0].duration.days
  ${return_value}=  Convert To Integer  ${return_value}
  [Return]  ${return_value}

Отримати інформацію про milestones[0].duration.type
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[0].duration.type
  [Return]  ${return_value}

Отримати інформацію про milestones[1].code
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[1].code
  [Return]  ${return_value}

Отримати інформацію про milestones[1].title
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[1].title
  [Return]  ${return_value}

Отримати інформацію про milestones[1].percentage
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[1].percentage
  ${return_value}=  Convert To Integer  ${return_value}
  [Return]  ${return_value}

Отримати інформацію про milestones[1].duration.days
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[1].duration.days
  ${return_value}=  Convert To Integer  ${return_value}
  [Return]  ${return_value}

Отримати інформацію про milestones[1].duration.type
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[1].duration.type
  [Return]  ${return_value}

Отримати інформацію про milestones[2].code
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[2].code
  [Return]  ${return_value}

Отримати інформацію про milestones[2].title
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[2].title
  [Return]  ${return_value}

Отримати інформацію про milestones[2].percentage
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[2].percentage
  ${return_value}=  Convert To Integer  ${return_value}
  [Return]  ${return_value}

Отримати інформацію про milestones[2].duration.days
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[2].duration.days
  ${return_value}=  Convert To Integer  ${return_value}
  [Return]  ${return_value}

Отримати інформацію про milestones[2].duration.type
  ${return_value}=   Отримати текст із поля і показати на сторінці   milestones[2].duration.type
  [Return]  ${return_value}


Отримати інформацію про awards[0].complaintPeriod.endDate
  Execute Javascript  $('html, body').animate({scrollTop: $("#awards_count").offset().top}, 100);
  ${return_value}=   Отримати текст із поля і показати на сторінці   awards[0].complaintPeriod.endDate
  [Return]  ${return_value}


Подати цінову пропозицію
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} ==  username
  ...    ${ARGUMENTS[1]} ==  tenderId
  ...    ${ARGUMENTS[2]} ==  ${test_bid_data}
  ${amount}=          Get From Dictionary     ${ARGUMENTS[2].data.value}    amount
  ${amount}=          Convert To String     ${amount}
  polonex.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
  Click Element       id=add_bid_btn
  Sleep   2
  Input Text          id=addbidform-sum       ${amount}
  Sleep   4
  Click Element       id=submit_add_bid_form
  Wait Until Element Is Visible       id=userbidamount   30
  ${resp}=    Get Text      id=userbidamount
  Wait Until Element Is Visible       id=docuploadsuccess   30
  [Return]    ${resp}

Скасувати цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  none
    ...    ${ARGUMENTS[2]} ==  tenderId

    Click Element       id=cansel-bid
    Sleep   2

Змінити цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ...    ${ARGUMENTS[2]} ==  amount
    ...    ${ARGUMENTS[3]} ==  amount.value
    Click Element       id=edit_user_bid
    Sleep   2
    ${newsum}=          Convert To String       ${ARGUMENTS[3]}
    Input Text          id=addbidform-sum       ${newsum}
    Click Element       id=submit_add_bid_form
    Sleep   10
    ${resp}=    Get Text      id=userbidamount
    [Return]    ${resp}



Змінити документ в ставці
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ...    ${ARGUMENTS[2]} ==  file
    log to console  ${ARGUMENTS[2]}
    Click Element           id=edit_user_bid
    Sleep   2
    Click Element     xpath=(//div[contains(@class, 'reupload')])
    Sleep   2
    Choose File             xpath=//input[contains(@id, 'bid_doc_upload_fieldcommercialProposal')]   ${ARGUMENTS[2]}
    sleep   2
    Click Element           id=submit_add_bid_form

Отримати пропозицію
    [Arguments]  ${field}
    Wait Until Page Contains Element    ${locator.proposition.${field}}            30
    ${proposition_amount}=              Get Text            id=userbidamount
    log to console                      ${proposition_amount}
    ${proposition_amount}=              Convert To Number                          ${proposition_amount}
    log to console                      ${proposition_amount}
    ${data}=     Create Dictionary
    ${bid}=      Create Dictionary
    ${value}=    Create Dictionary
    Set To Dictionary  ${bid}     data=${data}
    Set To Dictionary  ${data}    value=${value}
    Set To Dictionary  ${value}   amount=${proposition_amount}
    [return]           ${bid}

Отримати інформацію із запитання
  [Arguments]  ${username}  ${tender_uaid}  ${question_id}  ${field_name}
  ${index}=   Get Element Attribute   xpath=//td[contains(text(), '${question_id}')]@id
  ${index}=   Get Substring   ${index}    0   4
  ${return_value}=    Get Text     id=${item_id}${field_name}
  [Return]  ${return_value}

Отримати інформацію із пропозиції
  [Arguments]  ${username}  ${tender_uaid}  ${field}
  ${bid}=   polonex.Отримати пропозицію  ${field}
  [return]  ${bid.data.${field}}

Отримати інформацію про bids
    [Arguments]  @{ARGUMENTS}
    ##Selenium2Library.Switch Browser       ${ARGUMENTS[0]}

Отримати посилання на аукціон для глядача
    [Arguments]  @{ARGUMENTS}
    polonex.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    ${result}=                  Get Element Attribute               id=show_public_btn@href
    [Return]   ${result}
Отримати посилання на аукціон для учасника
    [Arguments]  @{ARGUMENTS}
    polonex.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    ${result}=                  Get Element Attribute               id=show_private_btn@href
    [Return]   ${result}

Завантажити документ рішення кваліфікаційної комісії
  [Arguments]  ${username}  ${document}  ${tender_uaid}  ${award_num}
  polonex.Пошук тендера по ідентифікатору   ${username}  ${tender_uaid}
  Sleep  5
  Execute Javascript  $('html, body').animate({scrollTop: $("#awards_count").offset().top}, 100);
  Click Element   id=vendor_confirm_btn
  Sleep  5
  Choose File     id=award_doc_upload_field_vendorConfirm    ${document}
  Sleep   15
  ###Click Element   id=submit_vendor_confirm
  ###Wait Until Page Contains  Документи успішно відплавлено до ЦБД  60

Підтвердити постачальника
  [Documentation]
  ...      [Arguments] Username, tender uaid and number of the award to confirm
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${award_num}
  polonex.Пошук тендера по ідентифікатору   ${username}  ${tender_uaid}
  Sleep  5
  Click Element   id=vendor_confirm_btn
  Sleep  5
  Click Element   id=submit_vendor_confirm
  Wait Until Page Contains  Документи успішно відплавлено до ЦБД  30

Редагувати угоду
  [Arguments]  ${userName}  ${tenderId}  ${awardIndex}  ${fieldName}  ${value}
  polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${valueAmount}=    Convert To String    ${value}
  Sleep  5
  Click Element  id=edit_contract_btn
  Sleep  5
  Input Text  id=contracteditform-contracts_value  ${valueAmount}
  Click Element  id=submit_edit_contract
  Wait Until Page Contains  Договір змінено успішно  30

Підтвердити підписання контракту
  [Documentation]
  ...      [Arguments] Username, tender uaid, contract number
  ...      [Return] Nothing
  [Arguments]  ${username}  ${tender_uaid}  ${contract_num}
  polonex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  sleep  10
  Click Element  id=sign_contract_btn
  Wait Until Page Contains  Договір підписано успішно  30

