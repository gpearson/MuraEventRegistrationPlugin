<cfsilent>
<!---

--->
</cfsilent>

<cfif isDefined("URL.PerformAction")>
	<cfswitch expression="#URL.PerformAction#">
		<cfcase value="LogoutUser">
			<cfset StructDelete(session, "Mura", "True")>
			<cfset userLogin = application.serviceFactory.getBean("userUtility").loginByUserID("#Session.MuraPreviousUser.UserID#", "#rc.$.siteConfig('siteID')#")>
			<cfset StructDelete(session, "MuraPreviousUser", "True")>
			<cflocation addtoken="true" url="#BuildURL('admin:main.default')#">
		</cfcase>
	</cfswitch>
</cfif>
