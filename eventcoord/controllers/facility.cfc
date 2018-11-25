<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="Session.getFacilities" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
			From p_EventRegistration_Facility
			Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
			Order by FacilityName ASC
		</cfquery>
	</cffunction>

	<cffunction name="getAllFacilities" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrCaterers = ArrayNew(1)>
		<cfquery name="getFacilities" dbtype="Query">
			Select TContent_ID, FacilityName, PhysicalState, PrimaryVoiceNumber, Active
			From Session.getFacilities
			<cfif Arguments.sidx NEQ "">
				Order By #Arguments.sidx# #Arguments.sord#
			<cfelse>
				Order by FacilityName #Arguments.sord#
			</cfif>
		</cfquery>

		<!--- Calculate the Start Position for the loop query. So, if you are on 1st page and want to display 4 rows per page, for first page you start at: (1-1)*4+1 = 1.
				If you go to page 2, you start at (2-)1*4+1 = 5 --->
		<cfset start = ((arguments.page-1)*arguments.rows)+1>

		<!--- Calculate the end row for the query. So on the first page you go from row 1 to row 4. --->
		<cfset end = (start-1) + arguments.rows>

		<!--- When building the array --->
		<cfset i = 1>

		<cfloop query="getFacilities" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #Active# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfset arrCaterers[i] = [#TContent_ID#,#FacilityName#,#PhysicalState#,#PrimaryVoiceNumber#,#strActive#]>
			<cfset i = i + 1>
		</cfloop>

		<!--- Calculate the Total Number of Pages for your records. --->
		<cfset totalPages = Ceiling(getFacilities.recordcount/arguments.rows)>

		<!--- The JSON return.
			Total - Total Number of Pages we will have calculated above
			Page - Current page user is on
			Records - Total number of records
			rows = our data
		--->
		<cfset stcReturn = {total=#totalPages#,page=#Arguments.page#,records=#getFacilities.recordcount#,rows=arrCaterers}>
		<cfreturn stcReturn>
	</cffunction>

	<cffunction name="editfacility" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
				Order by FacilityName ASC
			</cfquery>

			<cfquery name="Session.getSelectedFacilityRooms" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, RoomName, Capacity, RoomFees, Active
				From p_EventRegistration_FacilityRooms
				Where Facility_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#"> and Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
				Order by RoomName ASC
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getCaterers")>
				<cfset temp = StructDelete(Session, "getSelectedCaterer")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.default" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Catering Facility is active in the database or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&FormRetry=True&FacilityID=#URL.FacilityID#" addtoken="false">
			</cfif>

			<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/GoogleGeoCoder")>
			<cfset AddressGeoCoded = #GeoCodeCFC.GeoCodeAddress(Form.PhysicalAddress, FORM.PhysicalCity, FORM.PhysicalState, FORM.PhysicalZipCode)#>
			<cfif AddressGeoCoded[1].ErrorMessage NEQ "OK">
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&FormRetry=True&FacilityID=#URL.FacilityID#" addtoken="false">
			<cfelse>
				<cfset CombinedPhysicalAddress = #AddressGeoCoded[1].AddressStreetNumber# & " " & #AddressGeoCoded[1].AddressStreetNameShort#>

				<cfquery name="updateFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Facility
					Set FacilityName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.FacilityName#">,
						PhysicalAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
						PhysicalCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.AddressGeoCoded[1].AddressCityName)#">,
						PhysicalState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameShort)#">,
						PhysicalZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.AddressGeoCoded[1].AddressZipCode)#">,
						PrimaryVoiceNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryVoiceNumber#">,
						BusinessWebsite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BusinessWebsite#">,
						ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactName#">,
						ContactPhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactPhoneNumber#">,
						ContactEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactEmail#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">,
						Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
				</cfquery>

				<cfif isDefined("Variables.AddressGeoCoded[1].AddressZipCodeFour")>
					<cfquery name="updateCatererInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Facility
						Set PhysicalZip4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.AddressGeoCoded[1].AddressZipCodeFour)#">
						Where  TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
					</cfquery>
				</cfif>

				<cfquery name="updateFacilityGeoCode" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Facility
					Set GeoCode_Latitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLatitude)#" cfsqltype="cf_sql_varchar">,
						GeoCode_Longitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLongitude)#" cfsqltype="cf_sql_varchar">,
						<cfif isDefined("Variables.AddressGeoCoded[1].AddressTownshipNameLong")>
							GeoCode_Township = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressTownshipNameLong)#" cfsqltype="cf_sql_varchar">,
						</cfif>
						<cfif isDefined("Variables.AddressGeoCoded[1].NeighborhoodNameLong")>
							GeoCode_Neighborhood = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].NeighborhoodNameLong)#" cfsqltype="cf_sql_varchar">,
						</cfif>
						GeoCode_StateLongName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameLong)#" cfsqltype="cf_sql_varchar">,
						GeoCode_CountryShortName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCountryNameShort)#" cfsqltype="cf_sql_varchar">,
						isAddressVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
						lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#Session.Mura.Fname# #Session.Mura.Lname#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.default&UserAction=InformationUpdated&Successful=True" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="editfacilityroom" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
				Order by FacilityName ASC
			</cfquery>

			<cfquery name="Session.getSelectedFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, RoomName, Capacity, RoomFees, Active
				From p_EventRegistration_FacilityRooms
				Where Facility_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#"> and Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityRoomID#">
				Order by RoomName ASC
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getCaterers")>
				<cfset temp = StructDelete(Session, "getSelectedCaterer")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&FacilityID=#URL.FacilityID#" addtoken="false">
			</cfif>


			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Meeting Room is active or not in the database."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacilityroom&FormRetry=True&FacilityID=#URL.FacilityID#&FacilityRoomID=#URL.FacilityRoomID#" addtoken="false">
			</cfif>

			<cfquery name="updateFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				update p_EventRegistration_FacilityRooms
				Set RoomName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.RoomName#">,
					Capacity = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.RoomCapacity#">,
					RoomFees = <cfqueryparam cfsqltype="cf_sql_double" value="#FORM.RoomFees#">,
					Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
					lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityRoomID#">
			</cfquery>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&UserAction=RoomUpdated&Successful=True&FacilityID=#URL.FacilityID#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addfacilityroom" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
				Order by FacilityName ASC
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getCaterers")>
				<cfset temp = StructDelete(Session, "getSelectedCaterer")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&FacilityID=#URL.FacilityID#" addtoken="false">
			</cfif>


			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Meeting Room is active or not in the database."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacilityroom&FormRetry=True&FacilityID=#URL.FacilityID#&FacilityRoomID=#URL.FacilityRoomID#" addtoken="false">
			</cfif>

			<cfquery name="updateFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				insert into p_EventRegistration_FacilityRooms(RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdateBy, Site_ID, Facility_ID)
				values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.RoomName#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.RoomCapacity#">,
				<cfqueryparam cfsqltype="cf_sql_double" value="#FORM.RoomFees#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
				)
			</cfquery>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&UserAction=RoomCreated&Successful=True&FacilityID=#URL.FacilityID#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addfacility" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>

		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getCaterers")>
				<cfset temp = StructDelete(Session, "getSelectedCaterer")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.default" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Facility is active in the database or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.addfacility&FormRetry=True" addtoken="false">
			</cfif>

			<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/GoogleGeoCoder")>
			<cfset AddressGeoCoded = #GeoCodeCFC.GeoCodeAddress(Form.PhysicalAddress, FORM.PhysicalCity, FORM.PhysicalState, FORM.PhysicalZipCode)#>
			<cfif AddressGeoCoded[1].ErrorMessage NEQ "OK">
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.addfacility&FormRetry=True" addtoken="false">
			<cfelse>
				<cfset CombinedPhysicalAddress = #AddressGeoCoded[1].AddressStreetNumber# & " " & #AddressGeoCoded[1].AddressStreetNameShort#>

				<cfquery name="updateFacilityInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					insert into p_EventRegistration_Facility(FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreataed, lastUpdateBy, Active)
						VALUES(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.FacilityName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.AddressGeoCoded[1].AddressCityName)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameShort)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.AddressGeoCoded[1].AddressZipCode)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryVoiceNumber#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BusinessWebsite#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactPhoneNumber#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactEmail#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">)
				</cfquery>

				<cfif isDefined("Variables.AddressGeoCoded[1].AddressZipCodeFour")>
					<cfquery name="updateCatererInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Facility
						Set PhysicalZip4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.AddressGeoCoded[1].AddressZipCodeFour)#">
						Where  TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.generatedkey#">
					</cfquery>
				</cfif>

				<cfquery name="updateFacilityGeoCode" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Facility
					Set GeoCode_Latitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLatitude)#" cfsqltype="cf_sql_varchar">,
						GeoCode_Longitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLongitude)#" cfsqltype="cf_sql_varchar">,
						<cfif isDefined("Variables.AddressGeoCoded[1].AddressTownshipNameLong")>
							GeoCode_Township = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressTownshipNameLong)#" cfsqltype="cf_sql_varchar">,
						</cfif>
						<cfif isDefined("Variables.AddressGeoCoded[1].NeighborhoodNameLong")>
							GeoCode_Neighborhood = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].NeighborhoodNameLong)#" cfsqltype="cf_sql_varchar">,
						</cfif>
						GeoCode_StateLongName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameLong)#" cfsqltype="cf_sql_varchar">,
						GeoCode_CountryShortName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCountryNameShort)#" cfsqltype="cf_sql_varchar">,
						isAddressVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
						lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#Session.Mura.Fname# #Session.Mura.Lname#" cfsqltype="cf_sql_varchar">
					Where  TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.generatedkey#">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.default&UserAction=InformationUpdated&Successful=True" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

</cfcomponent>