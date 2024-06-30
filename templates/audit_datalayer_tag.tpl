___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Audit dataLayer",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "Event Data References",
    "displayName": "Event Data References",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "dataLayerAuditObject",
        "displayName": "dataLayer Audit Object",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "hostName",
        "displayName": "Hostname",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "observedEventName",
        "displayName": "Observed Event Name",
        "simpleValueType": true
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "BigQuery References",
    "displayName": "BigQuery References",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "projectId",
        "displayName": "GCP Project ID",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "datasetId",
        "displayName": "Dataset ID",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "tableId",
        "displayName": "Table ID",
        "simpleValueType": true
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const JSON = require('JSON');
const getEventData = require('getEventData');
const BigQuery = require('BigQuery');
const getType = require('getType');
const makeString = require('makeString');
const logToConsole = require('logToConsole');

let parseDataLayerAuditObject = JSON.parse(data.dataLayerAuditObject);

const userAgent = getEventData('user_agent');
parseDataLayerAuditObject.audit.user_agent = userAgent;

const connectionInfo = {
  'projectId': data.projectId,
  'datasetId': data.datasetId,
  'tableId': data.tableId,
};

let timestamp = makeString(parseDataLayerAuditObject.audit.timestamp);
timestamp = timestamp.substring(0,10);

const rows = [{
  'timestamp': timestamp,
  'datalayer': JSON.stringify(parseDataLayerAuditObject),
  'hostname': data.hostName,
  'observed_event': data.observedEventName
}];

BigQuery.insert(connectionInfo, rows)
  .then(data.gtmOnSuccess, data.gtmOnFailure);


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "user_agent"
              },
              {
                "type": 1,
                "string": "client_hints"
              }
            ]
          }
        },
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_bigquery",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedTables",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "projectId"
                  },
                  {
                    "type": 1,
                    "string": "datasetId"
                  },
                  {
                    "type": 1,
                    "string": "tableId"
                  },
                  {
                    "type": 1,
                    "string": "operation"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "bm-data-394913"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 30/06/2024, 18:25:47


