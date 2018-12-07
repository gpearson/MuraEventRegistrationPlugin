<cfset dbTableSiteConfig = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_SiteConfig')>
<cfscript>
	dbTableSiteConfig.dropColumn(column='Google_ReCaptchaEnabled')
	.addColumn(column='CFServerJarFiles',dataType='varchar',length='255',nullable=true);
</cfscript>