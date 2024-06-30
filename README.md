# Audit a dataLayer with BigQuery

This setup consists of Google Tag Manager templates for loading a dataLayer into a BigQuery table.

You will retrieve the following two files:

- A variable template for a Google Tag Manager web container
- A tag template for a Google Tag Manager server container

# Prerequisites

To use this setup, you first need:

- A Google Tag Manager server container
- A BigQuery dataset in the same Google Cloud project as your server container

## BigQuery dataset and table references

For using this setup without making any changes, you will need to follow these requirements:

- Your dataset must be named **datalayer_audit**
- Your table must be named **datalayer_audit**
- Your table must follow the schema below

|Field name|Type|
|--|--|
| datalayer | JSON |
| timestamp | STRING |
| hostname | STRING |
| observed_event | STRING |

# Google Tag Manager client-side configuration

1. Upload the `audit_datalayer_variable.tpl` to your web container.
2. Create the corresponding variable (no additional configurations required).
3. Create a GA4 Event, with the following specifications :
	- Event Name : `datalayer_audit`
	- `server_container_url` : your tracking server URL
	- `dla_object` : the variable created in step 2.
	- `dla_hostname` : the hostname of the audited website.
	- `dla_observed_event` : the name of the observerd event, such as `purchase` or `form_submit`. Note that it does not need to follow GA4 standards events names.
4. Set the appropriate trigger for your tag. It is preferable to set a window loaded trigger to capture the most data possible in the dataLayer.

# Google Tag Manager server-side configuration

1. Upload the `audit_datalayer_tag.tpl` in your server container.
2. Create the tag with the uploaded template :
	- In the Event Data References section, reference the `dla_object`, `dla_hostname` and `dla_observed_event` data events.
	- In the BigQuery References, set your Google Cloud Project ID, the dataset ID and the table ID.
3. Set the trigger on the custom event `datalayer_audit`. 

# Visualize your dataLayer

For visualizing your dataLayer, you can query your BigQuery table and export the results as a `JSONL` file. 

# Note
[Présentation MeasureCamp Paris 2024](https://docs.google.com/presentation/d/1ArO6dbLk5Qwho18p110yNci3gI4_MZwU-yzGgIVXraE/edit?usp=sharing)