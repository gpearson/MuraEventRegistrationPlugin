component displayname="SmartyStreets" hint="LiveAddress API v2.3.1 wrapper" {
    /*
     * Version 1.0 — Dec 1, 2011
     * Home page: https://github.com/sgalashyn/smartystreets
     * API docs: http://wiki.smartystreets.com/liveaddress_api_users_guide
     */

    variables.apitoken = "";
    variables.apiid = "";
    variables.apiurl = "https://us-street.api.smartystreets.com/street-address";
    variables.useragent = "";
    variables.verbose = false;


    // HTTP status codes map
    variables.statuses = {
        "200" = "Request completed successfully, inspect response body.",
        "400" = "Malformed request – required fields missing from request.",
        "401" = "Authentication failure – invalid credentials; check credentials and try again.",
        "402" = "Unauthorized access; no active subscription can be found.",
        "500" = "General service failure, retry request."
    };

    /*
     * @apikey Valid API Key for your user account
     * @useragent Custom useragent for HTTP requests
     * @verbose Append extended info to the output
     */
    public any function init(
        required string apitoken,
	   required string apiid,
        boolean verbose = false,
        string useragent = server.ColdFusion.ProductName
    )
    hint="Component initialization" {
        setApiToken(arguments.apitoken);
	   setApiId(arguments.apiid);
        setUserAgent(arguments.useragent);
        setVerbose(arguments.verbose);
        return this;
    }



    /*
     * INTERACTION WITH API
     */


    /*
     * Required arguments are street AND either city/state OR zipcode OR city/zipcode OR lastline
     */
    public any function invoke() hint="Perform request to the API and handle response" {

        var local = {output = {}};

        try {

            // make simple validation of arguments

            if (getApiToken() EQ "") {
                throw(message="API Token not set.");
            }

		  if (getApiId() EQ "") {
			  throw(message="API ID not set.");
		  }

            param name="arguments.street" default="";
            param name="arguments.city" default="";
            param name="arguments.state" default="";
            param name="arguments.zipcode" default="";
           // param name="arguments.lastline" default="";

            if (arguments.street EQ "") {
                throw(message="You must supply street address.");
            }

            if (arguments.city NEQ "" AND arguments.state NEQ "") {
                // OK
            }
            else if (arguments.zipcode NEQ "") {
                // OK
            }
            else if (arguments.lastline NEQ "") {
                // OK
            }
            else {
                throw(message="You must supply street AND city/state OR zipcode OR city/zipcode OR lastline.");
            }

		  urlparams = "";
		  for (local.key in arguments) {
			urlparams = urlparams & "&" & Lcase(local.key) & "=" & URLEncodedFormat(arguments[local.key]);
  			// local.service.addParam(type="formfield", name=LCase(local.key), value=arguments[local.key]);
  		}

	       // send a request to the API (token must be in URL)
            local.service = new http(
                url = "#getApiUrl()#?auth-id=#getApiID()#&auth-token=#getApiToken()##urlparams#",
                method = "GET",
                useragent = getUserAgent()
            );

		      
		  temp = local.service.getParams();


            local.result = local.service.send().getPrefix();

            if (getVerbose()) {
                local.output.result = local.result;
            }



		  // check if request is handled
		  if (local.result.responseheader.status_code NEQ 200) {
                throw(message=getStatusDefinition(local.result.responseheader.status_code), detail=local.result.responseheader.explanation);
            }


            // try to parse the response

            if (StructKeyExists(local.result, "filecontent") AND isJSON(local.result.filecontent)) {
                local.output.fault = false;
                local.output.data = DeserializeJSON(local.result.filecontent);
            }
            else if (StructKeyExists(local.result, "errordetail")) {
                throw(message="API communication failure. #local.result.errordetail#");
            }
            else {
                throw(message="API communication failure, or invalid (not JSON) response returned.");
            }


        }
        catch (any exception) {

            local.output.fault = true;
            local.output.data = exception.Message;

            if (exception.Detail NEQ "") {
                local.output.data &= " " & exception.Detail;
            }

            if (getVerbose()) {
                local.output.exception = exception;
            }

        }


        return local.output;


    }



    /*
     * HELPERS
     */


    public void function setApiToken(required string apitoken) hint="Set current API auth token setting" {
        variables.apitoken = arguments.apitoken;
    }

    public void function setApiId(required string apiid) hint="Set current API ID setting" {
        variables.apiid = arguments.apiid;
    }


    public string function getApiToken() hint="Get current API auth token setting" {
        return variables.apitoken;
    }


    public string function getApiID() hint="Get current API ID setting" {
        return variables.apiid;
    }



    public void function setUserAgent(required string useragent) hint="Set current useragent setting" {
        variables.useragent = arguments.useragent;
    }


    public string function getUserAgent() hint="Get current useragent setting" {
        return variables.useragent;
    }


    public string function getApiUrl() hint="Get current API URL" {
        return variables.apiurl;
    }


    public void function setVerbose(required boolean verbose) hint="Set current verbose setting" {
        variables.verbose = arguments.verbose;
    }


    public boolean function getVerbose() hint="Get current verbose setting" {
        return variables.verbose;
    }


    private string function getStatusDefinition(required string code) hint="Get definition for status code" {

        if (StructKeyExists(variables.statuses, arguments.code)) {
            return variables.statuses[arguments.code];
        }
        else {
            return "Unknown status code (#local.code#)";
        }

    }
}
