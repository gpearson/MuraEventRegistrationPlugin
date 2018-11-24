<cfif not isDefined("URL.PerformAction") and not isDefined("URL.EventRegistrationaction")>
	<cflocation addtoken="true" url="/index.cfm">
<cfelseif isDefined("URL.PerformAction")>
	<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
	<cfset GetAllUserGroups = #$.getBean( 'userManager' ).getUserGroups( rc.$.siteConfig('siteID'), 1 )#>
	<cfquery name="getSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select UserID, Fname, Lname, UserName, Password, PasswordCreated, Email, Company, JobTitle, mobilePhone, Website, Type, subType, Ext, ContactForm, Admin, S2, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, Perm, InActive, isPublic, SiteID, Subscribe, notes, description, interests, keepPrivate, photoFileID, IMName, IMService, created, remoteID, tags, tablist, InActive
		From tusers
		Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_varchar">
		Order by Lname ASC
	</cfquery>
	<cfquery name="getUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select GroupID
		From tusersmemb
		Where UserID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfquery name="getSchoolDistricts" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select OrganizationName, StateDOE_IDNumber
		From eMembership
		Order by OrganizationName ASC
	</cfquery>
	<cfswitch expression="#URL.PerformAction#">
		<cfcase value="ChangePassword">
			<cfoutput>
				<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Change User's Password</h3>
					</div>
					<div class="art-blockcontent">
						<div class="alert-box notice">Please complete the following information to change the user's password for this website.</div>
						<uForm:form action="" method="Post" id="UpdateUserAccount" errors="#Session.FormErrors#" errorMessagePlacement="both"
							commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
							cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:users&compactDisplay=false"
							submitValue="Change Account Password" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
							<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
							<input type="hidden" name="RecNo" value="#URL.RecNo#">
							<input type="hidden" name="UserName" value="#getSelectedUser.UserName#">
							<input type="hidden" name="formSubmit" value="true">
							<uForm:fieldset legend="User Account Fields">
								<uForm:field label="First Name" name="Fname" isRequired="true" isDisabled="true" maxFieldLength="35" value="#getSelectedUser.Fname#" type="text" hint="User's First Name" />
								<uForm:field label="Last Name" name="Lname" isRequired="true" isDisabled="true" maxFieldLength="70" value="#getSelectedUser.Lname#" type="text" hint="User's Last Name" />
								<uForm:field label="Username" name="UserName" isRequired="true" isDisabled="true" maxFieldLength="70" value="#getSelectedUser.UserName#" type="text" hint="User's Login Username" />
								<uForm:field label="Email Address" name="Email" isRequired="true" isDisabled="true" maxFieldLength="70" value="#getSelectedUser.Email#" type="text" hint="User's Email Address" />
							</uForm:fieldset>
							<uForm:fieldset legend="Password Fields">
								<uform:field label="Desired Password" name="Password" type="Password" isRequired="true" hint="Password for user to login website with?" />
								<uform:field label="Verify Password" name="VerifyPassword" type="Password" isRequired="true" hint="Password for user to login website with?" />
							</uForm:fieldset>
						</uForm:form>
					</div>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="Edit">
			<cfoutput>
				<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Update User's Information</h3>
					</div>
					<div class="art-blockcontent">
						<div class="alert-box notice">Please complete the following information to update the user's information for this website.</div>
						<uForm:form action="" method="Post" id="UpdateUserAccount" errors="#Session.FormErrors#" errorMessagePlacement="both"
							commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
							cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:users&compactDisplay=false"
							submitValue="Update Account" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
							<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
							<input type="hidden" name="RecNo" value="#URL.RecNo#">
							<input type="hidden" name="formSubmit" value="true">
							<uForm:fieldset legend="Required Fields">
								<uForm:field label="First Name" name="Fname" isRequired="true" maxFieldLength="35" value="#getSelectedUser.Fname#" type="text" hint="User's First Name" />
								<uForm:field label="Last Name" name="Lname" isRequired="true" maxFieldLength="70" value="#getSelectedUser.Lname#" type="text" hint="User's Last Name" />
								<uForm:field label="Username" name="UserName" isRequired="true" isDisabled="false" maxFieldLength="70" value="#getSelectedUser.UserName#" type="text" hint="User's Login Username" />
								<uForm:field label="Email Address" name="Email" isRequired="true" maxFieldLength="70" value="#getSelectedUser.Email#" type="text" hint="User's Email Address" />
							</uForm:fieldset>
							<uForm:fieldset legend="Optional Fields">
								<uform:field label="School District" name="Company" type="select" hint="School District employeed at?">
									<uform:option display="-- Business Organization" value="0000" />
									<uform:option display="-- Higher Education Organization" value="0001" />
									<uform:option display="-- Another State K-12 School District" value="0002" />
									<cfloop query="getSchoolDistricts">
										<cfif getSelectedUser.Company EQ getSchoolDistricts.OrganizationName>
											<uform:option display="#getSchoolDistricts.OrganizationName#" value="#getSchoolDistricts.StateDOE_IDNumber#" isSelected="true" />
										<cfelse>
											<uform:option display="#getSchoolDistricts.OrganizationName#" value="#getSchoolDistricts.StateDOE_IDNumber#" />
										</cfif>
									</cfloop>
								</uform:field>
								<uForm:field label="Job Title" name="JobTitle" type="text" value="#getSelectedUser.JobTitle#" maxFieldLength="50" hint="User's Job Title" />
								<uForm:field label="Mobile Phone Number" name="mobilePhone" type="text" value="#getSelectedUser.mobilePhone#" maxFieldLength="14" mask="(999) 999-9999" hint="User's Contact Number in case of calcellation of event" />
							</uForm:fieldset>
							<uForm:fieldset legend="Account Membership">
								<uForm:field name="Memberships" type="checkboxgroup">
									<cfif getUserMemberships.RecordCount>
										<cfloop query="GetAllUserGroups">
											<cfquery name="getUserMembership" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select UserID, GroupID
												From tusersmemb
												Where UserID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_varchar"> and
													GroupID = <cfqueryparam value="#GetAllUserGroups.UserID#" cfsqltype="cf_sql_varchar">
											</cfquery>
											<cfif getUserMembership.RecordCount>
												<cfquery name="getGroupID" dbtype="query">
													Select * from GetAllUserGroups
													Where UserID = <cfqueryparam value="#getUserMembership.GroupID#" cfsqltype="cf_sql_varchar">
												</cfquery>
												<uForm:checkbox label="#GetAllUserGroups.GroupName#" value="#getGroupID.UserID#" isChecked="1" />
											<cfelse>
												<uForm:checkbox label="#GetAllUserGroups.GroupName#" value="#GetAllUserGroups.UserID#" isChecked="0" />
											</cfif>
										</cfloop>
									<cfelse>
										<cfloop query="GetAllUserGroups">
											<uForm:checkbox label="#GetAllUserGroups.GroupName#" value="#GetAllUserGroups.UserID#" />
										</cfloop>
									</cfif>
								</uForm:field>
							</uForm:fieldset>
							<uForm:fieldset legend="Informational Fields">
								<uForm:field label="Account Active" name="Active" type="select" isDisabled="false" hint="User Account Active">
									<cfif getSelectedUser.InActive EQ 0>
										<uform:option display="Yes" value="0" isSelected="true" />
										<uform:option display="No" value="1" />
									<cfelse>
										<uform:option display="Yes" value="0"  />
										<uform:option display="No" value="1" isSelected="true" />
									</cfif>
								</uForm:field>
								<uForm:field label="Last Login" name="LastLogin" type="text" isDisabled="true" value="#DateFormat(getSelectedUser.LastLogin, 'FULL')#" hint="User's Last Login Date" />
								<uForm:field label="Last Update" name="LastUpdate" type="text" isDisabled="true" value="#DateFormat(getSelectedUser.LastUpdate, 'FULL')#" hint="User's Last Account Update Date" />
								<uForm:field label="Last Update By" name="LastUpdateBy" type="text" isDisabled="true" value="#getSelectedUser.LastUpdateBy#" hint="User's Last Account Last Update By" />
								<uForm:field label="Account Created" name="created" type="text" isDisabled="true" value="#DateFormat(getSelectedUser.created, 'FULL')#" hint="User's Account Created Date" />
							</uForm:fieldset>
						</uForm:form>
					</div>
				</div>
			</cfoutput>
		</cfcase>
	</cfswitch>
</cfif>