
{
  "exportType" : "update",
  "configObjects" : [ {
    "apiName" : "fieloplt__library__c",
    "fieldsToExclude" : "fieloplt__resourceid__c"
  }, {
    "apiName" : "fieloplt__ruletrigger__c",
    "fieldsToExclude" : "fieloplt__prefix__c"
  }, {
    "apiName" : "fieloplt__action__c",
    "fieldsToExclude" : "fieloplt__rulesquantity__c,fieloplt__missionsquantity__c,fieloplt__criteriafields__c"
  } ],
  "migrationRecords" : [ {
    "objectAPIName" : "fieloplt__library__c",
    "records" : [ {
      "fieldsValues" : [ {
        "apiName" : "name",
        "value" : "Fielo Member Referral "
      }, {
        "apiName" : "fieloplt__externalid__c",
        "value" : "FieloLocal"
      }, {
        "apiName" : "fieloplt__version__c",
        "value" : "1.000"
      } ],
      "relatedList" : [ {
        "objectAPIName" : "fieloplt__ruletrigger__c",
        "records" : [ {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Referral Member"
          }, {
            "apiName" : "fieloplt__date__c",
            "value" : "CreatedDate"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00Df2000001LggP-a0ff200000DinbS"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloLocal",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__lookupfromemailalert__c",
            "value" : "FieloMRF__ReferredBy__c"
          }, {
            "apiName" : "fieloplt__lookupfromtransaction__c",
            "value" : "FieloMRF__ReferredBy__c"
          }, {
            "apiName" : "fieloplt__lookupfromtracker__c",
            "value" : "FieloMRF__ReferredBy__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPLT__Member__c"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__action__c",
            "records" : [ {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Referral Member > FieloMRF__ReferredBy__c"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "00Df2000001LggP-a00f200000UikmU"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "00Df2000001LggP-a0ff200000DinbS",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__targetemailfield__c",
                "value" : "FieloPLT__Email__c"
              }, {
                "apiName" : "fieloplt__targetmember__c",
                "value" : "FieloMRF__ReferredBy__c"
              }, {
                "apiName" : "fieloplt__templatesquantity__c",
                "value" : "0"
              } ],
              "relatedList" : [ {
                "objectAPIName" : "fieloplt__programassignment__c",
                "records" : [ ]
              } ]
            }, {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Referral Member > FieloMRF__ReferredBy__r.FieloPLT__OrganizationAccount__c"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "00Df2000001LggP-a00f200000UikmV"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "00Df2000001LggP-a0ff200000DinbS",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__targetemailfield__c",
                "value" : "FieloPLT__Email__c"
              }, {
                "apiName" : "fieloplt__targetmember__c",
                "value" : "FieloMRF__ReferredBy__r.FieloPLT__OrganizationAccount__c"
              }, {
                "apiName" : "fieloplt__targetobject__c",
                "value" : "FieloPLT__Member__c"
              }, {
                "apiName" : "fieloplt__templatesquantity__c",
                "value" : "0"
              } ],
              "relatedList" : [ {
                "objectAPIName" : "fieloplt__programassignment__c",
                "records" : [ ]
              } ]
            }, {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Referral Member > Id"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "00Df2000001LggP-a00f200000Uikmj"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "00Df2000001LggP-a0ff200000DinbS",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__targetemailfield__c",
                "value" : "FieloPLT__Email__c"
              }, {
                "apiName" : "fieloplt__targetmember__c",
                "value" : "Id"
              }, {
                "apiName" : "fieloplt__templatesquantity__c",
                "value" : "0"
              } ],
              "relatedList" : [ {
                "objectAPIName" : "fieloplt__programassignment__c",
                "records" : [ ]
              } ]
            } ]
          }, {
            "objectAPIName" : "fieloplt__kpi__c",
            "records" : [ ]
          } ]
        } ]
      }, {
        "objectAPIName" : "fieloplt__model__c",
        "records" : [ {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Referral Promotion"
          }, {
            "apiName" : "fieloplt__category__c",
            "value" : "Miscellaneous"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00Df2000001LggP-a0Pf200000KGMHe"
          }, {
            "apiName" : "fieloplt__icon__c",
            "value" : "fielosf-icon-content"
          }, {
            "apiName" : "fieloplt__json__c",
            "value" : "{  \"exportType\" : \"model\",  \"configObjects\" : [ {    \"apiName\" : \"fieloplt__promotion__c\",    \"fieldsToExclude\" : \"fieloplt__status__c\",    \"fieldsToExcludeModel\" : \"fieloplt__program__c\"  }, {    \"apiName\" : \"fieloplt__action__c\",    \"fieldsToExclude\" : \"fieloplt__rulesquantity__c,fieloplt__missionsquantity__c,fieloplt__criteriafields__c\"  } ],  \"migrationRecords\" : [ {    \"objectAPIName\" : \"fieloplt__promotion__c\",    \"records\" : [ {      \"fieldsValues\" : [ {        \"apiName\" : \"fieloplt__externalid__c\",        \"value\" : \"0\"      }, {        \"apiName\" : \"name\",        \"value\" : \"Referral Promotion\"      }, {        \"apiName\" : \"fieloplt__status__c\",        \"value\" : \"Draft\"      } ],      \"relatedList\" : [ {        \"objectAPIName\" : \"fieloplt__rule__c\",        \"records\" : [ {          \"fieldsValues\" : [ {            \"apiName\" : \"fieloplt__externalid__c\",            \"value\" : \"1\"          }, {            \"apiName\" : \"name\",            \"value\" : \"Referral Promotion - Referred By\"          }, {            \"apiName\" : \"fieloplt__action__c.fieloplt__externalid__c\",            \"value\" : \"00Df2000001LggP-a00f200000UikmU\",            \"refObject\" : \"fieloplt__action__c\"          }, {            \"apiName\" : \"fieloplt__conversionvalue__c\",            \"value\" : \"100.00\"          }, {            \"apiName\" : \"fieloplt__logicalexpression__c\",            \"value\" : \"ALL\"          }, {            \"apiName\" : \"fieloplt__pointconversionmode__c\",            \"value\" : \"Fixed Value\"          }, {            \"apiName\" : \"fieloplt__promotion__c.fieloplt__externalid__c\",            \"value\" : \"0\",            \"refObject\" : \"fieloplt__promotion__c\",            \"isFake\" : true          }, {            \"apiName\" : \"fieloplt__relatedlist__c\",            \"value\" : \"FieloPLT__Member__c\"          }, {            \"apiName\" : \"fieloplt__stockcontrol__c\",            \"value\" : \"false\"          }, {            \"apiName\" : \"fieloplt__type__c\",            \"value\" : \"No Competition\"          } ],          \"relatedList\" : [ {            \"objectAPIName\" : \"fieloplt__criterion__c\",            \"records\" : [ {              \"fieldsValues\" : [ {                \"apiName\" : \"fieloplt__externalid__c\",                \"value\" : \"3\"              }, {                \"apiName\" : \"fieloplt__booleanvalue__c\",                \"value\" : \"false\"              }, {                \"apiName\" : \"fieloplt__description__c\",                \"value\" : \"FieloPLT__Status__c = Active\"              }, {                \"apiName\" : \"fieloplt__fieldname__c\",                \"value\" : \"FieloPLT__Status__c\"              }, {                \"apiName\" : \"fieloplt__fieldtype__c\",                \"value\" : \"List\"              }, {                \"apiName\" : \"fieloplt__isfield__c\",                \"value\" : \"false\"              }, {                \"apiName\" : \"fieloplt__operator__c\",                \"value\" : \"equals\"              }, {                \"apiName\" : \"fieloplt__order__c\",                \"value\" : \"1\"              }, {                \"apiName\" : \"fieloplt__rule__c.fieloplt__externalid__c\",                \"value\" : \"1\",                \"refObject\" : \"fieloplt__rule__c\",                \"isFake\" : true              }, {                \"apiName\" : \"fieloplt__values__c\",                \"value\" : \"Active\"              } ],              \"relatedList\" : [ ]            } ]          } ]        }, {          \"fieldsValues\" : [ {            \"apiName\" : \"fieloplt__externalid__c\",            \"value\" : \"2\"          }, {            \"apiName\" : \"name\",            \"value\" : \"Referral Promotion - Referred Member\"          }, {            \"apiName\" : \"fieloplt__action__c.fieloplt__externalid__c\",            \"value\" : \"00Df2000001LggP-a00f200000Uikmj\",            \"refObject\" : \"fieloplt__action__c\"          }, {            \"apiName\" : \"fieloplt__conversionvalue__c\",            \"value\" : \"100.00\"          }, {            \"apiName\" : \"fieloplt__logicalexpression__c\",            \"value\" : \"ALL\"          }, {            \"apiName\" : \"fieloplt__pointconversionmode__c\",            \"value\" : \"Fixed Value\"          }, {            \"apiName\" : \"fieloplt__promotion__c.fieloplt__externalid__c\",            \"value\" : \"0\",            \"refObject\" : \"fieloplt__promotion__c\",            \"isFake\" : true          }, {            \"apiName\" : \"fieloplt__relatedlist__c\",            \"value\" : \"FieloPLT__Member__c\"          }, {            \"apiName\" : \"fieloplt__stockcontrol__c\",            \"value\" : \"false\"          }, {            \"apiName\" : \"fieloplt__type__c\",            \"value\" : \"No Competition\"          } ],          \"relatedList\" : [ {            \"objectAPIName\" : \"fieloplt__criterion__c\",            \"records\" : [ {              \"fieldsValues\" : [ {                \"apiName\" : \"fieloplt__externalid__c\",                \"value\" : \"4\"              }, {                \"apiName\" : \"fieloplt__booleanvalue__c\",                \"value\" : \"false\"              }, {                \"apiName\" : \"fieloplt__description__c\",                \"value\" : \"FieloPLT__Status__c = Active\"              }, {                \"apiName\" : \"fieloplt__fieldname__c\",                \"value\" : \"FieloPLT__Status__c\"              }, {                \"apiName\" : \"fieloplt__fieldtype__c\",                \"value\" : \"List\"              }, {                \"apiName\" : \"fieloplt__isfield__c\",                \"value\" : \"false\"              }, {                \"apiName\" : \"fieloplt__operator__c\",                \"value\" : \"equals\"              }, {                \"apiName\" : \"fieloplt__order__c\",                \"value\" : \"1\"              }, {                \"apiName\" : \"fieloplt__rule__c.fieloplt__externalid__c\",                \"value\" : \"2\",                \"refObject\" : \"fieloplt__rule__c\",                \"isFake\" : true              }, {                \"apiName\" : \"fieloplt__values__c\",                \"value\" : \"Active\"              } ],              \"relatedList\" : [ ]            } ]          } ]        } ]      }, {        \"objectAPIName\" : \"fieloplt__kpidomain__c\",        \"records\" : [ ]      } ]    } ]  } ],  \"segmentsCombinations\" : [ ]}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloLocal",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Promotion"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        } ]
      }, {
        "objectAPIName" : "fieloplt__pagesettings__c",
        "records" : [ ]
      } ]
    } ]
  } ],
  "segmentsCombinations" : [ ]
}