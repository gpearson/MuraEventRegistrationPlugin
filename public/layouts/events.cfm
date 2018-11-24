<cfset request.layout = false>
<cfoutput>
	<cfif StructKeyExists(session, "MuraPreviousUser")>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Viewing Website As Other User</h3>
			</div>
			<div class="art-blockcontent"><p>
				<div class="alert-box success">
					<span>Logged In As:</span> #Session.Mura.FName# #Session.Mura.LName#.<br />To return back to your user account, click <a href="/plugins/#variables.Framework.package##buildURL('public:events.viewavailableevents')#&PerformAction=LogoutUser" class="art-button">here</a>
				</div>
			</div>
		</div>
	</cfif>
	#body#
</cfoutput>
